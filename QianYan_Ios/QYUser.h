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

@property (nonatomic) QY_user *coreUser ;

/**
 *  用户Id @"10000001"
 */
@property (nonatomic) NSString *userId ;

/**
 *  用户名 @"qianyan"
 */
@property (nonatomic) NSString *username ;

#pragma mark - Jpro

//jpro

@property (nonatomic) NSString *jproIp ;
@property (nonatomic) NSString *jproPort ;
@property (nonatomic) NSString *jproPsd ;

@end