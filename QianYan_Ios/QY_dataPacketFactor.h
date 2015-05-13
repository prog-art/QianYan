//  用于生成满足jclient jrm交互协议的工厂类
//
//  QY_MessageFactor.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  协议版本 <<JRM通信协议(2015-4-29 10.41.11 3120)>>
 */
@interface QY_dataPacketFactor : NSObject

/**
 *  2.1.1  设备登陆数据包
 *
 *  @return
 */
+ (NSData *)getDeviceLoginData ;

/**
 *  2.5.1 用户注册数据包
 *
 *  @param username 用户名(邮箱或手机号，安卓是数字或字母)
 *  @param password 密码(6-20位数字或密码....)
 *
 *  @return
 */
+ (NSData *)getUserRegisteDataWithUserName:(NSString *)username password:(NSString *)password ;

/**
 *  2.5.2 用户登录数据包
 *
 *  @param username 用户名
 *  @param password 密码
 *
 *  @return
 */
+ (NSData *)getUserLoginDataWithUserName:(NSString *)username password:(NSString *)password ;

@end
