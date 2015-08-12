//
//  QY_user+Operations.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_user+Operations.h"
#import "QY_appDataCenter.h"
#import "QY_JPRO.h"
#import "NSError+QYError.h"
#import "QY_XMLService.h"
#import "QY_Socket.h"
#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>
#import "QY_Notify.h"

@implementation QY_user (Operations)

#pragma mark - 数据库交互

+ (QY_user *)user {
    QY_user *user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[QY_appDataCenter managedObjectContext]] ;
    return user ;
}

+ (QY_user *)findUserById:(NSString *)userId {
    if ( !userId ) return nil ;
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
    
#warning JRM服务器问题太多了，这里如果不等待一段时间，连接JRM会失败。。
    [QYUtils runAfterSecs:0.5f block:^{
        QYDebugLog(@"UserId = %@,拉取JPRO服务器信息",self.userId) ;
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
        QYDebugLog(@"jpro 信息不存在，拉取jrm") ;
        [self fetchJproServerInfoComplection:^(BOOL success, NSError *error) {
            if ( success ) {
                [self fetchUserInfoComplection:complection] ;
            } else {
                complection(nil,error) ;
            }
        }] ;
        return ;
    }
    
    QYDebugLog(@"jpro = %@",self.jpro) ;
    
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
        
        if ( error ) {
            [QY_appDataCenter undo] ;
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
            
            NSError *saveError ;
            [QY_appDataCenter saveObject:nil error:&saveError] ;
            
            if ( saveError ) {
                complection(nil,saveError) ;
            } else {
                complection(self,nil) ;
            }
        } else {
            QYDebugLog(@"上传失败 error = %@",error) ;
            error = [NSError QYErrorWithCode:JPRO_UPLOAD_PROFILE_ERROR description:@"上传PROFILE的时候出错"] ;
            complection(nil,error) ;
        }
    }] ;
}

#pragma mark - jpro_friend

//ok
- (void)addFriendById:(NSString *)friendId complection:(QYResultBlock)complection {
    assert(friendId && friendId!=self.userId) ;
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
#warning 非原子性操作。失败会污染数据源。
    
    QY_user *friend = [QY_user insertUserById:friendId] ;
    QY_user *me = self ;
    
    [friend fetchUserInfoComplection:^(QY_user *user, NSError *error) {
        if ( user && !error ) {
            [me fetchUserInfoComplection:^(QY_user *user2, NSError *error) {
                if ( user2 && !error ) {
                    
                    QY_friendSetting *me2Friend = [QY_friendSetting settingFromOwner:me toFriend:friend] ;
                    
                    [me2Friend saveComplection:^(BOOL success, NSError *error) {
                        if ( success ) {
                            QYDebugLog(@"单项添加成功") ;
                            [QY_appDataCenter saveObject:nil error:NULL] ;
                            
                            QY_friendSetting *friend2Me = [QY_friendSetting settingFromOwner:friend toFriend:me] ;
                            
                            [friend2Me saveComplection:^(BOOL success, NSError *error) {
                                if ( success ) {
                                    QYDebugLog(@"双向添加成功") ;
                                    [QY_appDataCenter saveObject:nil error:NULL] ;
                                    complection(true,nil) ;
                                } else {
                                    [[QY_appDataCenter managedObjectContext] undo] ;
                                    complection(false,error) ;
                                }
                            }] ;
                            
                        } else {
                            [[QY_appDataCenter managedObjectContext] undo] ;
                            complection(false,error) ;
                        }
                    }] ;
                    
                } else {
                    [QYUtils alertError:error] ;
                    complection(false,error) ;
                }
            }] ;
        } else {
            [QYUtils alertError:error] ;
            complection(false,error) ;
        }
    }] ;
}

- (void)deleteFriendById:(NSString *)friendId complection:(QYResultBlock)complection {
    assert(friendId && friendId!=self.userId) ;
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    NSString *selfId = self.userId ;
    QY_user *friend = [QY_user insertUserById:friendId] ;
#warning 非原子性操作可能会失败。。等待服务器重写。合并删除操作。
    dispatch_group_t group = dispatch_group_create() ;
    
    __block NSError *tError ;
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSString *selfPath = [QY_JPROUrlFactor pathForUserFriendList:friendId FriendId:selfId] ;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
        
        [[QY_JPROHttpService shareInstance] clearDocumentOnPath:selfPath Complection:^(BOOL success, NSError *error) {
            if ( success ) {
            } else {
                tError = error ;
            }
            
            dispatch_semaphore_signal(sema) ;
        }] ;
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER) ;
    }) ;
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSString *friendPath = [QY_JPROUrlFactor pathForUserFriendList:selfId FriendId:friendId] ;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
        
        [[QY_JPROHttpService shareInstance] clearDocumentOnPath:friendPath Complection:^(BOOL success, NSError *error) {
            if ( success ) {
            } else {
                tError = error ;
            }
            dispatch_semaphore_signal(sema) ;
        }] ;
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER) ;
    }) ;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ( tError ) {
            complection(false,tError) ;
        } else {
#warning 有实例方法删除吗？
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(owner.userId == %@ AND toFriend.userId == %@) OR (owner.userId == %@ AND toFriend.userId == %@)",self.userId,friend.userId,friend.userId,self.userId] ;
            [QY_appDataCenter deleteObjectsWithClassName:NSStringFromClass([QY_friendSetting class]) predicate:predicate] ;
            [QY_appDataCenter saveObject:nil error:NULL] ;
            complection(true,nil) ;
        }
    }) ;
    
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
                
                QY_user *friend = [QY_user insertUserById:fileName] ;
                
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

#pragma mark - jpro_camera

- (void)fetchCamerasSettingsComplection:(QYArrayBlock)complection {
    assert(complection) ;
    
    //
    NSString *path = [QY_JPROUrlFactor pathForUserCameraList:self.userId] ;
    
    [[QY_JPROHttpService shareInstance] getDocumentListForPath:path Complection:^(NSArray *objects, NSError *error) {
        if ( !error ) {
            QYDebugLog(@"objects = %@",objects) ;
            
            NSMutableSet *settings = [NSMutableSet set] ;
            
            [objects enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
                NSString *cameraId = [fileName stringByDeletingPathExtension] ;
                
                QY_cameraSetting *setting = [QY_cameraSetting insertCameraSettingByOwnerId:self.userId cameraId:cameraId] ;
                
                [settings addObject:setting] ;
            }] ;
            
            [self setCameraSettings:settings] ;
            QYDebugLog(@"相机列表列表获取完成") ;
            //拉取所有服务器资料
            
            dispatch_group_t group = dispatch_group_create() ;
#warning 没有处理错误的能力！！！！！！
            [self.cameraSettings enumerateObjectsUsingBlock:^(QY_cameraSetting *setting, BOOL *stop) {
                
                dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                    
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
                    
                    [setting fetchCameraSettingComplection:^(id object, NSError *error) {
                        if ( object && !error ) {
                            
                        } else {
                            
                        }
                        
                        dispatch_semaphore_signal(sema) ;
                    }] ;
                    
                    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC) ;
                    dispatch_semaphore_wait(sema, timeout) ;
                }) ;
                
            }] ;
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                QYDebugLog(@"相机资料拉取完成") ;
                complection([self.cameraSettings allObjects],nil) ;
            }) ;
            
            
        } else {
            complection(nil,error) ;
        }
    }] ;
    
}

#pragma mark - jpro_报警信息

- (void)fetchAlertMessagesComplection:(QYArrayBlock)complection {
    
    [[QY_JPROHttpService shareInstance] getAlertMessageListPage:1 NumPerPage:10 Type:NSNotFound UserId:nil cameraId:nil StartId:nil EndId:nil Check:nil Complection:^(NSArray *alertMsgDics, NSError *error) {
        NSArray *objects ;
        if (!error) {
            NSSet *alertMsgs = [QY_alertMessage messageWithDicArray:alertMsgDics] ;
            objects = [alertMsgs allObjects] ;
            [QY_appDataCenter saveObject:nil error:NULL] ;
        }
        if (complection) {
            complection(objects,error) ;
        }
        
    }] ;
}

#pragma mark - jpro_朋友圈

- (void)deleteCommentById:(NSString *)commentId complection:(QYResultBlock)complection {
    [[QY_JPROHttpService shareInstance] deleteCommentById:commentId Complection:^(BOOL success, NSError *error) {
        if ( success ) [QY_appDataCenter deleteobject:[QY_comment findCommentById:commentId]] ;
        
        if ( complection ) {
            complection(success,error) ;
        }
    }] ;
}

- (void)deleteFeedById:(NSString *)feedId Complection:(QYResultBlock)complection {
    [[QY_JPROHttpService shareInstance] deleteFeedById:feedId Complection:^(BOOL success, NSError *error) {
        if ( success ) [QY_appDataCenter deleteobject:[QY_feed findFeedById:feedId]] ;
        
        if ( complection ) {
            complection(success,error) ;
        }
    }] ;
}

#pragma mark - phone

- (void)applyValidateCodeForTelephone:(NSString *)telephone validateCode:(NSString *)code complection:(QYResultBlock)complection {
    assert(self.userId) ;
    assert(telephone) ;
    [[QY_SocketAgent shareInstance] verifyTelephoneForUser:self.userId Telephone:telephone VerifyCode:code Complection:complection] ;
}

- (void)saveTelephone:(NSString *)telephone Complection:(QYResultBlock)complection {
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    [[QY_SocketAgent shareInstance] bindingTelephoneForUser:self.userId Telephone:telephone Complection:^(BOOL success, NSError *error) {
        if ( success ) {
            self.phone = telephone ;
            [QY_appDataCenter saveObject:nil error:NULL] ;
            complection(true,nil) ;
        } else {
            complection(false,error) ;
        }
    }] ;
}

- (void)fetchTelephoneComplection:(QYResultBlock)complection {
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    [[QY_SocketAgent shareInstance] getTelephoneByUserId:self.userId Complection:^(NSDictionary *info, NSError *error) {
        if ( info && !error ) {
            NSString *phone = info[ParameterKey_userPhone] ;
            self.phone = phone ;
            complection(true,error) ;
        } else {
            complection(false,error) ;
        }
    }] ;
}

#pragma mark - UI

- (void)displayCycleAvatarAtImageView:(UIImageView *)avatarImageView {
    assert(avatarImageView) ;
    [self displayAvatarAtImageView:avatarImageView] ;
    [avatarImageView.layer setCornerRadius:CGRectGetHeight([avatarImageView bounds]) / 2.0f] ;
    avatarImageView.layer.masksToBounds = YES ;
}

- (void)displayAvatarAtImageView:(UIImageView *)avatarImageView {
    if (!avatarImageView) return ;
    UIImage *placeHolder = [UIImage imageNamed:@"二维码名片-头像"] ;
    
    NSString *path = [QY_JPROUrlFactor pathForUserAvatar:self.userId] ;
    
    UIImage *cachedImage = [[QY_CacheService shareInstance] getAvatarByUserId:self.userId] ;
    if ( !cachedImage ) {
        avatarImageView.image = placeHolder ;
        [[QY_JPROHttpService shareInstance] downloadImageFromPath:path complection:^(UIImage *image, NSError *error) {
            if ( image ) {
                [[QY_CacheService shareInstance] cacheAvatar:image forUserId:self.userId] ;
                [QYUtils runInMainQueue:^{
                    avatarImageView.image = image ;
                }] ;
            } else {
                QYDebugLog(@"无头像或获取头像失败 error = %@",error) ;
            }
        }] ;
    } else {
        avatarImageView.image = cachedImage ;
    }
}

- (void)saveAvatar:(UIImage *)avatar complection:(QYResultBlock)complection {
    if ( !avatar ) return ;
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    NSData *imageData = UIImageJPEGRepresentation(avatar, 1.0) ? : UIImagePNGRepresentation(avatar) ;
    
    NSString *path = [QY_JPROUrlFactor pathForUserAvatar:self.userId] ;
    
    [[QY_JPROHttpService shareInstance] uploadFileToPath:path FileData:imageData fileName:@"headpicture.jpg" mimeType:MIMETYPE Complection:^(BOOL success, NSError *error) {
        if ( success ) {
            [[QY_CacheService shareInstance] cacheAvatar:avatar forUserId:self.userId] ;
            [[QY_Notify shareInstance] postAvatarNotify] ;
            complection(true,nil) ;
        } else {
            complection(false,error) ;
        }
    }] ;
    
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

- (NSArray *)visualableAlertMessages {
    NSArray* alertMessages = [NSMutableArray array] ;
#warning 如何查到别人的。
#warning date筛选。
    NSDate *beginDate ;
    {
        NSDate *endDate = [NSDate date] ;
        NSTimeInterval beginTimeInterval = [QYUtils date2timestamp:endDate] ;
        beginTimeInterval -= 3600*24*7 ;//7天
        beginDate = [QYUtils timestamp2date:beginTimeInterval] ;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ AND (pubDate >= %@)",self.userId,beginDate] ;
    alertMessages = [QY_appDataCenter findObjectsWithClassName:NSStringFromClass([QY_alertMessage class]) predicate:predicate] ;
    
    return alertMessages ;
}

- (NSArray *)visualableFeedItems {
    NSMutableArray *friendIds = [NSMutableArray array] ;
    [self.friends enumerateObjectsUsingBlock:^(QY_user *friend, BOOL *stop) {
        [friendIds addObject:friend.userId] ;
    }] ;
    [friendIds addObject:self.userId] ;
    
    NSArray *feeds ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner.userId IN %@",friendIds] ;
    feeds = [QY_appDataCenter findObjectsWithClassName:NSStringFromClass([QY_feed class]) predicate:predicate] ;
#warning 排序！
    
    return feeds ;
}

- (NSString *)displayName {
    return self.nickname ? : self.userName ;
}

#pragma mark - AUser


/**
 *  用户名
 */
- (NSString *)aName {
#warning bug，除了当前用户，其他用户应该显示昵称
    return self.displayName ;
}

/**
 *  用户Id
 */
- (NSString *)aUserId {
    return self.userId ;
}

- (void)aDisplayUserAvatarAtImageView:(UIImageView *)avatarImgView {
    [self displayCycleAvatarAtImageView:avatarImgView] ;
}



@end
