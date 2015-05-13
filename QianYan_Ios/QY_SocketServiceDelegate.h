//
//  QY_SocketServiceDelegate.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//


/**
 *  基于<QY_SocketService jrm 请求>定制
 */
@protocol QY_SocketServiceDelegate <NSObject>

@required

@optional
/**
 *  211 设备登录结果
 *
 *  @param successed
 */
- (void)QY_deviceLoginSuccessed:(BOOL)successed ;

/**
 *  251 用户注册结果
 *
 *  @param successed
 *  @param userId    成功时返回结果有userId
 */
- (void)QY_userRegisteSuccessed:(BOOL)successed userId:(NSString *)userId;

/**
 *  252 用户登录结果
 *
 *  @param successed
 */
- (void)QY_userLoginSuccessed:(BOOL)successed ;

@end
