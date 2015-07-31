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

#pragma mark - 

@end
