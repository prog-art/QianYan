//
//  QY_friendSetting.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_friendSetting.h"
#import "QY_user.h"

#import "QY_appDataCenter.h"
#import "QY_XMLService.h"
#import "QY_JPRO.h"
#import "NSError+QYError.h"

@implementation QY_friendSetting

@dynamic black;
@dynamic fans;
@dynamic follow;
@dynamic remarkName;
@dynamic shield;
@dynamic owner;
@dynamic toFriend;

+ (QY_friendSetting *)setting {
    QY_friendSetting *setting = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[QY_appDataCenter managedObjectContext]] ;
    
    setting.fans = @0 ;
    setting.black = @0 ;
    setting.follow = @0 ;
    setting.shield = @0 ;
    
    return setting ;
}

+ (QY_friendSetting *)settingFromOwner:(QY_user *)owner toFriend:(QY_user *)toFriend {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner.userId == %@ AND toFriend.userId == %@",owner.userId,toFriend.userId] ;
    
    QY_friendSetting *setting = (QY_friendSetting *)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;
    
    if ( !setting ) {
        setting = [self setting] ;
        setting.owner = owner ;
        setting.toFriend = toFriend ;
        setting.remarkName = toFriend.nickname ;
    }
    
    return setting ;
}

#pragma mark - 远端数据库交互

- (void)saveComplection:(QYResultBlock)complection {
    complection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;

    if ( !self.owner.jpro ) {
        [self.owner fetchJproServerInfoComplection:^(BOOL success, NSError *error) {
            if ( success ) {
                [self saveComplection:complection] ;
            } else {
                complection(false,error) ;
            }
        }] ;
        return ;
    }
    
    NSData *data = [self xmlStringDataForTransportByHttp] ;
    
    NSString *path = [self path] ;
    
    [[QY_JPROHttpService shareInstance] uploadFileToPath:path FileData:data fileName:@"file" mimeType:MIMETYPE Complection:complection] ;
}

- (void)fetchComplection:(QYObjectBlock)complection {
    complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    };
    
    if ( !self.owner.jpro ) {
        [self.owner fetchJproServerInfoComplection:^(BOOL success, NSError *error) {
            if ( success ) {
                [self fetchComplection:complection] ;
            } else {
                NSError *error = [NSError QYErrorWithCode:JRM_GET_USER_JPRO_ERROR description:@"获取用户存储服务器地址出错"] ;
                complection(nil,error) ;
            }
        }] ;
        return ;
    }
    
    NSString *remotePath = [QY_JPROUrlFactor pathForUserFriendList:self.owner.userId FriendId:self.toFriend.userId] ;
    
    [[QY_JPROHttpService shareInstance] downloadFileFromPath:remotePath complection:^(NSString *xmlStr , NSError *error) {
        if ( xmlStr ) {
            NSError *phraseError ;
            [QY_XMLService initFriendSetting:self withFriendIdXMLStr:xmlStr error:&phraseError] ;
            
            if ( !phraseError ) {
                complection(self,nil) ;
            } else {
                complection(nil,phraseError) ;
            }
            
        } else {
            NSError *error = [NSError QYErrorWithCode:JPRO_GET_FRIENDSETTING_ERROR description:@"获取好友设置出错"] ;
            complection(nil,error) ;
        }
        
    }] ;
}

#pragma mark - Private

- (NSString *)xmlStringForSaveAtJpro {
    return [QY_XMLService QY_friendSettingXMLString:self] ;
}

- (NSData *)xmlStringDataForTransportByHttp {
    return [[self xmlStringForSaveAtJpro] dataUsingEncoding:NSUTF8StringEncoding] ;
}

#pragma mark -

- (NSString *)path {
    return [QY_JPROUrlFactor pathForUserFriendList:self.owner.userId FriendId:self.toFriend.userId] ;
}

- (NSString *)displayName {
    return self.remarkName ? : self.toFriend.displayName ;
}

@end
