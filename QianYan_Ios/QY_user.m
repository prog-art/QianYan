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

#import "QY_JPRO.h"
#import "NSError+QYError.h"
#import "QY_XMLService.h"


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

#pragma mark - 数据库交互

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

#pragma mark - 远端数据库交互

- (void)fetchJproServerInfoComplection:(QYObjectBlock)complection {
    
}

- (void)fetchUserInfoComplection:(QYObjectBlock)complection {
    assert(self.userId) ;
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    if ( !self.jpro ) {
        
    }
}

- (void)fetchFriendsComplection:(QYArrayBlock)complection {
    assert(self.userId) ;
    complection = ^(NSArray *objects,NSError *error) {
        if ( complection ) {
            complection(objects,error) ;
        }
    } ;

    NSString *remotePath = [QY_JPROUrlFactor pathForUserFriendList:self.userId] ;
    
    //获取好友列表
    [[QY_JPROHttpService shareInstance] getDocumentListForPath:remotePath Complection:^(NSArray *objects, NSError *error) {
        if ( objects ) {
            
            NSMutableArray *mObjects = [NSMutableArray array] ;
            [objects enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
                fileName = [fileName stringByDeletingPathExtension] ;
                [mObjects addObject:fileName] ;
            }] ;
            
            [self fetchFriendSettings:mObjects Complection:complection] ;
        } else {
            NSError *error = [NSError QYErrorWithCode:JPRO_GET_FRIENDLIST_ERROR description:@"获取好友列表出错"] ;
            complection(FALSE,error) ;
        }
    }] ;
}

- (void)fetchFriendSettings:(NSArray *)friendIds Complection:(QYArrayBlock)complection {
    assert(complection) ;

//    NSMutableSet *localFriends = [NSMutableSet set] ;
    
    NSMutableSet *noDataFriendIds = [NSMutableSet set] ;

#warning 先阶段没写cache policy 。回头加上，暂时用刷新就刷新所有的数据。
    [friendIds enumerateObjectsUsingBlock:^(NSString *friendId, NSUInteger idx, BOOL *stop) {
//        QY_user *localFriend = [QY_user findUserById:friendId] ;
//        
//        if ( localFriend ) {
//            [localFriends addObject:localFriend] ;
//        } else {
//            [noDataFriendIds addObject:friendId] ;
//        }
        [noDataFriendIds addObject:friendId] ;
    }] ;
    
#warning 客户端一次性拿所有的数据很容易出错！如果可以，服务端提供一个接口一次性获取比较好。否则人数多了会有性能问题。
    dispatch_group_t group = dispatch_group_create() ;
    
    NSString *selfId = self.userId ;
    
    __block NSMutableSet *friends = [NSMutableSet set] ;
    __block NSMutableSet *friendSettings = [NSMutableSet set] ;
#warning 这个error是针对一次性拿所有数据的。提供一次性接口后可以删除。[无应对方法]
    __block NSError *gError ;
    
    [noDataFriendIds enumerateObjectsUsingBlock:^(NSString *friendId, BOOL *stop) {
#warning 人数多了可能会有性能问题。
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            NSString *remotePath = [QY_JPROUrlFactor pathForUserFriendList:selfId FriendId:friendId] ;
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;

            [[QY_JPROHttpService shareInstance] downloadFileFromPath:remotePath complection:^(NSString *xmlStr , NSError *error) {
                if ( xmlStr ) {
                    QY_friendSetting *friendSetting = [QY_XMLService getSesttingFromIdXML:xmlStr] ;

                    QY_user *friend = friendSetting.toFriend ;
                    
#warning 包含待删除字段friends
                    @synchronized(friends){
                        [friends addObject:friend] ;
                    }
                    
                    @synchronized(friendSetting){
                        [friendSettings addObject:friendSetting] ;
                    }
                } else {
                    gError = error ;
                }
                dispatch_semaphore_signal(sema) ;
            }] ;
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC) ;
            dispatch_semaphore_wait(sema, timeout) ;
//            QYDebugLog(@"group %lu ok",(unsigned long)idx) ;
        }) ;
        
            
    }] ;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self setFriends:friends] ;
        [self setFriendSettings:friendSettings] ;
        NSError *error = gError ? [NSError QYErrorWithCode:ALL_FIX_ERROR description:@"接口问题，获取数据不全。"] : nil ;
        [QY_appDataCenter saveObject:nil error:NULL] ;
        complection([self.friendSettings allObjects],error) ;
    }) ;
    
}



@end
