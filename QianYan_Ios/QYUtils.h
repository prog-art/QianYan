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

@end
