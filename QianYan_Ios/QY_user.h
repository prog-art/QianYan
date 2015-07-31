//
//  QY_user.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_camera, QY_cameraGroup, QY_cameraSetting, QY_feed, QY_friendGroup, QY_friendSetting, QY_user;

@interface QY_user : NSManagedObject

@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * jpro;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *cameraGroups;
@property (nonatomic, retain) NSSet *cameras;
@property (nonatomic, retain) NSSet *cameraSettings;
@property (nonatomic, retain) NSSet *diggedFeeds;
@property (nonatomic, retain) NSSet *feeds;
@property (nonatomic, retain) NSSet *friendGroups;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *friendSettings;
@property (nonatomic, retain) NSSet *inGroups;
@property (nonatomic, retain) NSSet *sharedCameras;
@property (nonatomic, retain) NSSet *inSettings;

+ (QY_user *)user ;

+ (QY_user *)findUserById:(NSString *)userId ;

+ (QY_user *)insertUserById:(NSString *)userId ;

@end

@interface QY_user (CoreDataGeneratedAccessors)

- (void)addCameraGroupsObject:(QY_cameraGroup *)value;
- (void)removeCameraGroupsObject:(QY_cameraGroup *)value;
- (void)addCameraGroups:(NSSet *)values;
- (void)removeCameraGroups:(NSSet *)values;

- (void)addCamerasObject:(QY_camera *)value;
- (void)removeCamerasObject:(QY_camera *)value;
- (void)addCameras:(NSSet *)values;
- (void)removeCameras:(NSSet *)values;

- (void)addCameraSettingsObject:(QY_cameraSetting *)value;
- (void)removeCameraSettingsObject:(QY_cameraSetting *)value;
- (void)addCameraSettings:(NSSet *)values;
- (void)removeCameraSettings:(NSSet *)values;

- (void)addDiggedFeedsObject:(QY_feed *)value;
- (void)removeDiggedFeedsObject:(QY_feed *)value;
- (void)addDiggedFeeds:(NSSet *)values;
- (void)removeDiggedFeeds:(NSSet *)values;

- (void)addFeedsObject:(QY_feed *)value;
- (void)removeFeedsObject:(QY_feed *)value;
- (void)addFeeds:(NSSet *)values;
- (void)removeFeeds:(NSSet *)values;

- (void)addFriendGroupsObject:(QY_friendGroup *)value;
- (void)removeFriendGroupsObject:(QY_friendGroup *)value;
- (void)addFriendGroups:(NSSet *)values;
- (void)removeFriendGroups:(NSSet *)values;

- (void)addFriendsObject:(QY_user *)value;
- (void)removeFriendsObject:(QY_user *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addFriendSettingsObject:(QY_friendSetting *)value;
- (void)removeFriendSettingsObject:(QY_friendSetting *)value;
- (void)addFriendSettings:(NSSet *)values;
- (void)removeFriendSettings:(NSSet *)values;

- (void)addInGroupsObject:(QY_friendGroup *)value;
- (void)removeInGroupsObject:(QY_friendGroup *)value;
- (void)addInGroups:(NSSet *)values;
- (void)removeInGroups:(NSSet *)values;

- (void)addSharedCamerasObject:(QY_camera *)value;
- (void)removeSharedCamerasObject:(QY_camera *)value;
- (void)addSharedCameras:(NSSet *)values;
- (void)removeSharedCameras:(NSSet *)values;

- (void)addInSettingsObject:(QY_friendSetting *)value;
- (void)removeInSettingsObject:(QY_friendSetting *)value;
- (void)addInSettings:(NSSet *)values;
- (void)removeInSettings:(NSSet *)values;

@end
