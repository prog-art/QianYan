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

#import <UIKit/UIKit.h>

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

#pragma mark - toMain && toRegiste && toLogin

+ (void)toMain ;

+ (void)toRegiste ;

+ (void)toLogin ;

#pragma mark - UIImagePickerController

/**
 *  从相册选照片
 */
+ (void)pickImageFromPhotoLibraryAtController:(UIViewController *)controller ;

/**
 *  拍照
 */
+ (void)pickImageFromCameraAtController:(UIViewController *)controller ;

#pragma makr - 验证码

+ (NSString *)getAValidateCodeLength:(NSUInteger)len ;

#pragma mark - NSDate && Timestamp

//时间转时间戳的方法:
+ (NSString *)date2timestampStr:(NSDate *)date ;

//时间戳转时间的方法
+ (NSDate *)timestampStr2date:(NSString *)timestamp ;

//时间转年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date ;

@end
