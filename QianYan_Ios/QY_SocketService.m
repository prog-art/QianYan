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

#import "QY_dataPacketFactor.h"

#import "QY_jclient_jrm_protocol_Marco.h"

static NSString *JRM_HostName ;
static NSUInteger JRM_Port ;

@interface QY_SocketService () {
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
    QY_JDASSocketDelegater *delegater = [[QY_JDASSocketDelegater alloc] init];
    _JDASSocket.delegate = delegater ;

    BOOL result = [self connectToHostName:JDAS_HOST_IP onPort:JDAS_HOST_PORT error:error withSocket:_JDASSocket] ;
    
    return result ;
}

- (void)getJRMIPandJRMPORT {
    QYDebugLog() ;

    {
        //config dataReadComplection
        QY_JDASSocketDelegater *delegater = _JDASSocket.delegate ;
        
        __block AsyncSocket * socket = _JDASSocket ;
        
        WEAKSELF
        QYHostPortBlock complection = ^(NSString *hostName , NSUInteger port) {
            QYDebugLog(@"hostName = %@ port = %lu",hostName,(unsigned long)port) ;
            JRM_HostName = hostName ;
            JRM_Port = port ;
            //断开连接
            [weakSelf disconnectedSocket:socket] ;
        } ;
        delegater.dataReadComplection = complection ;
    }
    
    
    NSData *data ;
    {
        //set write Data
        Byte testByte[] = { 0x00 , 0x00 , 0x02 , 0xd2 } ;
        data = [[NSData alloc] initWithBytes:testByte length:sizeof(testByte)/sizeof(Byte)] ;
    }
    QYDebugLog(@"write data = %@",data) ;
    
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

//2.1.1 设备登录
- (void)deviceLoginRequest {
    QYDebugLog() ;
    
    NSData *data = [QY_dataPacketFactor getDeviceLoginData];
    {
        QYDebugLog(@"will write data = %@",data) ;
    }
    
    [QYUtils runAfterSecs:1 block:^{
        if ( [_JRMSocket isConnected] ) {
            [_JRMSocket writeData:data withTimeout:10 tag:JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN] ;
        } else {
            QYDebugLog(@"无连接") ;
        }
    }] ;
}

//2.5.1 用户注册
- (void)userRegisteRequestWithName:(NSString *)username Psd:(NSString *)password {
    QYDebugLog() ;
    
    NSData *data = [QY_dataPacketFactor getUserRegisteDataWithUserName:username password:password] ;
    {
        QYDebugLog(@"user registe data = %@",data) ;
    }
    
    if ( [_JRMSocket isConnected]) {
        [_JRMSocket writeData:data withTimeout:10 tag:JRM_REQUEST_OPERATION_TYPE_USER_REGISTE] ;
    } else {
        QYDebugLog(@"无连接") ;
    }
}

//2.5.2 用户登录
- (void)userLoginRequestWithName:(NSString *)username Psd:(NSString *)password {
    QYDebugLog() ;
    
    NSData *data = [QY_dataPacketFactor getUserLoginDataWithUserName:username password:password] ;
    {
        QYDebugLog(@"user login data = %@",data) ;
    }
    
    if ( [_JRMSocket isConnected]) {
        [_JRMSocket writeData:data withTimeout:10 tag:JRM_REQUEST_OPERATION_TYPE_USER_LOGIN] ;
    } else {
        QYDebugLog(@"无连接") ;
    }
}

#pragma mark - private method

//连接到服务器
- (BOOL)connectToHostName:(NSString *)hostName onPort:(UInt16)port error:(NSError *__autoreleasing *)error withSocket:(AsyncSocket *)socket{
    QYDebugLog(@"connect To host:port = %@:%d",hostName,port) ;
    if ( socket == nil ) {
        QYDebugLog(@"非法的Socket") ;
        return FALSE ;
    }
    if ( hostName == nil ) {
        QYDebugLog(@"非法的Host") ;
        return FALSE ;
    }    
    
    BOOL result ;
    if ( ![socket isConnected] ) {
        result = [socket connectToHost:hostName onPort:port withTimeout:QIANYAN_HOST_CONNECT_TIMEOUT error:error] ;
//        result = [socket isConnected] ;
//        if ( result ) {
//            QYDebugLog(@"连接成功") ;
//        } else {
//            QYDebugLog(@"连接失败 error = %@",*error) ;
//        }
        return result ;
    } else {
        QYDebugLog(@"已经连接") ;
        return TRUE ;
    }
}

@end
