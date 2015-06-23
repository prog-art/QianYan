//
//  QYUser.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "userInterface.h"
#import "QYFile.h"
#import "QY_Block_Define.h"

@class QYUser ;

@interface QYUser : NSObject<user2ProfileXMLInterface,user2userIdXMLInterface>

+ (instancetype)currentUser ;

/**
 *  构造方法Self
 */
+ (QYUser *)instanceWithUserId:(NSString *)userId
                      username:(NSString *)username
                        gender:(NSString *)gender
                      location:(NSString *)location
                      birthday:(NSDate *)birthday
                     signature:(NSString *)signature ;

/**
 *  构造方法Friend
 */
+ (QYUser *)instanceWithUserId:(NSString *)userId
                      username:(NSString *)username
                      nickname:(NSString *)nickname
                    remarkname:(NSString *)remarkname
                        follow:(NSInteger)follow
                          fans:(NSInteger)fans
                         black:(NSInteger)black
                        shield:(NSInteger)shield
                          jpro:(NSString *)jpro ;


/**
 *  注册用户,注册成功就会持久化这个user到本地
 *
 *  @param username 用户名
 *  @param password 密码
 */
+ (void)registeName:(NSString *)username Password:(NSString *)password complection:(QYUserBlock)complection ;

/**
 *  用户登录，登录成功就会持久话这个user到本地
 *
 *  @param username 用户名
 *  @param password 密码
 */
+ (void)loginName:(NSString *)username Password:(NSString *)password complection:(QYResultBlock)complection ;

/**
 *  退出登录
 */
+ (void)logOffComplection:(QYResultBlock)complection ;

#pragma mark - Profile.xml 属性

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

#pragma mark - UserId.xml 属性

/**
 *  用户昵称 @"严冬冬"
 */
@property (nonatomic) NSString *nickname ;

/**
 *  备注吗 @"东东"
 */
@property (nonatomic) NSString *remarkname ;

/**
 *  关注人数 1
 */
@property (nonatomic,assign) NSInteger follow ;

/**
 *  粉丝 1
 */
@property (nonatomic,assign) NSInteger fans ;

/**
 *  黑名单个数 0
 */
@property (nonatomic,assign) NSInteger black ;

/**
 *  不详 0
 */
@property (nonatomic,assign) NSInteger shield ;

/**
 *  jpro 信息http://qycam.com:50551
 */
@property (nonatomic) NSString *jpro ;

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
 *  用户Jpro服务器信息
 */
@property (nonatomic) NSString *userJpro ;

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

#pragma mark - File Associate

/**
 *  每个User都是基于xml文档实例话的，这个必须有。空表示不合法
 */
@property (nonatomic) NSString *xmlFilePath ;

///**
// *  对象对应的持久化文件路径profile.xml之类的
// */
//@property (readonly) QYFile *file ;

@end