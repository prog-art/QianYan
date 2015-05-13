//  封装一层Socket操作
//  QY_SocketService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CocoaAsyncSocket/AsyncSocket.h>

#import "QY_Common.h"

#import "QY_JRMDataPacket.h"

#import "QY_SocketServiceDelegate.h"

@interface QY_SocketService : NSObject

+ (instancetype)shareInstance ;

/**
 *  完成消息后，发送消息给delegate ;
 */
@property (weak) id<QY_SocketServiceDelegate> delegate ;

#pragma mark - JDAS Socket

/**
 *  [同步]连接JDAS服务器，并在完成数据读取之后，关闭JDAS Socket连接。整个程序只使用一次，打开的时候使用一次。
 *
 *  @param error
 *
 *  @return 连接结果
 */
- (BOOL)connectToJDASHost:(NSError *__autoreleasing *)error ;

/**
 *  [异步]发送数据,回调中4字节IP和2字节PORT
 */
- (void)getJRMIPandJRMPORT ;

#pragma mark - Normal Socket

/**
 *  断开目标Socket的网络连接。
 *
 *  @param socket 目标Socket，要断开连接
 */
- (void)disconnectedSocket:(AsyncSocket *)socket ;

#pragma mark - JRM Socket 

/**
 *  [同步]连接JRM服务器。
 *
 *  @param error
 *
 *  @return 连接结果
 */
- (BOOL)connectToJRMHost:(NSError *__autoreleasing *)error ;

/**
 *  2.1.1  设备登陆
 */
- (void)deviceLoginRequest ;

/**
 *  2.5.1  用户注册
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)userRegisteRequestWithName:(NSString *)username Psd:(NSString *)password ;

/**
 *  2.5.2  用户登录
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)userLoginRequestWithName:(NSString *)username Psd:(NSString *)password ;

@end
