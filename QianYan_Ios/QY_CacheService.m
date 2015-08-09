//
//  QY_CacheService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/5.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_CacheService.h"

#import "QY_Common.h"
#import <UIKit/UIKit.h>
#import "QY_FileService.h"

@interface QY_CacheService () {
    
}

@property (nonatomic,strong) NSMutableDictionary *avatarCache ;
@property (nonatomic,strong) NSMutableDictionary *cameraThumbnail ;

@end

@implementation QY_CacheService

+ (instancetype)shareInstance {
    static QY_CacheService *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QY_CacheService alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        _avatarCache = [NSMutableDictionary dictionary] ;
        _cameraThumbnail = [NSMutableDictionary dictionary] ;
    }
    return self ;
}

#pragma mark - 头像

- (void)cacheAvatar:(UIImage *)avatar forUserId:(NSString *)userId {
    if ( avatar && userId ) {
        [self.avatarCache setObject:avatar forKey:userId] ;
        [QY_FileService saveAvatar:avatar forUserId:userId] ;
    }
}

- (UIImage *)getAvatarByUserId:(NSString *)userId {
    UIImage *cachedImage = self.avatarCache[userId] ;
    if ( cachedImage ) return cachedImage ;
    
    UIImage *memoryImage = [QY_FileService getAvatarByUserId:userId] ;
    if ( memoryImage ) {
        [self cacheAvatar:memoryImage forUserId:userId] ;
        return memoryImage ;
    }

    return nil ;
}

#pragma makr - 相机缩略图

- (void)cacheImage:(UIImage *)image forCameraId:(NSString *)cameraId {
    if ( image && cameraId) {
        [self.cameraThumbnail setObject:image forKey:cameraId] ;
        [QY_FileService saveCameraThumbnail:image forCameraId:cameraId] ;
    }
}

- (UIImage *)getImageByCameraId:(NSString *)cameraId {
    if ( !cameraId ) return nil ;
    UIImage *cachedImage = self.cameraThumbnail[cameraId] ;
    if ( cachedImage ) return cachedImage ;
    
    UIImage *memoryImage = [QY_FileService getCameraThumbnailByCameraId:cameraId] ;
    if ( memoryImage ) {
        [self cacheImage:memoryImage forCameraId:cameraId] ;
        return memoryImage ;
    }
    return nil ;
}

@end
