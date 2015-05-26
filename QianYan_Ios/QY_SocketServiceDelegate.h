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
- (void)QY_userRegisteSuccessed:(BOOL)successed userId:(NSString *)userId ;

/**
 *  252 用户登录结果
 *
 *  @param successed
 */
- (void)QY_userLoginSuccessed:(BOOL)successed ;

/**
 *  254 获取JPRO服务器信息结果
 *
 *  @param successed
 *  @param jproIp       jpro的ip地址或域名，如"qycam.com"
 *  @param jproPort     jpro的端口号 如"50551"
 *  @param jproPassword jpro的访问密码(暂无)
 */
- (void)QY_getJPROServerInfoForUserSuccessed:(BOOL)successed Ip:(NSString *)jproIp Port:(NSString *)jproPort Password:(NSString *)jproPassword ;

/**
 *  259 通过用户名获取用户Id
 *
 *  @param successed
 *  @param userId    成功时返回结果有userId
 */
- (void)QY_getUserIdByUsernameSuccessed:(BOOL)successed UserId:(NSString *)userId ;

#pragma mark - 2510

#pragma mark - 2520

/**
 *  2524 添加好友
 *
 *  @param successed
 */
- (void)QY_addFriendSuccessed:(BOOL)successed ;

/**
 *  2529 绑定相机
 *
 *  @param successed
 *  @param code      1:参数出错 2:绑定出错 3:已经绑定给其他用户
 */
- (void)QY_bindCameraSuccessed:(BOOL)successed errorCode:(NSInteger)code ;

#pragma mark - 2530

/**
 *  2530 接绑相机
 *
 *  @param successed
 */
- (void)QY_unbindCameraSuccessed:(BOOL)successed ;

#pragma mark - 2540


@end