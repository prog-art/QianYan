//
//  QY_JRMAPIInterface.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QY_JRMAPIInterface_h
#define QianYan_Ios_QY_JRMAPIInterface_h

#import "QY_Block_Define.h"
#import <UIKit/UIKit.h>
#import "QYConstants.h"


#define jms_ip_key @"jms_ip_key"
#define jms_port_key @"jms_port_key"

@protocol QY_JRMAPIInterface <NSObject>

@optional

/**
 *  2.1.1  设备登陆
 */
- (void)deviceLoginRequestComplection:(QYResultBlock)complection ;

/**
 *  2.1.2 获取jms服务器信息［依赖用户登录］
 */
- (void)getJMSServerInfoComplection:(QYInfoBlock)complection ;

/**
 *  2.5.1  用户注册
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)userRegisteRequestWithName:(NSString *)username Psd:(NSString *)password Complection:(QYInfoBlock)complection ;

/**
 *  2.5.2  用户登录
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)userLoginRequestWithName:(NSString *)username Psd:(NSString *)password Complection:(QYResultBlock)complection ;


/**
 *  2.5.3 重设用户密码
 *
 *  @param userId      用户Id (string,16bytes)
 *  @param newPassword 新密码 (string,32bytes)
 */
- (void)resetPasswordForUser:(NSString *)userId password:(NSString *)newPassword Complection:(QYResultBlock)complection ;

/**
 *  2.5.4 获取用户jpro服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
- (void)getJPROServerInfoForUser:(NSString *)userId Complection:(QYInfoBlock)complection ;

/**
 *  2.5.5 获取用户jss服务器信息
 *
 *  @param userId 用户Id(string,16bytes)
 */
- (void)getUserJSSInfoByUserId:(NSString *)userId Complection:(QYInfoBlock)complection ;


/**
 *  2.5.6 获取相机jpro服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
- (void)getCameraJRPOInfoByCameraId:(NSString *)jipnc_Id Complection:(QYInfoBlock)complection ;

/**
 *  2.5.7 获取相机jss服务器信息
 *
 *  @param jipnc_Id jipnc的Id(string,16bytes)，如"c00000000000015"
 */
- (void)getCameraJSSInfoByCameraId:(NSString *)jipnc_Id Complection:(QYInfoBlock)complection ;

/**
 *  2.5.8 检查用户名是否绑定手机号
 *
 *  @param username  用户名
 *  @param telephone 手机号
 */
- (void)checkUsernameBindingTelephone:(NSString *)username Telephone:(NSString *)telephone Complection:(QYInfoBlock)complection ;

/**
 *  2.5.9 通过用户名获取用户Id
 *
 *  @param username 用户名
 */
- (void)getUserIdByUsername:(NSString *)username Complection:(QYInfoBlock)complection ;

/**
 *  2.5.10 通过手机号获取用户Id
 *
 *  @param telephone 手机号
 */
- (void)getUserIdByTelephone:(NSString *)telephone Complection:(QYInfoBlock)complection ;

/**
 *  2.5.11 通过邮箱获取用户Id
 *
 *  @param email 邮箱
 */
- (void)getUserIdByEmail:(NSString *)email Complection:(QYInfoBlock)complection ;

/**
 *  2.5.12 设置用户手机号
 *
 *  @param userId    用户Id
 *  @param telephone 手机号
 */
- (void)bindingTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone Complection:(QYResultBlock)complection ;

/**
 *  2.5.13 获取用户手机号
 *
 *  @param userId 用户Id
 */
- (void)getTelephoneByUserId:(NSString *)userId Complection:(QYInfoBlock)complection ;

/**
 *  2.5.14 验证用户手机号
 *
 *  @param userId     用户Id
 *  @param telephone  手机号
 *  @param verifyCode 验证码
 */
- (void)verifyTelephoneForUser:(NSString *)userId Telephone:(NSString *)telephone VerifyCode:(NSString *)verifyCode Complection:(QYResultBlock)complection ;

/**
 *  2.5.15 设置用户昵称
 *
 *  @param userId   用户Id
 *  @param nickName 昵称
 */
- (void)setNicknameForUser:(NSString *)userId Nickname:(NSString *)nickName Complection:(QYResultBlock)complection QYDeprecated("后续不再使用，更改为修改用户档案下的profile.xml文件") ;

/**
 *  2.5.16 获取用户昵称
 *
 *  @param userId   用户Id
 */
- (void)getNicknameByUserId:(NSString *)userId Complection:(QYInfoBlock)complection QYDeprecated("后续不再使用，更改为获取用户档案下的profile.xml文件");

/**
 *  2.5.17 设置用户所在地
 *
 *  @param userId   用户Id
 *  @param location 用户位置 例:@"江苏南京"
 */
- (void)setUserLocationForUser:(NSString *)userId Location:(NSString *)location Complection:(QYResultBlock)complection QYDeprecated("后续不再使用，更改为修改用户档案下的profile.xml文件");

/**
 *  2.5.18 获取用户所在地
 *
 *  @param userId 用户Id
 */
- (void)getUserLocationByUserId:(NSString *)userId Complection:(QYInfoBlock)complection QYDeprecated("后续不再使用，更改为获取用户档案下的profile.xml文件");

/**
 *  2.5.19 设置用户个性签名
 *
 *  @param userId 用户Id
 *  @param sign   签名 128byes
 */
- (void)setUserSignForUser:(NSString *)userId Sign:(NSString *)sign Complection:(QYResultBlock)complection QYDeprecated("后续不再使用，更改为修改用户档案下的profile.xml文件");

/**
 *  2.5.20 获取用户个性签名
 *
 *  @param userId 用户Id
 */
- (void)getUserSignByUserId:(NSString *)userId Complection:(QYInfoBlock)complection QYDeprecated("后续不再使用，更改为获取用户档案下的profile.xml文件");

/**
 *  2.5.21 设置用户头像
 *
 *  @param userId 用户Id
 *  @param avatar 头像图片(待处理),头像最大大小
 */
- (void)setUserAvatarForUser:(NSString *)userId image:(UIImage *)avatar Complection:(QYResultBlock)complection QYDeprecated("后续不再使用，头像改为jpro存储") ;

/**
 *  2.5.22 获取用户头像
 *
 *  @param userId 用户Id
 */
- (void)getUserAvatarForUser:(NSString *)userId Complection:(QYObjectBlock)complection QYDeprecated("后续不再使用，头像改为jpro存储") ;

#pragma mark - 好友

/**
 *  2.5.23 获取用户好友列表
 *
 *  @param userId 用户Id
 */
- (void)getUserFriendListForUser:(NSString *)userId Complection:(QYArrayBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.24 添加好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)createAddRequestToUser:(NSString *)friendId Complection:(QYResultBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.25 删除好友
 *
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)deleteFriend:(NSString *)friendId Complection:(QYResultBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;


#pragma mark - 相机相关

/**
 *  2.5.26 分享相机给好友
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)shareCamera:(NSString *)cameraId toUser:(NSString *)friendId Complection:(QYResultBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.27 取消相机对好友的分享
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param friendId 用户Id(string,16bytes)
 */
- (void)stopSharingCamera:(NSString *)cameraId toUser:(NSString *)friendId Complection:(QYResultBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.28 获取相机列表
 */
- (void)getCameraListForUser:(NSString *)userId Complection:(QYArrayBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.29 用户绑定相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)bindingCameraToCurrentUser:(NSString *)cameraId Complection:(QYResultBlock)complection ;

/**
 *  2.5.30 用户解绑相机
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)unbindingCameraToCurrentUser:(NSString *)cameraId Complection:(QYResultBlock)complection ;

/**
 *  2.5.31 获取相机的分享列表
 *
 *  @param ownerId  相机拥有者的userId
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraSharingListForOwner:(NSString *)ownerId camera:(NSString *)cameraId Complection:(QYArrayBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.32 获取指定相机信息
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraInformationForCameraId:(NSString *)cameraId Complection:(QYInfoBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.33 设置相机昵称
 *
 *  @param cameraId jipnc_id(string,16bytes)
 *  @param nickname jipnc_nickname(string,32bytes)
 */
- (void)setNicknameForCamera:(NSString *)cameraId Nickname:(NSString *)nickname Complection:(QYInfoBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.34 获取相机拥有者Id
 *
 *  @param cameraId jipnc_id(string,16bytes)
 */
- (void)getCameraOwnerIdForCamera:(NSString *)cameraId Complection:(QYInfoBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

#pragma mark - User

/**
 *  2.5.35 获取用户名
 *
 *  @param userId 用户Id
 */
- (void)getUsernameByUserId:(NSString *)userId Complection:(QYInfoBlock)complection QYDeprecated("后续不再使用，修改为和jpro交互") ;

/**
 *  2.5.36 查询登录串号
 *
 *  @param userId 用户Id
 */
- (void)getUserLoginSeriesForUser:(NSString *)userId Complection:(QYInfoBlock)complection ;

/**
 *  2.5.37 刷新登录串号
 *
 *  @param userId 用户Id
 */
- (void)refreshUserLoginSeriesForUser:(NSString *)userId Complection:(QYInfoBlock)complection ;

#pragma mark - 邮箱绑定

/**
 *  2.5.38 用户绑定邮箱请求
 *
 *  @param userEmail 用户邮箱(string,32byes)
 *  @param userId    用户Id
 */
- (void)requestBindingEmail:(NSString *)userEmail ForUser:(NSString *)userId Complection:(QYResultBlock)complection ;

/**
 *  2.5.39 用户解绑邮箱请求
 *
 *  @param userId 用户Id
 */
- (void)requestUnbindingEmailForUser:(NSString *)userId Complection:(QYResultBlock)complection ;

#pragma mark - 第三方登录

/**
 *  2.5.40 第三方登录获取用户Id
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪
 *  @param openId      该账号类型下全局唯一
 */
- (void)getUserIdForThirdPartLoginUserWithAccountTyoe:(NSString *)accountTyoe openId:(NSString *)openId Complection:(QYInfoBlock)complection ;

/**
 *  2.5.41 第三方登录新建账户
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
- (void)newAccountForThirdPartLoginUserWithAccountTyoe:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username Complection:(QYInfoBlock)complection ;

/**
 *  2.5.42 第三方登录修改用户名
 *
 *  @param accountTyoe 第三方账号类型,"1"表示QQ,"2"表示微信,"3"表示新浪(string,8bytes)
 *  @param openId      该账号类型下全局唯一(string,64bytes)
 *  @param username    用户名(string,64bytes)
 */
- (void)setUsernameForThirdPartLoginWithAccountType:(NSString *)accountType openId:(NSString *)openId username:(NSString *)username Complection:(QYResultBlock)complection ;

@end


#endif
