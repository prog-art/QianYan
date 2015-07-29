//
//  QY_camera.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_cameraGroup, QY_cameraSetting, QY_user;

@interface QY_camera : NSManagedObject

@property (nonatomic, retain) NSString * cameraId;
@property (nonatomic, retain) NSString * cameraPassword;
@property (nonatomic, retain) NSString * jpro;
@property (nonatomic, retain) NSString * jssId;
@property (nonatomic, retain) NSString * jssIp;
@property (nonatomic, retain) NSString * jssPassword;
@property (nonatomic, retain) NSString * jssPort;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSSet *inGroups;
@property (nonatomic, retain) QY_user *owner;
@property (nonatomic, retain) NSSet *shareUser;
@property (nonatomic, retain) NSSet *inSettings;

+ (instancetype)camera ;

+ (QY_camera *)findCameraById:(NSString *)cameraId ;

@end

@interface QY_camera (CoreDataGeneratedAccessors)

- (void)addInGroupsObject:(QY_cameraGroup *)value;
- (void)removeInGroupsObject:(QY_cameraGroup *)value;
- (void)addInGroups:(NSSet *)values;
- (void)removeInGroups:(NSSet *)values;

- (void)addShareUserObject:(QY_user *)value;
- (void)removeShareUserObject:(QY_user *)value;
- (void)addShareUser:(NSSet *)values;
- (void)removeShareUser:(NSSet *)values;

- (void)addInSettingsObject:(QY_cameraSetting *)value;
- (void)removeInSettingsObject:(QY_cameraSetting *)value;
- (void)addInSettings:(NSSet *)values;
- (void)removeInSettings:(NSSet *)values;

@end
