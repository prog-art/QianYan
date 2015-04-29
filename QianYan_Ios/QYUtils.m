//  常用工具类
//  QYUtils.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QYUtils.h"
#import <UIKit/UIKit.h>

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

#pragma mark - NSString Utils

+ (NSString *)QY_FormatStringFromNSInteger:(NSInteger)integer ToLength:(NSInteger)len {
    len = len * 2 ;
    NSString *resStr ;
    NSString *hexStr = [self QY_integerToHexStr:integer] ;
    resStr = [self QY_StringWithNumberOfZero:len - hexStr.length] ;
    resStr = [resStr stringByAppendingString:hexStr] ;
    return resStr ;
}

#pragma mark - Private Method 

/**
 *  10进制数转16进制表示的字符串
 *
 *  @param integer 10进制数
 *
 *  @return 16进制表示的字符串
 */
+ (NSString *)QY_integerToHexStr:(NSInteger)integer {
    return [NSString stringWithFormat:@"%lx",(long)integer] ;
}

/**
 *  16进制数字符串转10进制数字字符串
 *
 *  @param str 16进制数字符串
 *
 *  @return 10进制数字字符串
 */
+ (NSString *)QY_hexStrTo10Str:(NSString *)str {
    return [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,16)];
}

+ (NSString *)QY_StringWithNumberOfZero:(NSInteger )numOfZero {
    if ( numOfZero <= 0 ) {
        return @"" ;
    }
    NSString *resStr = @"" ;
    for ( NSInteger i = 0 ;  i < numOfZero ; i++ ) {
        resStr = [resStr stringByAppendingString:@"0"] ;
    }
    return resStr ;
}

@end
