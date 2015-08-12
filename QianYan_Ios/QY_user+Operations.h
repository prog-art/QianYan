//
//  QY_user+Operations.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_user.h"
#import "QY_Block_Define.h"

#import "QYSocialDataModelInterface.h"

@class UIImageView ;
@class UIImage ;

@interface QY_user (Operations)<AUser>

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

//用户只能通过setting获取到他所能看到的所有相机。
- (void)fetchCamerasSettingsComplection:(QYArrayBlock)complection ;

#pragma mark - jpro_报警信息

- (void)fetchAlertMessagesComplection:(QYArrayBlock)complection ;

#pragma mark - jpro_朋友圈

- (void)deleteCommentById:(NSString *)commentId complection:(QYResultBlock)complection ;

- (void)deleteFeedById:(NSString *)feedId Complection:(QYResultBlock)complection ;

#pragma mark - jrm[phone,jpro]

- (void)fetchJproServerInfoComplection:(QYResultBlock)complection ;

- (void)applyValidateCodeForTelephone:(NSString *)telephone validateCode:(NSString *)code complection:(QYResultBlock)complection ;

- (void)saveTelephone:(NSString *)telephone Complection:(QYResultBlock)complection ;

- (void)fetchTelephoneComplection:(QYResultBlock)complection ;

#pragma mark - UI

- (void)displayCycleAvatarAtImageView:(UIImageView *)avatarImageView ;

- (void)displayAvatarAtImageView:(UIImageView *)avatarImageView ;

- (void)saveAvatar:(UIImage *)avatar complection:(QYResultBlock)complection ;

#pragma mark - getter && setter

- (NSString *)jpro ;

- (void)setJpro:(NSString *)jpro ;

- (NSSet *)friends ;

- (NSArray *)visualableAlertMessages ;

- (NSArray *)visualableFeedItems ;

- (NSString *)displayName ;

@end
