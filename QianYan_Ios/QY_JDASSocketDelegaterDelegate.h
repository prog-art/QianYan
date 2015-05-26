//
//  QY_JDASSocketDelegaterDelegate.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

@protocol QY_JDASSocketDelegaterDelegate <NSObject>

@optional

/**
 *  连接上了服务器
 *
 *  @param JDASSocket
 */
- (void)JDASSocketDidConnect:(AsyncSocket *)JDASSocket ;

/**
 *  正常断开连接
 */
- (void)JDASSocketDidNormallyDisconnect ;

/**
 *  遇到错误断开连接的
 *
 *  @param error
 */
- (void)JDASSocketDidDisconnectWithError:(NSError *)error ;

/**
 *  读到了Ip 和 Host
 *
 *  @param host
 *  @param port
 */
- (void)JDASSocketDidReadJRMHost:(NSString *)host port:(NSUInteger)port ;

/**
 *  读到了不完整的数据
 */
- (void)JDASSocketReadNonFullData ;

@end