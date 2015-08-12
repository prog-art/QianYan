//
//  QY_FileService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QY_FileService : NSObject

#pragma mark - 头像

+ (BOOL)saveAvatar:(UIImage *)avatar forUserId:(NSString *)userId ;

+ (UIImage *)getAvatarByUserId:(NSString *)userId ;

#pragma mark - 相机缩略图

+ (BOOL)saveCameraThumbnail:(UIImage *)image forCameraId:(NSString *)cameraId ;

+ (UIImage *)getCameraThumbnailByCameraId:(NSString *)cameraId ;

#pragma mark - 报警信息

+ (NSString *)getAlertMessageVideoDirPath ;

+ (NSURL *)getAlertMessageVideoDirUrl;

#pragma makr - User

#pragma mark - 截图

+ (BOOL)saveScreenShotImage:(UIImage *)image forUserId:(NSString *)userId ;

+ (NSDirectoryEnumerator *)test ;

+ (void)displayScreenShotImageFileName:(NSString *)fileName forUserId:(NSString *)userId atImageView:(UIImageView *)imageView ;

#pragma mark - old

/**
 *  获取分配给单独user的一个文件夹
 *
 *  @param userId QY用户系统的userId
 *
 *  @return sandBox/document/user/userId
 */
+ (NSString *)getUserPathByUserId:(NSString *)userId ;

@end