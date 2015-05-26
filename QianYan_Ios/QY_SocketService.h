//  封装一层Socket操作
//  QY_SocketService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CocoaAsyncSocket/AsyncSocket.h>

#import "QY_Common.h"

#import "QY_JRMDataPacket.h"

#import "QY_SocketServiceDelegate.h"
#import "QY_JDASSocketDelegaterDelegate.h"

@interface QY_SocketService : NSObject

+ (instancetype)shareInstance ;

/**
 *  接收JDAS寻址服务器连接的消息通知。
 */
@property (weak) id<QY_JDASSocketDelegaterDelegate> JDAS_delegate ;


/**
 *  完成消息后，发送消息给delegate ;
 */
@property (weak) id<QY_SocketServiceDelegate> delegate ;

#pragma mark - JDAS Socket

/**
 *  [同步]连接JDAS寻址服务器，并在完成数据读取之后，关闭JDAS Socket连接。整个程序只使用一次，打开的时候使用一次。
 *
 *  @param error
 *
 *  @return 连接结果
 */
- (BOOL)connectToJDASHost:(NSError *__autoreleasing *)error ;

/**
 *  [异步]获取JRM服务器的IP和地址
 *  发送数据,回调中4字节IP和2字节PORT,
 */
- (void)getJRMIPandJRMPORT ;

#pragma mark - Normal Socket

/**
 *  断开目标Socket的网络连接。
 *
 *  @param socket 目标Socket，要断开连接
 */
- (void)disconnectedSocket:(AsyncSocket *)socket ;

#pragma mark - JRM Socket 以下方法会调用QY_SocketServiceDelegate的方法。

/**
 *  [同步]连接JRM服务器。
 *
 *  @param error
 *
 *  @return 连接结果
 */
- (BOOL)connectToJRMHost:(NSError *__autoreleasing *)error ;

/**
 *  获取当前连接状态
 *
 *  @return jrmSocket连接状态
 */
- (BOOL)isJRMSocketConnected ;

#pragma mark - 文档中所有请求

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

#warning new

/**
 *  2.5.3 重设用户密码
 *
 *  @param userId      用户Id (string,16bytes)
 *  @param newPassword 新密码 (string,32bytes)
 */
- (void)resetPasswordForUser:(NSString *)userId password:(NSString *)newPassword ;

/**
 *  2.5.4 获取用户jpro服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
- (void)getJPROServerInfoForUser:(NSString *)userId ;

/**
 *  2.5.5 获取用户jss服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
- (void)getJSSserverInfoForUser:(NSString *)userId ;

/**
 *  2.5.6 获取相机jpro服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
- (void)getJRPOserverInfoForCamera:(NSString *)jipnc_Id ;

/**
 *  2.5.7 获取相机jss服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
- (void)getJSSserverInfoForCamera:(NSString *)jipnc_Id ;

/**
 *  2.5.8 检查用户名是否绑定手机号
 *
 *  @param username  用户名
 *  @param telephone 手机号
 */
- (void)checkUsernameBindingTelephone:(NSString *)username Telephone:(NSString *)telephone;

/**
 *  2.5.9 通过用户名获取用户Id
 *
 *  @param username 用户名
 */
- (void)getUserIdByUsername:(NSString *)username ;

/**
 *  2.5.10 通过手机号获取用户Id
 *
 *  @param telephone 手机号
 */
- (void)getUserIdByTelephone:(NSString *)telephone ;

/**
 *  2.5.11 通过邮箱获取用户Id
 *
 *  @param email 邮箱
 */
- (void)getUserIdByEmail:(NSString *)email ;

/**
 *  2.5.12 设置用户手机号
 *
 *  @param userId    用户Id
 *  @param telephone 手机号
 */
- (void)bindingTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone ;

/**
 *  2.5.13 获取用户手机号
 *
 *  @param userId 用户Id
 */
- (void)getTelephoneByUserId:(NSString *)userId ;

/**
 *  2.5.14 验证用户手机号
 *
 *  @param userId    用户Id
 *  @param telephone 手机号
 */

/**
 *  2.5.14 验证用户手机号
 *
 *  @param userId     用户Id
 *  @param telephone  手机号
 *  @param verifyCode 验证码
 */
- (void)verifyTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone VerifyCode:(NSString *)verifyCode ;

/**
 *  2.5.15 设置用户昵称
 *
 *  @param userId   用户Id
 *  @param nickName 昵称
 */
- (void)setNicknameForUser:(NSString *)userId Nickname:(NSString *)nickName ;

/**
 *  2.5.16 获取用户昵称
 *
 *  @param userId   用户Id
 */
- (void)getNicknameForUser:(NSString *)userId ;

/**
 *  2.5.17 设置用户所在地
 *
 *  @param userId   用户Id
 *  @param location 用户位置 例:@"江苏南京"
 */
- (void)setUserLocationForUser:(NSString *)userId Location:(NSString *)location ;

/**
 *  2.5.18 获取用户所在地
 *
 *  @param userId 用户Id
 */
- (void)getUserLocationForUser:(NSString *)userId ;

/**
 *  2.5.19 设置用户个性签名
 *
 *  @param userId 用户Id
 *  @param sign   签名 128byes
 */
- (void)setUserSignForUser:(NSString *)userId Sign:(NSString *)sign ;

/**
 *  2.5.20 获取用户个性签名
 *
 *  @param userId 用户Id
 */
- (void)getUserSignForUser:(NSString *)userId ;

/**
 *  2.5.21 设置用户头像
 *
 *  @param userId 用户Id
 *  @param avatar 头像图片(待处理),头像最大大小
 */
- (void)setUserAvatarForUser:(NSString *)userId image:(UIImage *)avatar ;

#pragma mark - 好友

/**
 *  2.5.22 获取用户头像
 *
 *  @param userId 用户Id
 */
- (void)getUserAvatarForUser:(NSString *)userId ;

/**
 *  2.5.23 获取用户好友列表
 *
 *  @param userId 用户Id
 */
- (void)getUserFriendListForUser:(NSString *)userId ;

/**
 *  2.5.24 添加好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)createAddRequestToUser:(NSString *)friendId ;

/**
 *  2.5.25 删除好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)deleteFriend:(NSString *)friendId ;




#pragma mark - 相机相关

/**
 *  2.5.26 分享相机给好友
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)shareCamera:(NSString *)cameraId toUser:(NSString *)friendId ;

/**
 *  2.5.27 取消相机对好友的分享
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)stopSharingCamera:(NSString *)cameraId toUser:(NSString *)friendId ;

/**
 *  2.5.28 获取相机列表
 */
- (void)getCameraListForUser:(NSString *)userId ;

/**
 *  2.5.29 用户绑定相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)bindingCameraToCurrentUser:(NSString *)cameraId ;

/**
 *  2.5.30 用户解绑相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)unbindingCameraToCurrentUser:(NSString *)cameraId ;

/**
 *  2.5.31 获取相机的分享列表
 *
 *  @param ownerId  相机拥有者的userId
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraSharingListForOwner:(NSString *)ownerId camera:(NSString *)cameraId ;

/**
 *  2.5.32 获取指定相机信息
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraInformationForCameraId:(NSString *)cameraId ;

/**
 *  2.5.33 设置相机昵称
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param nickname jipnc_nickname(string,32bytes)
 */
- (void)setNicknameForCamera:(NSString *)cameraId Nickname:(NSString *)nickname ;

/**
 *  2.5.34 获取相机拥有者Id
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraOwnerIdForCamera:(NSString *)cameraId ;

#pragma mark - User

/**
 *  2.5.35 获取用户名
 *
 *  @param userId 用户Id
 */
- (void)getUsernameForUser:(NSString *)userId ;

/**
 *  2.5.36 查询登录串号
 *
 *  @param userId 用户Id
 */
- (void)getUserLoginSeriesForUser:(NSString *)userId ;

/**
 *  2.5.37 刷新登录串号
 *
 *  @param userId 用户Id
 */
- (void)refreshUserLoginSeriesForUser:(NSString *)userId ;

#pragma mark - 邮箱绑定

/**
 *  2.5.38 用户绑定邮箱请求
 *
 *  @param userEmail 用户邮箱(string,32byes)
 *  @param userId    用户Id
 */
- (void)requestBindingEmail:(NSString *)userEmail ForUser:(NSString *)userId ;

/**
 *  2.5.39 用户解绑邮箱请求
 *
 *  @param userId 用户Id
 */
- (void)requestUnbindingEmailForUser:(NSString *)userId ;

#pragma mark - 第三方登录

/**
 *  2.5.40 第三方登录获取用户Id
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪
 *  @param openId      该账号类型下全局唯一
 */
- (void)getUserIdForThirdPartLoginUserWithAccountTyoe:(NSString *)accountTyoe openId:(NSString *)openId ;

/**
 *  2.5.41 第三方登录新建账户
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
- (void)newAccountForThirdPartLoginUserWithAccountTyoe:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username ;

/**
 *  2.5.42 第三方登录修改用户名
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
- (void)setUsernameForThirdPartLoginWithAccountType:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username ;

@end