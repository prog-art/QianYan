//
//  QY_user.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_user.h"
#import "QY_camera.h"
#import "QY_cameraGroup.h"
#import "QY_cameraSetting.h"
#import "QY_feed.h"
#import "QY_friendGroup.h"
#import "QY_friendSetting.h"

#import "QY_appDataCenter.h"
#import "QY_JPRO.h"
#import "NSError+QYError.h"
#import "QY_XMLService.h"
#import "QY_Socket.h"

@implementation QY_user

@dynamic avatarUrl;
@dynamic birthday;
@dynamic email;
@dynamic gender;
@dynamic location;
@dynamic nickname;
@dynamic phone;
@dynamic signature;
@dynamic userId;
@dynamic userName;
@dynamic jproIp;
@dynamic jproPort;
@dynamic cameraGroups;
@dynamic cameras;
@dynamic cameraSettings;
@dynamic diggedFeeds;
@dynamic feeds;
@dynamic friendGroups;
@dynamic friendSettings;
@dynamic inGroups;
@dynamic inSettings;
@dynamic sharedCameras;


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

- (void)fetchJproServerInfoComplection:(QYResultBlock)complection {
    assert(complection) ;
    assert(self.userId) ;
    
    
    [[QY_SocketAgent shareInstance] getJPROServerInfoForUser:self.userId Complection:^(NSDictionary *info, NSError *error) {
        if ( !error && info ) {
            self.jproIp   = info[ParameterKey_jproIp] ;
            self.jproPort = info[ParameterKey_jproPort] ;
//            self.jproPsd  = info[ParameterKey_jproPassword] ;
            [QY_appDataCenter saveObject:nil error:NULL] ;
            QYDebugLog(@"获得JPRO信息 = %@",self.jpro) ;
            [[QY_JPROHttpService shareInstance] configIp:self.jproIp Port:self.jproPort] ;            
            complection(TRUE,nil) ;
        } else {
            QYDebugLog(@"获取用户jpro服务器信息出错 error = %@",error) ;
            error = [NSError QYErrorWithCode:JRM_GET_USER_JPRO_ERROR description:@"获取JPRO服务器信息出错。"] ;
            complection(false,error) ;
        }
    }] ;
}

- (void)fetchUserInfoComplection:(QYObjectBlock)complection {
    assert(self.userId) ;
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    if ( !self.jpro ) {
        [self fetchJproServerInfoComplection:^(BOOL success, NSError *error) {
            if ( success ) {
                [self fetchUserInfoComplection:complection] ;
            } else {
                complection(nil,error) ;
            }
        }] ;
        return ;
    }
    
    NSString *path = [QY_JPROUrlFactor pathForUserProfile:self.userId] ;
    
    [[QY_JPROHttpService shareInstance] downloadFileFromPath:path complection:^(NSString *xmlStr, NSError *error) {
        if ( xmlStr ) {
            NSError *phraseError ;
            [QY_XMLService initUser:self withProfileXMLStr:xmlStr error:&phraseError] ;
            
            //save
            [QY_appDataCenter saveObject:nil error:NULL] ;
            
            if ( !phraseError ) {
                complection(self,nil) ;
            } else {
                complection(nil,phraseError) ;
            }
        } else {
            NSError *error = [NSError QYErrorWithCode:JPRO_DOWNLOAD_PROFILE_ERROR description:@"下载PROFILE的时候出错"] ;
            complection(nil,error) ;
        }
    }] ;
}

- (void)saveUserInfoComplection:(QYObjectBlock)complection {
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    if ( !self.jpro ) {
        [self fetchJproServerInfoComplection:^(BOOL success, NSError *error) {
            if ( success ) {
                [self saveUserInfoComplection:complection] ;
            } else {
                complection(nil,error);
            }
        }] ;
        return ;
    }
    
    NSString *profileXmlStr = [QY_XMLService getProfileXMLFromUser:self] ;
    QYDebugLog(@"profileXmlStr = %@",profileXmlStr) ;
    
    NSData *xmlData = [profileXmlStr dataUsingEncoding:NSUTF8StringEncoding] ;
    
    NSString *path = [self profilePath] ;
    
    [[QY_JPROHttpService shareInstance] uploadFileToPath:path FileData:xmlData fileName:@"profile.xml" mimeType:MIMETYPE Complection:^(BOOL success, NSError *error) {
        if ( success ) {
            QYDebugLog(@"上传成功") ;
            complection(self,nil) ;
        } else {
            QYDebugLog(@"上传失败 error = %@",error) ;
            error = [NSError QYErrorWithCode:JPRO_UPLOAD_PROFILE_ERROR description:@"上传PROFILE的时候出错"] ;
            complection(nil,error) ;
        }
    }] ;
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
            NSMutableArray *mSettings = [NSMutableArray array] ;
            [objects enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
                fileName = [fileName stringByDeletingPathExtension] ;
                QY_user *friend = [QY_appDataCenter userWithId:fileName] ;
                
                QY_friendSetting *setting = [QY_friendSetting settingFromOwner:self toFriend:friend] ;
                [mSettings addObject:setting] ;
            }] ;
            
            [self fetchFriendSettings:mSettings Complection:complection] ;
        } else {
            NSError *error = [NSError QYErrorWithCode:JPRO_GET_FRIENDLIST_ERROR description:@"获取好友列表出错"] ;
            complection(FALSE,error) ;
        }
    }] ;
}

- (void)fetchFriendSettings:(NSArray *)friendSettings Complection:(QYArrayBlock)complection {
    assert(complection) ;
    
    NSMutableSet *noDataFriendSettings = [NSMutableSet set] ;
    
#warning 先阶段没写cache policy 。回头加上，暂时用刷新就刷新所有的数据。
    [friendSettings enumerateObjectsUsingBlock:^(QY_friendSetting *friendSetting, NSUInteger idx, BOOL *stop) {
        [noDataFriendSettings addObject:friendSetting] ;
    }] ;
    
#warning 客户端一次性拿所有的数据很容易出错！如果可以，服务端提供一个接口一次性获取比较好。否则人数多了会有性能问题。
    dispatch_group_t group = dispatch_group_create() ;
    
#warning 这个error是针对一次性拿所有数据的。提供一次性接口后可以删除。[无应对方法]
    __block NSError *gError ;
    
    __block NSSet *bFriendSettings = [NSSet setWithArray:friendSettings] ;
    
    [noDataFriendSettings enumerateObjectsUsingBlock:^(QY_friendSetting *friendSetting, BOOL *stop) {
#warning 人数多了可能会有性能问题。
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
            [friendSetting fetchComplection:^(QY_friendSetting *setting, NSError *error) {
                if ( setting && !error ) {
                } else {
                    gError = error ;
                }
                
                dispatch_semaphore_signal(sema) ;
            }] ;
            
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC) ;
            dispatch_semaphore_wait(sema, timeout) ;
        }) ;
        
        
    }] ;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self setFriendSettings:bFriendSettings] ;
        NSError *error = gError ? [NSError QYErrorWithCode:ALL_FIX_ERROR description:@"接口问题，获取数据不全。"] : nil ;
        [QY_appDataCenter saveObject:nil error:NULL] ;
        complection([self.friendSettings allObjects],error) ;
    }) ;
}

#pragma mark - getter && setter

- (NSString *)jpro {
    if ( self.jproIp && self.jproPort ) return [NSString stringWithFormat:@"http://%@:%@/",self.jproIp,self.jproPort] ;
    return nil ;
}

- (void)setJpro:(NSString *)jpro {
    if ( !jpro ) return ;
#warning 这里可以改为正则表达式，不过时间原因，打上warning ： 参考 http://www.admin10000.com/document/5944.html
    
    NSURL *url = [NSURL URLWithString:jpro] ;
    
    self.jproIp = [url host] ;
    self.jproPort = [[url port] stringValue];
}

- (NSSet *)friends {
    NSMutableSet *friends = [NSMutableSet set] ;
    [self.friendSettings enumerateObjectsUsingBlock:^(QY_friendSetting *friendSetting, BOOL *stop) {
        [friends addObject:friendSetting.toFriend] ;
    }] ;
    return friends ;
} ;

- (NSString *)profilePath {
    if ( self.userId ) return [QY_JPROUrlFactor pathForUserProfile:self.userId] ;
    return nil ;
}

@end
