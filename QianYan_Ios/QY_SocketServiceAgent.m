//
//  QY_SocketServiceAgent.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/3.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_SocketServiceAgent.h"

#import "QY_SocketService.h"
#import "QY_SocketServiceAgent+QY_SocketServiceAgent_GCD.h"

#import <Reachability/Reachability.h>
#import "QY_Common.h"

static NSString *JRM_HOST_IP = nil ;
static NSUInteger JRM_HOST_PORT = 0 ;

@interface QY_SocketServiceAgent () <QY_JDASSocketDelegaterDelegate> {
    
    __weak QY_SocketService * _socketService ;
    
    BOOL _InternetConnection ;
    
}

@property (nonatomic,readwrite) QY_APP_STATE AppState ;

/**
 *  监听网络连通情况
 */
@property (nonatomic) Reachability *reach ;

@end

@implementation QY_SocketServiceAgent

+ (instancetype)sharedInstance {
    static QY_SocketServiceAgent *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QY_SocketServiceAgent alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

#pragma mark - Life Cycle

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    self.AppState = QY_APP_STATE_OPENED ;
    _socketService = [QY_SocketService shareInstance] ;
    {
        self.reach = [Reachability reachabilityForInternetConnection] ;
        _InternetConnection = FALSE ;
        
        WEAKSELF
        self.reach.reachableBlock = ^(Reachability *reachability) {
            [weakSelf setInternetConnection:TRUE] ;
        } ;
        
        self.reach.unreachableBlock = ^(Reachability *reachability) {
            [weakSelf setInternetConnection:FALSE] ;
        } ;
        
        [self.reach startNotifier] ;
    }
}



#pragma mark - Setter & Getter 

- (void)setInternetConnection:(BOOL)InternetConnection {
    _InternetConnection = InternetConnection ;
    //组件网路网络状态改变。通知。
}

- (void)setAppState:(QY_APP_STATE)AppState {
    self.AppState = AppState ;
    
    //组件状态改变。可以在这里通知外部。
    
}

#pragma mark - 

/**
 *  初始化应用程序,获取寻址服务器
 */
- (void)setUpApplication {
    _socketService.JDAS_delegate = self ;
}

#pragma mark - QY_JDASSocketDelegaterDelegate

/**
 *  连接上了服务器
 *
 *  @param JDASSocket
 */
- (void)JDASSocketDidConnect:(AsyncSocket *)JDASSocket {
//    self.AppState = QY_APP_STATE_JDAS_CONNECTED ;
    //should send message .
    
}

/**
 *  正常断开连接
 */
- (void)JDASSocketDidNormallyDisconnect {
    //application has initialized successed .
    
}

/**
 *  遇到错误断开连接的
 *
 *  @param error
 */
- (void)JDASSocketDidDisconnectWithError:(NSError *)error {
//    self.AppState = QY_APP_STATE_JDAS_CONNECT_FAILED ;
    
    //should reconnected JDAS .
    
    
}

/**
 *  读到了Ip 和 Host
 *
 *  @param host
 *  @param port
 */
- (void)JDASSocketDidReadJRMHost:(NSString *)host port:(NSUInteger)port {
    JRM_HOST_IP = host ;
    JRM_HOST_PORT = port ;
//    self.AppState = QY_APP_STATE_JDAS_DID_RECEIVED_JRM_HOST_INFO ;
    //should disconnect JDAS socket ;
}

/**
 *  读到了不完整的数据
 */
- (void)JDASSocketReadNonFullData {
    //should resend Data ;
}

@end