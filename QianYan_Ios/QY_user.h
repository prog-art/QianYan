//
//  QY_user.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "QY_Block_Define.h"
#import "QYSocialDataModelInterface.h"

@class UIImageView ;
@class UIImage ;

@class QY_camera, QY_cameraGroup, QY_cameraSetting, QY_feed, QY_friendGroup, QY_friendSetting;

@interface QY_user : NSManagedObject<AUser>

@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * jproIp;
@property (nonatomic, retain) NSString * jproPort;
@property (nonatomic, retain) NSSet *cameraGroups;
@property (nonatomic, retain) NSSet *cameras;
@property (nonatomic, retain) NSSet *cameraSettings;
@property (nonatomic, retain) NSSet *diggedFeeds;
@property (nonatomic, retain) NSSet *feeds;
@property (nonatomic, retain) NSSet *friendGroups;
@property (nonatomic, retain) NSSet *friendSettings;
@property (nonatomic, retain) NSSet *inGroups;
@property (nonatomic, retain) NSSet *inSettings;
@property (nonatomic, retain) NSSet *sharedCameras;


#pragma mark - 数据库交互

+ (QY_user *)user ;

+ (QY_user *)findUserById:(NSString *)userId ;

+ (QY_user *)insertUserById:(NSString *)userId ;

#pragma mark - jpro 远端数据库交互

- (void)fetchUserInfoComplection:(QYObjectBlock)complection ;

- (void)saveUserInfoComplection:(QYObjectBlock)complection ;

#pragma mark - jpro_friend

- (void)addFriendById:(NSString *)friendId complection:(QYResultBlock)complection ;

- (void)deleteFriendById:(NSString *)friendId complection:(QYResultBlock)complection ;

- (void)fetchFriendsComplection:(QYArrayBlock)complection ;

#pragma mark - jpro_camera

- (void)fetchCamerasComplection:(QYArrayBlock)complection ;

#pragma mark - jpro_朋友圈

- (void)deleteCommentById:(NSString *)commentId complection:(QYResultBlock)complection ;

#pragma mark - jrm[phone,jpro]

- (void)fetchJproServerInfoComplection:(QYResultBlock)complection ;

- (void)applyValidateCodeForTelephone:(NSString *)telephone validateCode:(NSString *)code complection:(QYResultBlock)complection ;

- (void)saveTelephone:(NSString *)telephone Complection:(QYResultBlock)complection ;

- (void)fetchTelephoneComplection:(QYResultBlock)complection ;

#pragma mark - UI

- (void)displayCycleAvatarAtImageView:(UIImageView *)avatarImageView ;

- (void)displayAvatarAtImageView:(UIImageView *)avatarIamgeView ;

- (void)saveAvatar:(UIImage *)avatar complection:(QYResultBlock)complection ;

#pragma mark - getter && setter

- (NSString *)jpro ;

- (void)setJpro:(NSString *)jpro ;

- (NSSet *)friends ;

- (NSArray *)visualableFeedItems ;

- (NSString *)displayName ;

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

- (void)addFriendSettingsObject:(QY_friendSetting *)value;
- (void)removeFriendSettingsObject:(QY_friendSetting *)value;
- (void)addFriendSettings:(NSSet *)values;
- (void)removeFriendSettings:(NSSet *)values;

- (void)addInGroupsObject:(QY_friendGroup *)value;
- (void)removeInGroupsObject:(QY_friendGroup *)value;
- (void)addInGroups:(NSSet *)values;
- (void)removeInGroups:(NSSet *)values;

- (void)addInSettingsObject:(QY_friendSetting *)value;
- (void)removeInSettingsObject:(QY_friendSetting *)value;
- (void)addInSettings:(NSSet *)values;
- (void)removeInSettings:(NSSet *)values;

- (void)addSharedCamerasObject:(QY_camera *)value;
- (void)removeSharedCamerasObject:(QY_camera *)value;
- (void)addSharedCameras:(NSSet *)values;
- (void)removeSharedCameras:(NSSet *)values;

@end
