//
//  QY_user.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_user.h"
#import "QY_camera.h"
#import "QY_cameraGroup.h"
#import "QY_cameraSetting.h"
#import "QY_feed.h"
#import "QY_friendGroup.h"
#import "QY_friendSetting.h"
#import "QY_user.h"

#import "QY_appDataCenter.h"


@implementation QY_user

@dynamic avatarUrl;
@dynamic birthday;
@dynamic email;
@dynamic gender;
@dynamic jpro;
@dynamic location;
@dynamic nickname;
@dynamic phone;
@dynamic signature;
@dynamic userId;
@dynamic userName;
@dynamic cameraGroups;
@dynamic cameras;
@dynamic cameraSettings;
@dynamic diggedFeeds;
@dynamic feeds;
@dynamic friendGroups;
@dynamic friends;
@dynamic friendSettings;
@dynamic inGroups;
@dynamic sharedCameras;
@dynamic inSettings;

+ (QY_user *)user {
    QY_user *user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[QY_appDataCenter managedObjectContext]] ;
    return user ;
}

+ (QY_user *)findUserById:(NSString *)userId {
    assert(userId) ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@",userId] ;
    QY_user *user = (QY_user *)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;
    return user ;
}

+ (QY_user *)insertUserById:(NSString *)userId {
    return [QY_appDataCenter userWithId:userId] ;
}

@end
