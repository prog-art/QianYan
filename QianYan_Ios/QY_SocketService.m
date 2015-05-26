//
//  QY_SocketService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//


#import "QY_SocketService.h"
#import "QY_JDASSocketDelegater.h"
#import "QY_JRMSocketDelegater.h"
#import "QYUtils.h"
#import "QYNotify.h"

#import "QY_JRMDataPacketFactor.h"

#import "QY_jclient_jrm_protocol_Marco.h"

static NSString *JRM_HostName ;
static NSUInteger JRM_Port ;

@interface QY_SocketService () <QY_JDASSocketDelegaterDelegate>{
    AsyncSocket *_JRMSocket ;
    AsyncSocket *_JDASSocket ;
}

@property AsyncSocket *JRMSocket ;
@property AsyncSocket *JDASSocket ;
@property (weak) QYNotify *notify ;

@end

@implementation QY_SocketService

+ (instancetype)shareInstance {
    static QY_SocketService *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QY_SocketService alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

- (instancetype)init {
    self = [super init] ;
    if ( self ) {
        _JRMSocket = [[AsyncSocket alloc] init] ;
        _JDASSocket = [[AsyncSocket alloc] init] ;
        
        _notify = [QYNotify shareInstance] ;
    }
    return  self ;
}

#pragma mark - JDAS Socket

- (BOOL)connectToJDASHost:(NSError *__autoreleasing *)error {
    QY_JDASSocketDelegater *delegater = [[QY_JDASSocketDelegater alloc] initWithDelegate:self];
    _JDASSocket.delegate = delegater ;
    
    BOOL result = [self connectToHostName:JDAS_HOST_IP onPort:JDAS_HOST_PORT error:error withSocket:_JDASSocket] ;
    
    return result ;
}

- (void)getJRMIPandJRMPORT {
    QYDebugLog() ;
    
    Byte testByte[] = { 0x00 , 0x00 , 0x02 , 0xd2 } ;
    NSData *data = [NSData dataWithBytes:testByte length:sizeof(testByte)/sizeof(Byte)] ;
    
    if ( _JDASSocket ) {
        [_JDASSocket writeData:data withTimeout:10 tag:0] ;
    }
}

#pragma mark - Normal Socket

- (void)disconnectedSocket:(AsyncSocket *)socket {
    QYDebugLog(@"主动断开socket的连接") ;
    if ( socket ) {
        [socket disconnect] ;
    }
}

#pragma mark - JRM Socket

/**
 *  [同步]连接JRM服务器。
 *
 *  @param error
 *
 *  @return 连接结果
 */
- (BOOL)connectToJRMHost:(NSError *__autoreleasing *)error {
    QYDebugLog() ;
    
    if ( [_JDASSocket isConnected]) {
        QYDebugLog(@"JDAS服务器正在连接,稍后再试") ;
        return FALSE ;
    }
    
    QY_JRMSocketDelegater *delegater = [[QY_JRMSocketDelegater alloc] initWithDelegate:self.delegate] ;
    _JRMSocket.delegate = delegater ;
    
    BOOL result = [self connectToHostName:JRM_HostName onPort:JRM_Port error:error withSocket:_JRMSocket] ;
    return result ;
}

- (BOOL)isJRMSocketConnected {
    if ( !_JRMSocket ) return FALSE ;
    return [_JRMSocket isConnected] ;
}

- (void)sendData:(NSData *)data WithTag:(JRM_REQUEST_OPERATION_TYPE)operationType {
    QYDebugLog(@"will write data = %@ with operation = %ld",data,operationType) ;
    
    if ( [_JRMSocket isConnected] ) {
        [_JRMSocket writeData:data withTimeout:10 tag:operationType] ;
    } else {
        QYDebugLog(@"无连接") ;
    }
}

//2.1.1 设备登录
- (void)deviceLoginRequest {
    QYDebugLog() ;
    
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN
                                          Parameters:nil
                                      ParameterCount:0] ;
    WEAKSELF
    [QYUtils runAfterSecs:1 block:^{
        [weakSelf sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN] ;
    }] ;
}

//2.5.1 用户注册
- (void)userRegisteRequestWithName:(NSString *)username Psd:(NSString *)password {
    QYDebugLog() ;
    
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_USER_REGISTE
                                                         Parameters:@{ParameterKey_username:username,
                                                                      ParameterKey_password:password}
                                                     ParameterCount:2] ;
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_USER_REGISTE] ;
}

//2.5.2 用户登录
- (void)userLoginRequestWithName:(NSString *)username Psd:(NSString *)password {
    QYDebugLog() ;
    
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_USER_LOGIN
                                                         Parameters:@{ParameterKey_username:username,
                                                                      ParameterKey_password:password}
                                                     ParameterCount:2] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_USER_LOGIN] ;
}

/**
 *  2.5.3 重设用户密码
 *
 *  @param userId      用户Id (string,16bytes)
 *  @param newPassword 新密码 (string,32bytes)
 */
- (void)resetPasswordForUser:(NSString *)userId password:(NSString *)newPassword {
    QYDebugLog() ;
    
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_USER_RESET_PASSWORD
                                                         Parameters:@{ParameterKey_userId:userId,
                                                                      ParameterKey_password:newPassword}
                                                     ParameterCount:2] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_USER_RESET_PASSWORD] ;
}

/**
 *  2.5.4 获取用户jpro服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
- (void)getJPROServerInfoForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_USER_JPRO
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_USER_JPRO] ;
}

/**
 *  2.5.5 获取用户jss服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
- (void)getJSSserverInfoForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_USER_JSS
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_USER_JSS] ;
}

/**
 *  2.5.6 获取相机jpro服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
- (void)getJRPOserverInfoForCamera:(NSString *)jipnc_Id {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JPRO
                                                         Parameters:@{ParameterKey_jipncId:jipnc_Id}
                                                     ParameterCount:1] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JPRO] ;
}

/**
 *  2.5.7 获取相机jss服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
- (void)getJSSserverInfoForCamera:(NSString *)jipnc_Id {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JSS
                                                         Parameters:@{ParameterKey_jipncId:jipnc_Id}
                                                     ParameterCount:1];
    //    = [QY_JRMDataPacketFactor getUserLoginDataWithUserName:username password:password] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_JSS] ;
}

/**
 *  2.5.8 检查用户名是否绑定手机号
 *
 *  @param username  用户名
 *  @param telephone 手机号
 */
- (void)checkUsernameBindingTelephone:(NSString *)username Telephone:(NSString *)telephone {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_CHECK_USERNAME_B_TEL
                                                         Parameters:@{ParameterKey_username:username,
                                                                      ParameterKey_userPhone:telephone}
                                                     ParameterCount:2] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_CHECK_USERNAME_B_TEL] ;
}

/**
 *  2.5.9 通过用户名获取用户Id
 *
 *  @param username 用户名
 */
- (void)getUserIdByUsername:(NSString *)username {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_USERNAME
                                                         Parameters:@{ParameterKey_username:username}
                                                     ParameterCount:1] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_USERNAME] ;
}

/**
 *  2.5.10 通过手机号获取用户Id
 *
 *  @param telephone 手机号
 */
- (void)getUserIdByTelephone:(NSString *)telephone {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_TEL
                                                         Parameters:@{ParameterKey_userPhone:telephone}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_TEL] ;
}

/**
 *  2.5.11 通过邮箱获取用户Id
 *
 *  @param email 邮箱
 */
- (void)getUserIdByEmail:(NSString *)email {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_EMAIL
                                                         Parameters:@{ParameterKey_userEmail:email}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_ID_BY_EMAIL] ;
}

/**
 *  2.5.12 设置用户手机号
 *
 *  @param userId    用户Id
 *  @param telephone 手机号
 */
- (void)bindingTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_SET_TEL_FOR_USER
                                                         Parameters:@{ParameterKey_userId:userId,
                                                                      ParameterKey_userPhone:telephone}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_SET_TEL_FOR_USER] ;
}

/**
 *  2.5.13 获取用户手机号
 *
 *  @param userId 用户Id
 */
- (void)getTelephoneByUserId:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_TEL_BY_ID
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_TEL_BY_ID] ;
}

/**
 *  2.5.14 验证用户手机号
 *
 *  @param userId     用户Id
 *  @param telephone  手机号
 *  @param verifyCode 验证码
 */
- (void)verifyTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone VerifyCode:(NSString *)verifyCode {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_VALIDATE_USER_TEL
                                                         Parameters:@{ParameterKey_userId:userId,
                                                                      ParameterKey_userPhone:telephone,
                                                                      ParameterKey_verifyCode:verifyCode}
                                                     ParameterCount:3];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_VALIDATE_USER_TEL] ;
}

/**
 *  2.5.15 设置用户昵称
 *
 *  @param userId   用户Id
 *  @param nickName 昵称
 */
- (void)setNicknameForUser:(NSString *)userId Nickname:(NSString *)nickName {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_USER
                                                         Parameters:@{ParameterKey_userId:userId,
                                                                      ParameterKey_userNickname:nickName}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_USER] ;
}

/**
 *  2.5.16 获取用户昵称
 *
 *  @param userId   用户Id
 */
- (void)getNicknameForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_USER_NICKNAME
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_USER_NICKNAME] ;
}

/**
 *  2.5.17 设置用户所在地
 *
 *  @param userId   用户Id
 *  @param location 用户位置 例:@"江苏南京"
 */
- (void)setUserLocationForUser:(NSString *)userId Location:(NSString *)location {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_SET_LOCATION_FOR_USER
                                                         Parameters:@{ParameterKey_userId:userId,
                                                                      ParameterKey_userLocation:location}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_SET_LOCATION_FOR_USER] ;
}

/**
 *  2.5.18 获取用户所在地
 *
 *  @param userId 用户Id
 */
- (void)getUserLocationForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_LOCATION_FOR_USER
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_LOCATION_FOR_USER] ;
}

/**
 *  2.5.19 设置用户个性签名
 *
 *  @param userId 用户Id
 *  @param sign   签名 128byes
 */
- (void)setUserSignForUser:(NSString *)userId Sign:(NSString *)sign {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_SET_SIGN_FOR_USER
                                                         Parameters:@{ParameterKey_userId:userId,
                                                                      ParameterKey_userSign:sign}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_SET_SIGN_FOR_USER] ;
}

/**
 *  2.5.20 获取用户个性签名
 *
 *  @param userId 用户Id
 */
- (void)getUserSignForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_SIGN_FOR_USER
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_SIGN_FOR_USER] ;
}

#warning 待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计
/**
 *  2.5.21 设置用户头像
 *
 *  @param userId 用户Id
 *  @param avatar 头像图片(待处理),头像最大大小
 */
- (void)setUserAvatarForUser:(NSString *)userId image:(UIImage *)avatar {
    NSData *data ;
    //    = [QY_JRMDataPacketFactor getUserLoginDataWithUserName:username password:password] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_SET_AVATAR_FOR_USER] ;
}

#pragma mark - 好友

#warning 待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计待设计设计
/**
 *  2.5.22 获取用户头像
 *
 *  @param userId 用户Id
 */
- (void)getUserAvatarForUser:(NSString *)userId {
    NSData *data ;
    //    = [QY_JRMDataPacketFactor getUserLoginDataWithUserName:username password:password] ;
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_USER_AVATAR] ;
}

/**
 *  2.5.23 获取用户好友列表
 *
 *  @param userId 用户Id
 */
- (void)getUserFriendListForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_USER_FRIENDLIST
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_USER_FRIENDLIST] ;
}

/**
 *  2.5.24 添加好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)createAddRequestToUser:(NSString *)friendId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_ADD_FRIEND
                                                         Parameters:@{ParameterKey_friendId:friendId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_ADD_FRIEND] ;
}

/**
 *  2.5.25 删除好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)deleteFriend:(NSString *)friendId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_DEL_FRIEND
                                                         Parameters:@{ParameterKey_friendId:friendId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_DEL_FRIEND] ;
}




#pragma mark - 相机相关

/**
 *  2.5.26 分享相机给好友
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)shareCamera:(NSString *)cameraId toUser:(NSString *)friendId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_SHARE_CAMERA_TO_FRIEND
                                                         Parameters:@{ParameterKey_jipncId:cameraId,
                                                                      ParameterKey_friendId:friendId}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_SHARE_CAMERA_TO_FRIEND] ;
}

/**
 *  2.5.27 取消相机对好友的分享
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)stopSharingCamera:(NSString *)cameraId toUser:(NSString *)friendId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_CANCEL_SHARING_CAMERA_TO_FRIEND
                                                         Parameters:@{ParameterKey_jipncId:cameraId,
                                                                      ParameterKey_friendId:friendId}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_CANCEL_SHARING_CAMERA_TO_FRIEND] ;
}


/**
 *  2.5.28 获取相机列表
 */
- (void)getCameraListForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_USER_CAMERALIST
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_USER_CAMERALIST] ;
}

/**
 *  2.5.29 用户绑定相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)bindingCameraToCurrentUser:(NSString *)cameraId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_BINDING_CAMERA_FOR_CURRENT_USER
                                                         Parameters:@{ParameterKey_jipncId:cameraId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_BINDING_CAMERA_FOR_CURRENT_USER] ;
}

/**
 *  2.5.30 用户解绑相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)unbindingCameraToCurrentUser:(NSString *)cameraId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_UNBINDING_CAMERA_FOR_CURRENT_USER
                                                         Parameters:@{ParameterKey_jipncId:cameraId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_UNBINDING_CAMERA_FOR_CURRENT_USER] ;
    
}

/**
 *  2.5.31 获取相机的分享列表
 *
 *  @param ownerId  相机拥有者的userId
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraSharingListForOwner:(NSString *)ownerId camera:(NSString *)cameraId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_SHARINGLISE
                                                         Parameters:@{ParameterKey_ownerId:ownerId,
                                                                      ParameterKey_jipncId:cameraId}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_SHARINGLISE] ;
}

/**
 *  2.5.32 获取指定相机信息
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraInformationForCameraId:(NSString *)cameraId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_INFO
                                                         Parameters:@{ParameterKey_jipncId:cameraId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_INFO] ;
}

/**
 *  2.5.33 设置相机昵称
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param nickname jipnc_nickname(string,32bytes)
 */
- (void)setNicknameForCamera:(NSString *)cameraId Nickname:(NSString *)nickname {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_CAMERA
                                                         Parameters:@{ParameterKey_jipncId:cameraId,
                                                                      ParameterKey_jipncNickname:nickname}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_SET_NICKNAME_FOR_CAMERA] ;
}

/**
 *  2.5.34 获取相机拥有者Id
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraOwnerIdForCamera:(NSString *)cameraId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_OWNDERID
                                                         Parameters:@{ParameterKey_jipncId:cameraId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_CAMERA_OWNDERID] ;
}

#pragma mark - User

/**
 *  2.5.35 获取用户名
 *
 *  @param userId 用户Id
 */
- (void)getUsernameForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_USERNAME_BY_ID
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_USERNAME_BY_ID] ;
}

/**
 *  2.5.36 查询登录串号
 *
 *  @param userId 用户Id
 */
- (void)getUserLoginSeriesForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_SERIES_BY_ID
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_SERIES_BY_ID] ;
}

/**
 *  2.5.37 刷新登录串号
 *
 *  @param userId 用户Id
 */
- (void)refreshUserLoginSeriesForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_REFRESH_SERIES_FOR_USER
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_REFRESH_SERIES_FOR_USER] ;
}

#pragma mark - 邮箱绑定

/**
 *  2.5.38 用户绑定邮箱请求
 *
 *  @param userEmail 用户邮箱(string,32byes)
 *  @param userId    用户Id
 */
- (void)requestBindingEmail:(NSString *)userEmail ForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_BINDING_EMAIL_FOR_USER
                                                         Parameters:@{ParameterKey_userEmail:userEmail,
                                                                      ParameterKey_userId:userId}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_BINDING_EMAIL_FOR_USER] ;
}

/**
 *  2.5.39 用户解绑邮箱请求
 *
 *  @param userId 用户Id
 */
- (void)requestUnbindingEmailForUser:(NSString *)userId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_UNBINDING_EMAIL_FOR_USER
                                                         Parameters:@{ParameterKey_userId:userId}
                                                     ParameterCount:1];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_UNBINDING_EMAIL_FOR_USER] ;
}

#pragma mark - 第三方登录

/**
 *  2.5.40 第三方登录获取用户Id
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪
 *  @param openId      该账号类型下全局唯一
 */
- (void)getUserIdForThirdPartLoginUserWithAccountTyoe:(NSString *)accountTyoe openId:(NSString *)openId {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_GET_ID_FOR_THIRD_PART_LOGIN_USER
                                                         Parameters:@{ParameterKey_accountType:accountTyoe,
                                                                      ParameterKey_openId:openId}
                                                     ParameterCount:2];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_GET_ID_FOR_THIRD_PART_LOGIN_USER] ;
}

/**
 *  2.5.41 第三方登录新建账户
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
- (void)newAccountForThirdPartLoginUserWithAccountTyoe:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_NEW_ACCOUNT_FOR_THIRD_PART_LOGIN_USER
                                                         Parameters:@{ParameterKey_accountType:accountType,
                                                                      ParameterKey_openId:openId,
                                                                      ParameterKey_username:username}
                                                     ParameterCount:3];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_NEW_ACCOUNT_FOR_THIRD_PART_LOGIN_USER] ;
}

/**
 *  2.5.42 第三方登录修改用户名
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
- (void)setUsernameForThirdPartLoginWithAccountType:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username {
    NSData *data = [QY_JRMDataPacketFactor getDataWithOperationType:JRM_REQUEST_OPERATION_TYPE_SET_USERNAME_FOR_THIRD_PART_LOGIN_USER
                                                         Parameters:@{ParameterKey_accountType:accountType,
                                                                      ParameterKey_openId:openId,
                                                                      ParameterKey_username:username}
                                                     ParameterCount:3];
    
    [self sendData:data WithTag:JRM_REQUEST_OPERATION_TYPE_SET_USERNAME_FOR_THIRD_PART_LOGIN_USER] ;
}





#pragma mark - JDAS Socket

//连接到服务器
- (BOOL)connectToHostName:(NSString *)hostName onPort:(UInt16)port error:(NSError *__autoreleasing *)error withSocket:(AsyncSocket *)socket{
    QYDebugLog(@"connect To host:port = %@:%d",hostName,port) ;
    if ( nil == socket ) {
        QYDebugLog(@"非法的Socket") ;
        return FALSE ;
    }
    if ( nil == hostName ) {
        QYDebugLog(@"非法的Host") ;
        return FALSE ;
    }    
    
    BOOL result ;
    if ( ![socket isConnected] ) {
        result = [socket connectToHost:hostName onPort:port withTimeout:QIANYAN_HOST_CONNECT_TIMEOUT error:error] ;
        return result ;
    } else {
        QYDebugLog(@"已经连接") ;
        return TRUE ;
    }
}

#pragma mark - QY_JDASSocketDelegaterDelegate

/**
 *  连接上了服务器
 *
 *  @param JDASSocket
 */
- (void)JDASSocketDidConnect:(AsyncSocket *)JDASSocket {
    QYDebugLog(@"JDAS服务器连接成功") ;
}

/**
 *  正常断开连接
 */
- (void)JDASSocketDidNormallyDisconnect {
    QYDebugLog(@"JDAS正常断开连接") ;
}

/**
 *  遇到错误断开连接的
 *
 *  @param error
 */
- (void)JDASSocketDidDisconnectWithError:(NSError *)error {
    QYDebugLog(@"JDAS异常断开连接 %@",error) ;
}

/**
 *  读到了Ip 和 Host
 *
 *  @param host
 *  @param port
 */
- (void)JDASSocketDidReadJRMHost:(NSString *)host port:(NSUInteger)port {
    QYDebugLog(@"读到了 Hostname = %@ , Port = %lu",host,(unsigned long)port) ;
    
    JRM_HostName = host ;
    JRM_Port = port ;
    
    [self disconnectedSocket:_JDASSocket] ;
}

/**
 *  读到了不完整的数据
 */
- (void)JDASSocketReadNonFullData {
    QYDebugLog(@"读到了不完整的数据") ;
}

@end
