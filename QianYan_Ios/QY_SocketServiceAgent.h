//
//  QY_SocketServiceAgent.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/3.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QY_APP_STATE) {
    QY_APP_STATE_OPENED = 2 ,//程序刚打开，还没有完成寻址服务器的步骤。
    QY_APP_STATE_JDAS_ON_CONNECT = 2 << 1 ,//正在完成JDAS这个步骤。
    QY_APP_STATE_JRM_PREPARE_READY = 2 << 2 ,//已经完成JDAS这个步骤，JRM IP 和 JRM Host这个状态才有。
    
    QY_APP_STATE_JRM_CONNECTED = 2 << 3 ,//JRM服务器连接，设备还没有登录
    QY_APP_STATE_JRM_DISCONNECTED = 2 << 4 ,//JRM连接断开
    QY_APP_STATE_JRM_DEVICE_DID_LOGIN = 2 << 4 ,//已经设备登录
    
//    QY_APP_STATE_JDAS_CONNECTED = 2 << 1 ,//application did connected to JDAS Host.
//    QY_APP_STATE_JDAS_CONNECT_FAILED = ( 2 << 1 ) + 1 ,//application did fail to connected to JDAS Host .
//    QY_APP_STATE_JDAS_DID_DISCONNECTED_WITH_ERROR = ( 2 << 1 ) + 2 ,
//    QY_APP_STATE_JDAS_DID_RECEIVED_JRM_HOST_INFO = 2 << 2 ,//application has been set up successfully .
//    QY_APP_STATE_JDAS_DID_DISCONNECTED = 2 << 3 ,//application has been set up successfully .
//    
//    QY_APP_STATE_READY_TO_START = 2 << 4 ,
    
//    QY_APP_STATE_SHOULD_CONNECTED_JRM = 2 << 3 ,//application should connect to JRM HOST
//    QY_APP_STATE_JRM_CONNECTED = 2 << 4 ,//application did connected to JRM Host.
//    QY_APP_STATE_JRM_MESSAGE_WRITING = 2 << 5 ,
//    QY_APP_STATE_JRM_MESSAGE_RECEIVING = 2 << 6 ,
//    QY_APP_STATE_JRM_MESSAGE_DID_RECEIVED = 2 << 7 ,
} ;

#pragma mark -

@interface QY_SocketServiceAgent : NSObject


+ (instancetype)sharedInstance ;

#pragma mark -

/**
 *  标志位，当前组件的状态
 */
@property (nonatomic,readonly) QY_APP_STATE AppState ;

/**
 *  初始化应用程序,获取寻址服务器
 */
- (void)setUpApplication ;

@end