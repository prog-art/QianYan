//
//  QY_cameraSetting.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "QY_Block_Define.h"

@class QY_camera, QY_user;

@interface QY_cameraSetting : NSManagedObject

@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) QY_user *owner;
@property (nonatomic, retain) QY_camera *toCamera;

+ (QY_cameraSetting *)insertCameraSettingByOwnerId:(NSString *)ownerId cameraId:(NSString *)cameraId ;

#pragma mark - 远端服务器

- (void)fetchCameraSettingComplection:(QYObjectBlock)complection ;

@end
