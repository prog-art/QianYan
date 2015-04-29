//  常用工具类
//
//  QYUtils.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_Common.h"

@interface QYUtils : NSObject

+ (void)alert:(NSString *)msg ;

+ (BOOL)alertError:(NSError *)error ;

#pragma mark - Indicator

+ (void)showNetworkIndicator ;

+ (void)hideNetworkIndicator ;

#pragma mark - async

+ (void)runInGlobalQueue:(void (^)())queue ;

+ (void)runInMainQueue:(void (^)())queue ;

+ (void)runAfterSecs:(float)secs block:(void (^)())block ;

#pragma mark - NSString Utils

/**
 *  转换输入10进制数字为对应16进制字符串,规定长度len，未达到长度前补充0
 *  用于生成jrm和jclient通信协议的数据包的一段长度为len的16进制数据。
 *
 *  @param integer 要转换的代码
 *  @param len     转换目标字串的长度
 *
 *  @return 格式好的字符串
 */
+ (NSString *)QY_FormatStringFromNSInteger:(NSInteger)integer ToLength:(NSInteger)len ;

@end
