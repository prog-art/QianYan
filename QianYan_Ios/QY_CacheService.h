//
//  QY_CacheService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/5.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage ;

@interface QY_CacheService : NSObject

+ (instancetype)shareInstance ;

#pragma mark - 头像

- (void)cacheAvatar:(UIImage *)avatar forUserId:(NSString *)userId ;

- (UIImage *)getAvatarByUserId:(NSString *)userId ;

#pragma makr - 相机缩略图

- (void)cacheImage:(UIImage *)image forCameraId:(NSString *)cameraId ;

- (UIImage *)getImageByCameraId:(NSString *)cameraId ;

@end
