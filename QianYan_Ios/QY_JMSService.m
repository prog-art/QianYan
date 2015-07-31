//
//  QY_JMSService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JMSService.h"
#import "JRMDataFormatUtils.h"
#import "JRMDataParseUtils.h"

#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

#import "QY_Common.h"

#import "QY_jms_parameter_key_marco.h"
#import "QY_jms_marco.h"

NSString *const kNotificationNameReceiveCamerasState = @"kNotificationNameReceiveCamerasState" ;

@interface QY_JMSService ()<GCDAsyncSocketDelegate>

@property (nonatomic) GCDAsyncSocket *jms_tcp_socket ;

@property (copy) QYResultBlock connectComplection ;

- (NSData *)JMSLoginData ;

@end

@implementation QY_JMSService

+ (instancetype)shareInstance {
    static QY_JMSService *sharedInstace = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[QY_JMSService alloc] init] ;
    }) ;
    return sharedInstace ;
}

- (instancetype)init {
    if ( self = [super init]) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    
}

#pragma mark - getter & setter

@synthesize jms_ip = _jms_ip ;
@synthesize jms_port = _jms_port ;

- (NSString *)jms_ip {
    return _jms_ip ? : JMS_IP ;
}

- (NSString *)jms_port {
    return _jms_port ? : JMS_PORT ;
}

- (void)configIp:(NSString *)ip Port:(NSString *)port {
    if ( !ip && !port ) {
        [NSException raise:@"ip port info config exception" format:@"空的ip和port传入"] ;
        return ;
    }
    _jms_ip = ip ;
    _jms_port = port ;
}

- (GCDAsyncSocket *)jms_tcp_socket {
    if ( !_jms_tcp_socket ) {
        _jms_tcp_socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()] ;
    }
    return _jms_tcp_socket ;
}

- (NSString *)device_id {
#warning test
    return @"10000133" ;
}

- (NSData *)JMSLoginData {
    NSMutableData *loginData = [NSMutableData data] ;
    {
        NSData *device_idData = [JRMDataFormatUtils formatStringValueData:self.device_id
                                                                    toLen:JMS_DATA_LEN_OF_KEY_DEVICE_ID];
        NSData *device_typeData = [JRMDataFormatUtils formatIntegerValueData:JMS_DEVICE_IOS
                                                                       toLen:JMS_DATA_LEN_OF_KEY_DEVICE_TYPE] ;
        NSData *keyData = [JRMDataFormatUtils formatStringValueData:JMS_LOGIN_KEY
                                                              toLen:JMS_DATA_LEN_OF_KEY_KEY] ;
        
        [@[device_idData,device_typeData,keyData] enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
            [loginData appendData:data] ;
        }] ;
    }
    
    return loginData ;
}

#pragma mark - JMS

#warning 这部分是根据比较乱的文档写的,无法提取出公共部分，不过才3个接口，无伤大雅。

- (void)getCameraStateById:(NSString *)cameraId {
    static NSUInteger type = 6010 ;
    static NSUInteger cmd = 1340 ;
    
    NSData *cameraIdData = [JRMDataFormatUtils formatStringValueData:cameraId
                                                               toLen:JMS_DATA_LEN_OF_KEY_CAMID] ;
    NSData *typeData = [JRMDataFormatUtils formatIntegerValueData:type
                                                            toLen:JMS_DATA_LEN_OF_KEY_TYPE] ;
    NSData *timeData = [JRMDataFormatUtils formatIntegerValueData:0
                                                            toLen:JMS_DATA_LEN_OF_KEY_TIME] ;
    
    NSData *lengthData = [JRMDataFormatUtils formatIntegerValueData:(JMS_DATA_LEN_OF_KEY_CMD_LENGTH + JMS_DATA_LEN_OF_KEY_CMD)
                                                              toLen:JMS_DATA_LEN_OF_KEY_LENGTH] ;
    NSData *cmdLengthData = [JRMDataFormatUtils formatIntegerValueData:JMS_DATA_LEN_OF_KEY_CMD
                                                                 toLen:JMS_DATA_LEN_OF_KEY_CMD_LENGTH] ;
    NSData *cmdData = [JRMDataFormatUtils formatIntegerValueData:cmd
                                                           toLen:JMS_DATA_LEN_OF_KEY_CMD] ;
    
    NSArray *dataArr = @[cameraIdData,typeData,timeData,lengthData,cmdLengthData,cmdData] ;
    
    NSMutableData *packageData = [NSMutableData data] ;
    
    [dataArr enumerateObjectsUsingBlock:^(NSData *data , NSUInteger idx, BOOL *stop) {
        [packageData appendData:data] ;
    }] ;
    
    [self startWorkWithData:packageData Tag:-1] ;
    
    //读到了 data =
    //sender_id = <74303030 30303030 30303030 31313200
    //message_type = 0000177a (6010)
    //message_time = 55b0aa6c
    //data len = 00000008
    //data =
    //  data_len = 0007
    //  cmd = 0000 053d (1341)
    //  3000>
    
}

- (void)getCamerasStateByIds:(NSSet *)cameraIds {
    assert(cameraIds) ;
    assert([cameraIds count] != 0) ;
    
    static NSUInteger type = 6013 ;
    NSArray *cameraIDs = [cameraIds allObjects] ;
    
    
    NSData *cameraIdData = [JRMDataFormatUtils formatStringValueData:cameraIDs[0]
                                                               toLen:JMS_DATA_LEN_OF_KEY_CAMID] ;
    NSData *typeData = [JRMDataFormatUtils formatIntegerValueData:type
                                                            toLen:JMS_DATA_LEN_OF_KEY_TYPE] ;
    NSData *timeData = [JRMDataFormatUtils formatIntegerValueData:0
                                                            toLen:JMS_DATA_LEN_OF_KEY_TIME] ;
    
    
    NSString *cameraIdString = [cameraIDs componentsJoinedByString:@"&"] ;
    cameraIdString = [NSString stringWithFormat:@"%@&",cameraIdString] ;
    
    NSData *CamData = [cameraIdString dataUsingEncoding:NSUTF8StringEncoding] ;
    NSData *lengthData = [JRMDataFormatUtils formatIntegerValueData:[CamData length]
                                                              toLen:JMS_DATA_LEN_OF_KEY_LENGTH] ;
    
    NSArray *dataArr = @[cameraIdData,typeData,timeData,lengthData,CamData] ;
    
    NSMutableData *packageData = [NSMutableData data] ;
    
    [dataArr enumerateObjectsUsingBlock:^(NSData *data , NSUInteger idx, BOOL *stop) {
        [packageData appendData:data] ;
    }] ;
    
    [self startWorkWithData:packageData Tag:-2] ;
    //读到了 data = <31303030 30313333 00000000 00000000
    // type = 0000177e (6014)
    // time = 00000000
    // data len = 00000002
    // data = 5b5d>
    
    //<31303030 30313333 00000000 00000000
    // type 0000177e
    // time 00000000
    // data len = 0000003b
    // data = 5b7b0a09 09226a69 706e635f 6964223a 09227430 30303030 30303030 30303131 32222c0a 0909226a 69706e63 5f737461 74757322 3a09300a 097d5d>
    
}

- (void)getCameraThumbnailById:(NSString *)cameraId {
    static NSUInteger type = 6030 ;
    static NSUInteger cmd = 1360 ;
    
    NSData *cameraIdData = [JRMDataFormatUtils formatStringValueData:cameraId
                                                               toLen:JMS_DATA_LEN_OF_KEY_CAMID] ;
    NSData *typeData = [JRMDataFormatUtils formatIntegerValueData:type
                                                            toLen:JMS_DATA_LEN_OF_KEY_TYPE] ;
    NSData *timeData = [JRMDataFormatUtils formatIntegerValueData:0
                                                            toLen:JMS_DATA_LEN_OF_KEY_TIME] ;
    
    NSData *lengthData ;
    NSMutableData *camData = [NSMutableData data];
    {
        NSData *cam_lengthData = [JRMDataFormatUtils formatIntegerValueData:(JMS_DATA_LEN_OF_KEY_CMD + JMS_DATA_LEN_OF_KEY_CAMDATA_DATA)
                                                                      toLen:JMS_DATA_LEN_OF_KEY_CAMDATA_LENGTH];
        NSData *cam_cmdData = [JRMDataFormatUtils formatIntegerValueData:cmd
                                                                   toLen:JMS_DATA_LEN_OF_KEY_CMD] ;
        NSData *cam_dataData = [JRMDataFormatUtils formatStringValueData:@"1"
                                                                   toLen:JMS_DATA_LEN_OF_KEY_CAMDATA_DATA] ;
        
        NSArray *camDataArr = @[cam_lengthData,cam_cmdData,cam_dataData] ;
        [camDataArr enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
            [camData appendData:data] ;
        }] ;
        lengthData = [JRMDataFormatUtils formatIntegerValueData:[camData length]
                                                          toLen:JMS_DATA_LEN_OF_KEY_LENGTH] ;
    }
    
    NSMutableData *packageData = [NSMutableData data] ;
    
    NSArray *dataArr = @[cameraIdData,typeData,timeData,lengthData,camData] ;
    
    [dataArr enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
        [packageData appendData:data] ;
    }] ;
    
    [self startWorkWithData:packageData Tag:-3] ;
}

#pragma mark - d(^_^o)

- (void)startWorkWithData:(NSData *)data Tag:(long)tag {
    QYDebugLog(@"") ;
    
    if ( [self.jms_tcp_socket isConnected]) {
        QYDebugLog(@"data = %@",data) ;
        [self.jms_tcp_socket writeData:data withTimeout:10 tag:tag] ;
    } else {
        QYDebugLog(@"JMS未连接") ;
        
        [self connectToJMSWithComplection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"JMS连接成功") ;
                [self startWorkWithData:data Tag:tag] ;
            } else {
                QYDebugLog(@"JMS链接失败 error = %@",error) ;
//                complection(nil,error) ;                
            }
            
        }] ;
        
    }
    
}

- (void)connectToJMSHost:(NSString *)jms_ip Port:(NSString *)jms_port Complection:(QYResultBlock)complection {
    QYDebugLog(@"目标JMS服务器:%@:%@",jms_ip,jms_port) ;
    self.connectComplection = complection ;
    
    NSError *error ;
    [self.jms_tcp_socket connectToHost:jms_ip onPort:[jms_port integerValue] error:&error] ;
}

- (void)connectToJMSWithComplection:(QYResultBlock)complection {
    QYDebugLog(@"开始重新连接") ;
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    [self connectToJMSHost:self.jms_ip Port:self.jms_port Complection:complection] ;
}


#pragma mark - GCDAsyncSocketDelegate


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    QYDebugLog(@"连接到jms服务器 %@:%hu",host,port) ;
    
    //发送登录JMS信息
    NSData *loginData = self.JMSLoginData ;
    
    QYDebugLog(@"JMS LOGIN DATA = %@",loginData)
    [sock writeData:loginData withTimeout:10 tag:1] ;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    QYDebugLog(@"读到了 data = %@",data) ;
    
    NSString *sender_id = [JRMDataParseUtils getStringValue:data range:NSMakeRange(0, 16)] ;
    NSInteger type = [JRMDataParseUtils getIntegerValue:data range:NSMakeRange(16, 4)] ;
    NSInteger time = [JRMDataParseUtils getIntegerValue:data range:NSMakeRange(20, 4)] ;
    NSInteger Datalen = [JRMDataParseUtils getIntegerValue:data range:NSMakeRange(24, 4)] ;
    NSData *camData = [data subdataWithRange:NSMakeRange(28, Datalen)] ;
    switch (tag) {
        case -1 : {
            NSString *state = [JRMDataParseUtils getStringValue:camData range:NSMakeRange(6, 2)] ;
            
            NSLog(@"state = %@",[state integerValue] == 0 ?@"离线":@"在线") ;
            
            
            
            break ;
        }
            
        case -2 : {
            NSString *lastString = [JRMDataParseUtils getStringValue:data range:NSMakeRange(28, Datalen)] ;
            NSLog(@"lastString = %@",lastString) ;
            
            NSArray *stateArr = [NSJSONSerialization JSONObjectWithData:camData options:kNilOptions error:NULL] ;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameReceiveCamerasState object:stateArr] ;
            
            break ;
        }
            
        case -3 : {
            NSLog(@"camData = %@",camData) ;
            break ;
        }
        default:
            break;
    }
    

    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if ( tag != 1 ) {
        QYDebugLog(@"data已经发送到了jms服务器") ;
        [sock readDataWithTimeout:10.0f tag:tag] ;
    } else {
        QYDebugLog(@"jms login data 已经发送到了jms服务器") ;
//        [sock readDataWithTimeout:10.0f tag:tag] ;
        if ( self.connectComplection ) {
            self.connectComplection(true,nil) ;
            self.connectComplection = nil ;
        }
    }
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    QYDebugLog(@"JMS连接断开 error = %@",err) ;
}


@end