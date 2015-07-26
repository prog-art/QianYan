//
//  QY_cameraGroup.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_camera, QY_user;

@interface QY_cameraGroup : NSManagedObject

@property (nonatomic, retain) NSString * iosGroupId;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSDate * cameraDate;
@property (nonatomic, retain) QY_user *owner;
@property (nonatomic, retain) NSSet *containCameras;
@end

@interface QY_cameraGroup (CoreDataGeneratedAccessors)

- (void)addContainCamerasObject:(QY_camera *)value;
- (void)removeContainCamerasObject:(QY_camera *)value;
- (void)addContainCameras:(NSSet *)values;
- (void)removeContainCameras:(NSSet *)values;

@end
