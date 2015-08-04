//  常用工具类
//  QYUtils.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QYUtils.h"
#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@implementation QYUtils

+(void)alert:(NSString*)msg{
    UIAlertView *alertView=[[UIAlertView alloc]
                            initWithTitle:nil message:msg delegate:nil
                            cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

+(BOOL)alertError:(NSError *)error {
    if(error){
        [self alert:[NSString stringWithFormat:@"%@",error]];
        return YES;
    }
    return NO;
}

#pragma mark - Indicator

+(void)showNetworkIndicator{
    UIApplication* app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=YES;
}

+(void)hideNetworkIndicator{
    UIApplication* app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=NO;
}

#pragma mark - async

+(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

+(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

+(void)runAfterSecs:(float)secs block:(void (^)())block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

#pragma mark - toMain && toRegiste && toLogin

+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate ;
}

+ (void)toMain {
    [[self getAppDelegate] toMain];
}

+ (void)toRegiste {
    [[self getAppDelegate] toRegiste];
}

+ (void)toLogin {
    [[self getAppDelegate] toLogin] ;
}

#pragma mark - UIImagePickerController 

+ (void)pickImageFromPhotoLibraryAtController:(UIViewController *)controller{
    UIImagePickerControllerSourceType srcType = UIImagePickerControllerSourceTypePhotoLibrary ;
    NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:srcType] ;
    if([UIImagePickerController isSourceTypeAvailable:srcType] && [mediaTypes count] > 0 ){
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init] ;
        imagePicker.mediaTypes = mediaTypes;
        imagePicker.delegate = (id)controller;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = srcType;
        [controller presentViewController:imagePicker animated:YES completion:nil] ;
    }else{
        [QYUtils alert:@"no image picker available"] ;
    }
}

+ (void)pickImageFromCameraAtController:(UIViewController *)controller {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init] ;
    imagePicker.delegate = (id)controller ;
    imagePicker.allowsEditing = YES ;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera ;
    [controller presentViewController:imagePicker animated:YES completion:nil] ;
}

#pragma mark - 验证码

+ (NSString *)getAValidateCodeLength:(NSUInteger)len {
    NSString *validateCode = @"" ;    
    for ( int i = 0 ; i < len ; i++ ) {
        validateCode = [validateCode stringByAppendingFormat:@"%i",(arc4random() % 9)] ;
    }
    return validateCode ;
}

#pragma mark - NSDate && Timestamp

//时间转时间戳的方法:
+ (NSString *)date2timestampStr:(NSDate *)date {
    assert(date) ;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp ;
}

//时间戳转时间的方法
+ (NSDate *)timestampStr2date:(NSString *)timestamp {
    assert(timestamp) ;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]] ;
    return confromTimesp ;
}

+ (NSInteger)ageWithDateOfBirth:(NSDate *)date {
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    return iAge ;
}

@end
