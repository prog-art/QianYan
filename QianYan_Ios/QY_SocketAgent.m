//
//  QY_SocketAgent_v2.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_SocketAgent.h"

#import "QY_JRMAPIDescriptor.h"
#import "QY_SocketService.h"

#import "QYUtils.h"
#import "QY_SocketServiceDelegate.h"


@interface QY_SocketAgent ()<QY_SocketServiceDelegate>

@property (copy) QYJRMResponseBlock complection ;

//这里当成功登陆jrm一次后，会有值，通过这个值，可以确定重新连接的等级。
@property (nonatomic) NSString *userName ;
@property (nonatomic) NSString *userPassword ;

@end

@implementation QY_SocketAgent

- (QY_UserReloginDescriptor *)shouldReLoginUserToJRM {
    QY_UserReloginDescriptor *desc = [[QY_UserReloginDescriptor alloc] init];
    if ( self.userName && self.userPassword ) {
        desc.shouldReLogin = TRUE ;
        desc.username = self.userName ;
        desc.password = self.userPassword ;
    } else {
        desc.shouldReLogin = FALSE ;
    }
        
    return desc ;
}

/**
 *  单例
 */
+ (instancetype)shareInstance {
    static QY_SocketAgent *sharedInstance = nil ;
    static dispatch_once_t OnceToken ;
    dispatch_once(&OnceToken, ^{
        sharedInstance = [[QY_SocketAgent alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    self.state = APP_State_Started ;    
    [QY_SocketService shareInstance].delegate = self ;
}


#pragma mark - State Manage 

- (void)setState:(APP_State)state {
    _state = state ;
}

- (void)disconnected {
    [[QY_SocketService shareInstance] disconnectedJRMConnection] ;
}


#pragma mark - QY_JRMAPIInterface

/**
 *  2.1.1  设备登陆
 */
- (void)deviceLoginRequestComplection:(QYResultBlock)complection {
    QYDebugLog("211 设备登录") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 211 ;
    
    QY_JRMAPIDescriptor *api211 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:LOGIN2JRM_REQUEST_CMD
                                                       JRMValues:@[[JRMvalue objectWithValue:@(JOSEPH_DEVICE_JCLIENT)
                                                                                    valueLen:4
                                                                                   valueType:JRMValueType_Number]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:LOGIN2JRM_REPLY_CMD
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        return nil ;
    }] ;
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api211 Complection:^(QY_JRMResponse *response, NSError *error) {
        QYDebugLog(@"APINo = %ld response = %@",APINo,response) ;
        BOOL result = response ? response.success : FALSE ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}


/**
 *  2.1.2 获取jms服务器信息
 */
- (void)getJMSServerInfoComplection:(QYInfoBlock)complection {
    static JRM_REQUEST_OPERATION_TYPE APINo = 212 ;
    
    QY_JRMAPIDescriptor *api212 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:GET_JMSG_ADDR
                                                       JRMValues:nil
                                                      ValueCount:0
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_JmsIP
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_JmsPort
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api212 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *jms_ip = [response valueAtIndex:0] ;
            NSString *jms_port = [response valueAtIndex:1] ;
            [info setObject:jms_ip forKey:jms_ip_key] ;
            [info setObject:jms_port forKey:jms_port_key] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ jms info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.1  用户注册
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)userRegisteRequestWithName:(NSString *)username Psd:(NSString *)password Complection:(QYInfoBlock)complection{
    static JRM_REQUEST_OPERATION_TYPE APINo = 251 ;
    
    QY_JRMAPIDescriptor *api251 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_REG_NEW_USER
                                                       JRMValues:@[[JRMvalue objectWithValue:username
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_username
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:password
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userPassword
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JCLIENT_REG_NEW_USER_REPLY
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JCLIENT_REG_NEW_USER_NAME_INVALID
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api251 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *userId = [response valueAtIndex:0] ;
            [info setObject:userId forKey:ParameterKey_userId] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ jms info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
    
}

/**
 *  2.5.2  用户登录
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)userLoginRequestWithName:(NSString *)username Psd:(NSString *)password Complection:(QYResultBlock)complection{
    static JRM_REQUEST_OPERATION_TYPE APINo = 252 ;
    
    //指定
    QY_JRMAPIDescriptor *api252 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:DEVICE_LOGIN2JRM_CMD
                                                       JRMValues:@[[JRMvalue objectWithValue:username
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_username
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:password
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userPassword
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:DEVICE_LOGIN2JRM_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:DEVICE_LOGIN2JRM_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口

    WEAKSELF
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api252 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        if ( result ) {
            weakSelf.userName = username ;
            weakSelf.userPassword = password ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@",APINo,response) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}


/**
 *  2.5.3 重设用户密码
 *
 *  @param userId      用户Id (string,16bytes)
 *  @param newPassword 新密码 (string,32bytes)
 */
- (void)resetPasswordForUser:(NSString *)userId password:(NSString *)newPassword Complection:(QYResultBlock)complection {
    static JRM_REQUEST_OPERATION_TYPE APINo = 253 ;
    
    //指定
    QY_JRMAPIDescriptor *api253 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_SET_USER_PASS
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:newPassword
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userPassword
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api253 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@",APINo,response) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.4 获取用户jpro服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
- (void)getJPROServerInfoForUser:(NSString *)userId Complection:(QYInfoBlock)complection {
    static JRM_REQUEST_OPERATION_TYPE APINo = 254 ;
    
    //指定
    QY_JRMAPIDescriptor *api254 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_JPRO
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproIp
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproPort
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproPassword
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api254 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *jpro_ip = [response valueAtIndex:0] ;
            NSString *jpro_port = [response valueAtIndex:1] ;
            NSString *jpro_password = [response valueAtIndex:2] ;
            
            [info setObject:jpro_ip forKey:ParameterKey_jproIp] ;
            [info setObject:jpro_port forKey:ParameterKey_jproPort] ;
            [info setObject:jpro_password forKey:ParameterKey_jproPassword] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.5 获取用户jss服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
- (void)getUserJSSInfoByUserId:(NSString *)userId Complection:(QYInfoBlock)complection{
    QYDebugLog(@"255") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 255 ;
    
    //指定
    QY_JRMAPIDescriptor *api255 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_JSS
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssId
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssIp
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssPort4jipnc
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssPort4jclient
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssPassword
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api255 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *jss_id = [response valueAtIndex:0] ;
            NSString *jss_ip = [response valueAtIndex:1] ;
            NSString *jss_port4jipnc = [response valueAtIndex:2] ;
            NSString *jss_port4jclient = [response valueAtIndex:3] ;
            NSString *jss_password = [response valueAtIndex:4] ;
            
            
            [info setObject:jss_id forKey:ParameterKey_jssId] ;
            [info setObject:jss_ip forKey:ParameterKey_jssIp] ;
            [info setObject:jss_port4jipnc forKey:ParameterKey_jssPort4jipnc] ;
            [info setObject:jss_port4jclient forKey:ParameterKey_jssPort4jclient] ;
            [info setObject:jss_password forKey:ParameterKey_jssPassword] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}


/**
 *  2.5.6 获取相机jpro服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
- (void)getCameraJRPOInfoByCameraId:(NSString *)jipnc_Id Complection:(QYInfoBlock)complection {
    QYDebugLog(@"256") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 256 ;
    
    //指定
    QY_JRMAPIDescriptor *api256 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_IPNC_JPRO
                                                       JRMValues:@[[JRMvalue objectWithValue:jipnc_Id
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproIp
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproPort
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jproPassword
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api256 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *jpro_ip = [response valueAtIndex:0] ;
            NSString *jpro_port = [response valueAtIndex:1] ;
            NSString *jpro_password = [response valueAtIndex:2] ;
            
            
            [info setObject:jpro_ip forKey:ParameterKey_jproIp] ;
            [info setObject:jpro_port forKey:ParameterKey_jproPort] ;
            [info setObject:jpro_password forKey:ParameterKey_jproPassword] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.7 获取相机jss服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
- (void)getCameraJSSInfoByCameraId:(NSString *)jipnc_Id Complection:(QYInfoBlock)complection {
    QYDebugLog(@"257") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 257 ;
    
    //指定
    QY_JRMAPIDescriptor *api257 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_IPNC_JSS
                                                       JRMValues:@[[JRMvalue objectWithValue:jipnc_Id
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jipncPassword
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssId
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssPassword
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssIp
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssPort
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api257 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *jipnc_id = [response valueAtIndex:0] ;
            NSString *jipnc_password = [response valueAtIndex:1] ;
            NSString *jss_id = [response valueAtIndex:2] ;
            NSString *jss_password = [response valueAtIndex:3] ;
            NSString *jss_ip = [response valueAtIndex:4] ;
            NSString *jss_port = [response valueAtIndex:5] ;
            
            
            [info setObject:jipnc_id forKey:ParameterKey_jipncId] ;
            [info setObject:jipnc_password forKey:ParameterKey_jipncPassword] ;
            [info setObject:jss_id forKey:ParameterKey_jssId] ;
            [info setObject:jss_password forKey:ParameterKey_jssPassword] ;
            [info setObject:jss_ip forKey:ParameterKey_jssIp] ;
            [info setObject:jss_port forKey:ParameterKey_jssPort] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.8 检查用户名是否绑定手机号
 *
 *  @param username  用户名
 *  @param telephone 手机号
 */
- (void)checkUsernameBindingTelephone:(NSString *)username Telephone:(NSString *)telephone Complection:(QYInfoBlock)complection {
    QYDebugLog(@"258") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 258 ;
    
    //指定
    QY_JRMAPIDescriptor *api258 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_CHECK_USERNAME_PHONE
                                                       JRMValues:@[[JRMvalue objectWithValue:username
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_username
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:telephone
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userPhone
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api258 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *user_id = [response valueAtIndex:0] ;
            
            [info setObject:user_id forKey:ParameterKey_userId] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.9 通过用户名获取用户Id
 *
 *  @param username 用户名
 */
- (void)getUserIdByUsername:(NSString *)username Complection:(QYInfoBlock)complection{
    QYDebugLog(@"259") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 259 ;
    
    //指定
    QY_JRMAPIDescriptor *api259 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_ID
                                                       JRMValues:@[[JRMvalue objectWithValue:username
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_username
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api259 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *user_id = [response valueAtIndex:0] ;
            [info setObject:username forKey:ParameterKey_username] ;
            [info setObject:user_id forKey:ParameterKey_userId] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

#pragma mark - 2510

/**
 *  2.5.10 通过手机号获取用户Id
 *
 *  @param telephone 手机号
 */
- (void)getUserIdByTelephone:(NSString *)telephone Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2510") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 259 ;

    //指定
    QY_JRMAPIDescriptor *api2510 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_ID
                                                       JRMValues:@[[JRMvalue objectWithValue:telephone
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userPhone
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2510 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *user_id = [response valueAtIndex:0] ;
            [info setObject:telephone forKey:ParameterKey_userPhone] ;
            [info setObject:user_id forKey:ParameterKey_userId] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.11 通过邮箱获取用户Id
 *
 *  @param email 邮箱
 */
- (void)getUserIdByEmail:(NSString *)email Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2511") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2511 ;
    
    //指定
    QY_JRMAPIDescriptor *api2511 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_ID_BY_EMAIL
                                                       JRMValues:@[[JRMvalue objectWithValue:email
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userEmail
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2511 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *user_id = [response valueAtIndex:0] ;
            [info setObject:user_id forKey:ParameterKey_userId] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.12 设置用户手机号
 *
 *  @param userId    用户Id
 *  @param telephone 手机号
 */
- (void)bindingTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone Complection:(QYResultBlock)complection {
    QYDebugLog(@"2512") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2512 ;
    
    //指定
    QY_JRMAPIDescriptor *api2512 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_SET_USER_PHONE
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:telephone
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userPhone
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2512 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.13 获取用户手机号
 *
 *  @param userId 用户Id
 */
- (void)getTelephoneByUserId:(NSString *)userId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2513") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2513 ;
    
    //指定
    QY_JRMAPIDescriptor *api2513 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_PHONE
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userPhone
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2513 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *user_phone = [response valueAtIndex:0] ;
            [info setObject:user_phone forKey:ParameterKey_userPhone] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.14 验证用户手机号
 *
 *  @param userId     用户Id
 *  @param telephone  手机号
 *  @param verifyCode 验证码
 */
- (void)verifyTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone VerifyCode:(NSString *)verifyCode Complection:(QYResultBlock)complection {
    QYDebugLog(@"2514") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2514 ;
    
    //指定
    QY_JRMAPIDescriptor *api2514 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_VERIFY_USER_PHONE
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:telephone
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userPhone
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:verifyCode
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_verifyCode
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:3
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2514 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.15 设置用户昵称
 *
 *  @param userId   用户Id
 *  @param nickName 昵称
 */
- (void)setNicknameForUser:(NSString *)userId Nickname:(NSString *)nickName Complection:(QYResultBlock)complection {
    QYDebugLog(@"2515") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2515 ;

    //指定
    QY_JRMAPIDescriptor *api2515 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_SET_USER_NICKNAME
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:nickName
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userNickname
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2515 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.16 获取用户昵称
 *
 *  @param userId   用户Id
 */
- (void)getNicknameByUserId:(NSString *)userId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2516") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2516 ;

    //指定
    QY_JRMAPIDescriptor *api2516 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_NICKNAME
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userNickname
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2516 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *user_nickname = [response valueAtIndex:0] ;
            [info setObject:user_nickname forKey:ParameterKey_userNickname] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.17 设置用户所在地
 *
 *  @param userId   用户Id
 *  @param location 用户位置 例:@"江苏南京"
 */
- (void)setUserLocationForUser:(NSString *)userId Location:(NSString *)location Complection:(QYResultBlock)complection {
    QYDebugLog(@"2517") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2517 ;
    
    //指定
    QY_JRMAPIDescriptor *api2515 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_SET_USER_LOCATION
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:location
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userLocation
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2515 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.18 获取用户所在地
 *
 *  @param userId 用户Id
 */
- (void)getUserLocationByUserId:(NSString *)userId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2518") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2518 ;
    
    //指定
    QY_JRMAPIDescriptor *api2518 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_LOCATION
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userLocation
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2518 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *user_location = [response valueAtIndex:0] ;
            [info setObject:user_location forKey:ParameterKey_userLocation] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.19 设置用户个性签名
 *
 *  @param userId 用户Id
 *  @param sign   签名 128byes
 */
- (void)setUserSignForUser:(NSString *)userId Sign:(NSString *)sign Complection:(QYResultBlock)complection {
    QYDebugLog(@"2519") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2519 ;
    
    //指定
    QY_JRMAPIDescriptor *api2519 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_SET_USER_SIGN
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:sign
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userSign
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2519 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

#pragma mark - 2520

/**
 *  2.5.20 获取用户个性签名
 *
 *  @param userId 用户Id
 */
- (void)getUserSignByUserId:(NSString *)userId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2520") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2520 ;
    
    //指定
    QY_JRMAPIDescriptor *api2520 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_SIGN
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userSign
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2520 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            NSString *user_sign = [response valueAtIndex:0] ;
            [info setObject:user_sign forKey:ParameterKey_userSign] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.21 设置用户头像
 *
 *  @param userId 用户Id
 *  @param avatar 头像图片(待处理),头像最大大小
 */
- (void)setUserAvatarForUser:(NSString *)userId image:(UIImage *)avatar Complection:(QYResultBlock)complection {
    QYDebugLog(@"2521") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2521 ;
    
    //指定
    QY_JRMAPIDescriptor *api2521 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        NSData *imageData = UIImageJPEGRepresentation(avatar, 1.0) ;
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_SET_USER_SCULPTURE
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:@([imageData length])
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_sculptureSize
                                                                                   valueType:JRMValueType_ImageDataLen]]
                                                      ValueCount:2
                                                  AttachmentData:imageData] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2521 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.22 获取用户头像
 *
 *  @param userId 用户Id
 */
- (void)getUserAvatarForUser:(NSString *)userId Complection:(QYObjectBlock)complection {
    static JRM_REQUEST_OPERATION_TYPE APINo = 2522 ;
    
    //指定
    QY_JRMAPIDescriptor *api2522 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_SCULPTURE
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JCLIENT_GET_USER_SCULPTURE_REPLY
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_sculptureSize
                                                                                                                       Type:JRMValueType_ImageDataLen]]
                                                                       attachment:YES] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2522 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSData *attachmentData ;
        if ( result ) {
            attachmentData = response.attachmentData ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ data = %@",APINo,response,attachmentData) ;
        if ( complection ) {
            complection(attachmentData,error) ;
        }
    }] ;
}


/**
 *  2.5.23 获取用户好友列表
 *
 *  @param userId 用户Id
 */
- (void)getUserFriendListForUser:(NSString *)userId Complection:(QYArrayBlock)complection {
    QYDebugLog(@"2523") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2523 ;
    
    //指定
    QY_JRMAPIDescriptor *api2523 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_FRIEND_LIST
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_FriendList(1)
                                                                                                                       Type:JRMValueType_String_List]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2523 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSArray *friendIds ;
        if ( result ) {
            friendIds = [response valueAtIndex:0] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ friends = %@",APINo,response,friendIds) ;
        if ( complection ) {
            complection(friendIds,error) ;
        }
    }] ;
}

/**
 *  2.5.24 添加好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)createAddRequestToUser:(NSString *)friendId Complection:(QYResultBlock)complection {
    QYDebugLog(@"2524") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2524 ;
    
    //指定
    QY_JRMAPIDescriptor *api2524 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_ADD_FRIEND
                                                       JRMValues:@[[JRMvalue objectWithValue:friendId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_FriendId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2524 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.25 删除好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)deleteFriend:(NSString *)friendId Complection:(QYResultBlock)complection {
    QYDebugLog(@"2525") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2525 ;
    
    //指定
    QY_JRMAPIDescriptor *api2525 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_DEL_FRIEND
                                                       JRMValues:@[[JRMvalue objectWithValue:friendId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_FriendId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2525 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}


/**
 *  2.5.26 分享相机给好友
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)shareCamera:(NSString *)cameraId toUser:(NSString *)friendId Complection:(QYResultBlock)complection {
    QYDebugLog(@"2526") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2526 ;
    
    //指定
    QY_JRMAPIDescriptor *api2526 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_ADD_IPNC_SHARE
                                                       JRMValues:@[[JRMvalue objectWithValue:friendId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_FriendId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:cameraId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2526 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.27 取消相机对好友的分享
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)stopSharingCamera:(NSString *)cameraId toUser:(NSString *)friendId Complection:(QYResultBlock)complection {
    QYDebugLog(@"2527") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2527 ;
    
    //指定
    QY_JRMAPIDescriptor *api2527 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_DEL_IPNC_SHARE
                                                       JRMValues:@[[JRMvalue objectWithValue:friendId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_FriendId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:cameraId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2527 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.28 获取相机列表
 */
- (void)getCameraListForUser:(NSString *)userId Complection:(QYArrayBlock)complection {
    QYDebugLog(@"2528") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2528 ;
    
    //指定
    QY_JRMAPIDescriptor *api2528 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_IPNC_LIST
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jipncList(1)
                                                                                                                       Type:JRMValueType_String_List]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2528 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSArray *cameraIds ;
        if ( result ) {
            cameraIds = [response valueAtIndex:0] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ cameraIds = %@",APINo,response,cameraIds) ;
        if ( complection ) {
            complection(cameraIds,error) ;
        }
    }] ;
}

/**
 *  2.5.29 用户绑定相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)bindingCameraToCurrentUser:(NSString *)cameraId Complection:(QYResultBlock)complection {
    QYDebugLog(@"2529") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2529 ;
    
    //指定
    QY_JRMAPIDescriptor *api2529 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_ADD_MY_OWN_IPNC
                                                       JRMValues:@[[JRMvalue objectWithValue:cameraId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_errno
                                                                                                                    Type:JRMValueType_Number]]
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2529 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        if ( !result ) {
            if ( response ) {
                QianYan_ErrorCode errorCode = [[response valueAtIndex:0] integerValue] ;
                error = [NSError QYErrorWithCode:errorCode description:[NSError QYErrorCodeDescription:errorCode]] ;
            }
        }
        
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.30 用户解绑相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)unbindingCameraToCurrentUser:(NSString *)cameraId Complection:(QYResultBlock)complection {
    QYDebugLog(@"2530") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2530 ;
    
    //指定
    QY_JRMAPIDescriptor *api2530 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_DEL_MY_OWN_IPNC
                                                       JRMValues:@[[JRMvalue objectWithValue:cameraId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_errno
                                                                                                                    Type:JRMValueType_Number]]
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2530 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}


#pragma mark 2530

/**
 *  2.5.31 获取相机的分享列表
 *
 *  @param ownerId  相机拥有者的userId
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraSharingListForOwner:(NSString *)ownerId camera:(NSString *)cameraId Complection:(QYArrayBlock)complection {
    QYDebugLog(@"2531") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2531 ;
    
    //指定
    QY_JRMAPIDescriptor *api2531 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_SCULPTURE
                                                       JRMValues:@[[JRMvalue objectWithValue:ownerId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_ownerId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:cameraId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_sharedList(1)
                                                                                                                       Type:JRMValueType_String_List]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2531 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSArray *userIds ;
        if ( result ) {
            userIds = [response valueAtIndex:0] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ userIds = %@",APINo,response,userIds) ;
        if ( complection ) {
            complection(userIds,error) ;
        }
    }] ;
}


/**
 *  2.5.32 获取指定相机信息
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraInformationForCameraId:(NSString *)cameraId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2532") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2532 ;
    
    //指定
    
    QY_JRMAPIDescriptor *api2532 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_IPNC_INFO_WITH_DOMAIN
                                                       JRMValues:@[[JRMvalue objectWithValue:cameraId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jipncNickname
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssIp
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssPort
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jipncMediaAddr
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssId
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jssPassword
                                                                                                                       Type:JRMValueType_String],
                                                                                    [JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jipncPassword
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2532 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *jipnc_id = [response valueAtIndex:0] ;
            NSString *jipnc_nickname = [response valueAtIndex:1] ;
            NSString *jss_ip = [response valueAtIndex:2] ;
            NSString *jss_port = [response valueAtIndex:3] ;
            NSString *jipnc_media_addr = [response valueAtIndex:4] ;
            NSString *jss_id = [response valueAtIndex:5] ;
            NSString *jss_password = [response valueAtIndex:6] ;
            NSString *jipnc_password = [response valueAtIndex:7] ;
            
            [info setObject:jipnc_id forKey:ParameterKey_jipncId] ;
            [info setObject:jipnc_nickname forKey:ParameterKey_jipncNickname] ;
            [info setObject:jss_ip forKey:ParameterKey_jssIp] ;
            [info setObject:jss_port forKey:ParameterKey_jssPort] ;
            [info setObject:jipnc_media_addr forKey:ParameterKey_jipncMediaAddr] ;
            [info setObject:jss_id forKey:ParameterKey_jssId] ;
            [info setObject:jss_password forKey:ParameterKey_jssPassword] ;
            [info setObject:jipnc_password forKey:ParameterKey_jipncPassword] ;
            
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.33 设置相机昵称
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param nickname jipnc_nickname(string,32bytes)
 */
- (void)setNicknameForCamera:(NSString *)cameraId Nickname:(NSString *)nickname Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2533") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2533 ;
    
    //指定
    
    QY_JRMAPIDescriptor *api2533 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_SET_IPNC_NICKNAME
                                                       JRMValues:@[[JRMvalue objectWithValue:cameraId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:nickname
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncNickname
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_jipncNickname
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2533 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *jipnc_nickname = [response valueAtIndex:0] ;
            
            [info setObject:jipnc_nickname forKey:ParameterKey_jipncNickname] ;
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.34 获取相机拥有者Id
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraOwnerIdForCamera:(NSString *)cameraId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2534") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2534 ;
    
    //指定
    
    QY_JRMAPIDescriptor *api2534 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_IPNC_OWNER_ID
                                                       JRMValues:@[[JRMvalue objectWithValue:cameraId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_jipncId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_ownerId
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2534 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *owner_id = [response valueAtIndex:0] ;
            
            [info setObject:owner_id forKey:ParameterKey_ownerId] ;
            
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

#pragma mark - User

/**
 *  2.5.35 获取用户名
 *
 *  @param userId 用户Id
 */
- (void)getUsernameByUserId:(NSString *)userId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2535") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2535 ;
    
    //指定
    
    QY_JRMAPIDescriptor *api2535 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_USER_USERNAME
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_username
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2535 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *user_name = [response valueAtIndex:0] ;
            
            [info setObject:user_name forKey:ParameterKey_username] ;
            
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.36 查询登录串号
 *
 *  @param userId 用户Id
 */
- (void)getUserLoginSeriesForUser:(NSString *)userId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2536") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2536 ;
    
    //指定
    
    QY_JRMAPIDescriptor *api2536 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_OLD_USER_SERIES
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userLoginSeries
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2536 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *user_login_series = [response valueAtIndex:0] ;
            
            
            [info setObject:user_login_series forKey:ParameterKey_userLoginSeries] ;
            
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.37 刷新登录串号
 *
 *  @param userId 用户Id
 */
- (void)refreshUserLoginSeriesForUser:(NSString *)userId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2537") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2537 ;
    
    //指定
    
    QY_JRMAPIDescriptor *api2537 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_GET_NEW_USER_SERIES
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userLoginSeries
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2537 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *user_login_series = [response valueAtIndex:0] ;
            
            
            [info setObject:user_login_series forKey:ParameterKey_userLoginSeries] ;
            
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

#pragma mark - 邮箱绑定

/**
 *  2.5.38 用户绑定邮箱请求
 *
 *  @param userEmail 用户邮箱(string,32byes)
 *  @param userId    用户Id
 */
- (void)requestBindingEmail:(NSString *)userEmail ForUser:(NSString *)userId Complection:(QYResultBlock)complection {
    QYDebugLog(@"2538") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2538 ;
    
    //指定
    QY_JRMAPIDescriptor *api2538 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_BIND_EMAIL_FOR_USER
                                                       JRMValues:@[[JRMvalue objectWithValue:userEmail
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userEmail
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2538 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

/**
 *  2.5.39 用户解绑邮箱请求
 *
 *  @param userId 用户Id
 */
- (void)requestUnbindingEmailForUser:(NSString *)userId Complection:(QYResultBlock)complection {
    QYDebugLog(@"2539") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2539 ;
    
    //指定
    QY_JRMAPIDescriptor *api2539 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_BIND_EMAIL_FOR_USER
                                                       JRMValues:@[[JRMvalue objectWithValue:userId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:1
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2539 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;
}

#pragma mark - 第三方登录

/**
 *  2.5.40 第三方登录获取用户Id
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪
 *  @param openId      该账号类型下全局唯一
 */
- (void)getUserIdForThirdPartLoginUserWithAccountTyoe:(NSString *)accountTyoe openId:(NSString *)openId Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2540") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2540 ;
    
    //指定
    
    QY_JRMAPIDescriptor *api2540 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_LOGIN_BY_OPENID
                                                       JRMValues:@[[JRMvalue objectWithValue:accountTyoe
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_accountType
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:openId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_openId
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:2
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2540 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *userId = [response valueAtIndex:0] ;
            
            [info setObject:userId forKey:ParameterKey_userId] ;
            
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.41 第三方登录新建账户
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
- (void)newAccountForThirdPartLoginUserWithAccountTyoe:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username Complection:(QYInfoBlock)complection {
    QYDebugLog(@"2541") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2541 ;
    
    //指定
    
    QY_JRMAPIDescriptor *api2541 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_REGISTER_BY_OPENID
                                                       JRMValues:@[[JRMvalue objectWithValue:accountType
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_accountType
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:openId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_openId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:username
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_username
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:3
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:@[[JRMvalueDescription descriptionWithLen:JRM_DATA_LEN_OF_KEY_userId
                                                                                                                       Type:JRMValueType_String]]
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2541 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        NSMutableDictionary *info ;
        if ( result ) {
            info = [NSMutableDictionary dictionary] ;
            
            NSString *userId = [response valueAtIndex:0] ;
            
            
            [info setObject:userId forKey:ParameterKey_userId] ;
            
        }
        
        QYDebugLog(@"APINo = %ld response = %@ info = %@",APINo,response,info) ;
        if ( complection ) {
            complection(info,error) ;
        }
    }] ;
}

/**
 *  2.5.42 第三方登录修改用户名
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
- (void)setUsernameForThirdPartLoginWithAccountType:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username Complection:(QYResultBlock)complection {
    QYDebugLog(@"2542") ;
    static JRM_REQUEST_OPERATION_TYPE APINo = 2542 ;
    
    //指定
    QY_JRMAPIDescriptor *api2542 = [QY_JRMAPIDescriptor descriptorWithRequestBlock:^QY_JRMRequest *{
        
        QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:APINo
                                                             Cmd:JCLIENT_SET_USERNAME_BY_OPENID
                                                       JRMValues:@[[JRMvalue objectWithValue:accountType
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_accountType
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:openId
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_openId
                                                                                   valueType:JRMValueType_String],
                                                                   [JRMvalue objectWithValue:username
                                                                                    valueLen:JRM_DATA_LEN_OF_KEY_username
                                                                                   valueType:JRMValueType_String]]
                                                      ValueCount:3
                                                  AttachmentData:nil] ;
        return request ;
    } successRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *successRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_OK
                                                                     descriptions:nil
                                                                       attachment:NO] ;
        return successRule ;
    } failRuleBlock:^QY_JRMAPIPhraseRule *{
        QY_JRMAPIPhraseRule *failRule = [QY_JRMAPIPhraseRule ruleWithTargetCMD:JOSEPH_COMMAND_ERR
                                                                  descriptions:nil
                                                                    attachment:NO] ;
        return failRule ;
    }] ;
    //放权 下层入口
    
    [[QY_SocketService shareInstance] startWithAPIDescriptor:api2542 Complection:^(QY_JRMResponse *response, NSError *error) {
        BOOL result = response ? response.success : FALSE ;
        
        QYDebugLog(@"APINo = %ld response = %@ result = %d",APINo,response,result) ;
        if ( complection ) {
            complection(result,error) ;
        }
    }] ;

}

@end