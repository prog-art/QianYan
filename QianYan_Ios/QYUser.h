//
//  QYUser.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QYFile.h"
#import "QY_Block_Define.h"
#import "QY_user.h"

@class QYUser ;

@interface QYUser : NSObject

+ (instancetype)currentUser ;


/**
 *  注册用户,注册成功就会持久化这个user到本地
 *
 *  @param username 用户名
 *  @param password 密码
 */
+ (void)registeName:(NSString *)username Password:(NSString *)password complection:(QYUserBlock)complection ;

/**
 *  上传user profile.xml
 */
- (void)uploadProfileComplection:(QYResultBlock)complection ;

/**
 *  用户登录，登录成功就会持久话这个user到本地
 *
 *  @param username 用户名
 *  @param password 密码
 */
+ (void)loginName:(NSString *)username Password:(NSString *)password complection:(QYResultBlock)complection ;

/**
 *  下载profile
 */
- (void)downloadProfileComplection:(QYResultBlock)complection ;

/**
 *  退出登录
 */
+ (void)logOffComplection:(QYResultBlock)complection ;

@property (nonatomic) QY_user *coreUser ;

/**
 *  用户Id @"10000001"
 */
@property (nonatomic) NSString *userId ;

/**
 *  用户名 @"qianyan"
 */
@property (nonatomic) NSString *username ;

/**
 *  用户性别 @"男"
 */
@property (nonatomic) NSString *gender ;

/**
 *  用户位置 @"江苏南京"
 */
@property (nonatomic) NSString *location ;

/**
 *  用户生日 @"2008年06月21日"
 */
@property (nonatomic) NSDate *birthday ;

/**
 *  用户签名 @"千衍通信欢迎您!"
 */
@property (nonatomic) NSString *signature ;


/**
 *  用户昵称 @"严冬冬"
 */
@property (nonatomic) NSString *nickname ;

/**
 *  备注吗 @"东东"
 */
@property (nonatomic) NSString *remarkname ;

#pragma mark - Jpro

//jpro

@property (nonatomic) NSString *jproIp ;
@property (nonatomic) NSString *jproPort ;
@property (nonatomic) NSString *jproPsd ;

#pragma mark - User other property

/**
 *  用户手机
 */
@property (nonatomic) NSString *telephone ;

/**
 *  用户邮箱
 */
@property (nonatomic) NSString *email ;

/**
 *  用户Jss服务器信息
 */
@property (nonatomic) NSString *userJss ;

/**
 *  用户好友列表
 */
@property (nonatomic) NSArray *userFriendList ;

/**
 *  用户相机列表
 */
@property (nonatomic) NSArray *userCameraList ;

@end