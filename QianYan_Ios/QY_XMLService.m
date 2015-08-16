//
//  QY_XMLService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_XMLService.h"

#import "QY_XMLPhraser.h"
#import "QY_XMLFormatter.h"
#import "QY_Common.h"
#import "QY_appDataCenter.h"

#import "QY_jpro_parameter_key_marco.h"

#import <GDataXML-HTML/GDataXMLNode.h>

#define QY_STR(INT) [NSString stringWithFormat:@"%ld",(long)INT]

@interface QY_XMLPhraser ()

@end

@implementation QY_XMLService

#pragma mark - Obj --> xml Str

+ (NSString *)getProfileXMLFromUser:(QY_user *)user {
    GDataXMLElement *userTag = [GDataXMLNode elementWithName:@"user"] ;
    
    {
        GDataXMLElement *userIdAttr = [GDataXMLNode attributeWithName:@"id" stringValue:user.userId] ;
        [userTag addAttribute:userIdAttr] ;

        if ( user.userName ) {
            GDataXMLElement *usernameTag = [GDataXMLNode elementWithName:@"username" stringValue:user.userName] ;
            [userTag addChild:usernameTag] ;
        } ;
        
        if ( user.nickname ) {
            GDataXMLElement *nicknameTag = [GDataXMLNode elementWithName:@"nickname" stringValue:user.nickname] ;
            [userTag addChild:nicknameTag] ;
        }
        
        if ( user.gender ) {
            GDataXMLElement *genderTag = [GDataXMLElement elementWithName:@"gender" stringValue:user.gender] ;
            [userTag addChild:genderTag] ;
        }

        if ( user.location ) {
            GDataXMLElement *locationTag = [GDataXMLElement elementWithName:@"location" stringValue:user.location] ;
            [userTag addChild:locationTag] ;
        }
        
        if ( user.birthday ) {
            NSString *birthdayStr ;
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy年MM月dd日"] ;
                birthdayStr = [formatter stringFromDate:user.birthday] ;
            }
            
            GDataXMLElement *birthdayTag = [GDataXMLElement elementWithName:@"birthday" stringValue:birthdayStr] ;
            [userTag addChild:birthdayTag] ;
        }

        if ( user.signature ) {
            GDataXMLElement *signTag = [GDataXMLElement elementWithName:@"signature" stringValue:user.signature] ;
            [userTag addChild:signTag] ;
        }
        
        if ( user.jpro ) {
            GDataXMLElement *jproTag = [GDataXMLElement elementWithName:@"jpro" stringValue:user.jpro] ;
            [userTag addChild:jproTag] ;
        }
    }
    
    return [self xmlStrWithRootElement:userTag] ;
}

+ (NSString *)getFriendGroupsXMLFromGroups:(NSSet *)groups {
    GDataXMLElement *friendgroupsTag = [GDataXMLNode elementWithName:@"friendgroups"] ;
    
    [groups enumerateObjectsUsingBlock:^(QY_friendGroup *group, BOOL *stop) {
        [friendgroupsTag addChild:[self getFriendGroupXMLTagFromGroup:group]] ;
    }] ;
    
    return [self xmlStrWithRootElement:friendgroupsTag] ;
}

+ (GDataXMLElement *)getFriendGroupXMLTagFromGroup:(QY_friendGroup *)group {
    assert(group) ;
    
    GDataXMLElement *groupTag = [GDataXMLNode elementWithName:@"group"] ;
    
    GDataXMLElement *iosId = [GDataXMLElement elementWithName:@"iosGroupId" stringValue:group.iosGroupId] ;
    [groupTag addAttribute:iosId] ;
    
    {
        GDataXMLElement *groupnameTag = [GDataXMLNode elementWithName:@"groupname" stringValue:group.groupName] ;
        
        NSString *dateStr ;
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy/M/d/H/m/s"] ;
            dateStr = [formatter stringFromDate:group.groupDate] ;
        }
        GDataXMLElement *groupdateTag = [GDataXMLNode elementWithName:@"groupdate" stringValue:dateStr] ;

        NSMutableArray *userIds = [NSMutableArray array] ;
        [group.containUsers enumerateObjectsUsingBlock:^(QY_user *user, BOOL *stop) {
            [userIds addObject:user.userId] ;
        }] ;
        NSString *userIdStr = [userIds componentsJoinedByString:@";"] ;
        GDataXMLElement *friendidsTag = [GDataXMLNode elementWithName:@"friendids" stringValue:userIdStr] ;
        
        NSString *remark = group.remark ? : @"" ;
        GDataXMLElement *remarkTag = [GDataXMLNode elementWithName:@"remark" stringValue:remark] ;
        
        //ios增加
        
        [@[groupnameTag,groupdateTag,friendidsTag,remarkTag] enumerateObjectsUsingBlock:^(GDataXMLElement *tag, NSUInteger idx, BOOL *stop) {
            [groupTag addChild:tag] ;
        }] ;
    }
    
    return groupTag ;
}

#pragma mark - xml Str --> obj

+ (NSSet *)getGroupsFromXMLStr:(NSString *)xmlStr {
    NSMutableSet *groups = [NSMutableSet set] ;
    
    NSError *error ;
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:&error] ;
    if ( error ) {
#warning 这里修改接口！
        [QYUtils alertError:error] ;
        return nil ;
    } else {
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        NSArray *groupTags = [root elementsForName:@"group"] ;
        
        [groupTags enumerateObjectsUsingBlock:^(GDataXMLElement *groupTag, NSUInteger idx, BOOL *stop) {
            QY_friendGroup *group ;
            NSString *iosGroupId = [[groupTag attributeForName:@"iosGroupId"] stringValue] ;
            group = [QY_friendGroup insertGroupWithGroupId:iosGroupId] ;
            {
                group.groupName = [self getStringValueForElement:groupTag name:@"groupname"] ;
                
                NSString *groupDateStr = [self getStringValueForElement:groupTag name:@"groupdate"] ;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy/M/d/H/m/s"] ;
                group.groupDate = [formatter dateFromString:groupDateStr] ;
                
                group.remark = [self getStringValueForElement:groupTag name:@"remark"] ;
                //userIds
                NSString *userIdsStr = [self getStringValueForElement:groupTag name:@"friendids"] ;
                NSArray *userIds = [userIdsStr componentsSeparatedByString:@";"] ;
                
                //users
                NSMutableSet *containUser = [NSMutableSet set] ;
                [userIds enumerateObjectsUsingBlock:^(NSString *userId, NSUInteger idx, BOOL *stop) {
                    if ( userId.length > 6 ) {
                        QY_user *user = [QY_user insertUserById:userId] ;
                        [containUser addObject:user] ;
                    }

                }] ;
                [group setContainUsers:containUser] ;
            }
            [groups addObject:group] ;
        }] ;
    }
    
    return groups ;
}

#pragma mark -

+ (NSString *)getStringValueForElement:(GDataXMLElement *)root name:(NSString *)name {
    id object = [[root elementsForName:name] lastObject] ;
    
    if ( nil != object ) {
        return [object stringValue] ;
    }
    return nil ;
}

/**
 *  获取XML节点对应的字符串
 */
+ (NSString *)xmlStrWithRootElement:(GDataXMLElement *)rootElement {
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement] ;
    [xmlDoc setCharacterEncoding:@"utf-8"] ;
    
    NSData *data = [xmlDoc XMLData] ;
    NSString *xmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
    NSLog(@"xmlStr = %@",xmlStr) ;
    
    return xmlStr ;
}


//+ (QY_camera *)getCameraFromIdXML:(NSString *)xmlStr {
//    NSError *error ;
//    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:&error] ;
//    
//    if ( error ) {
//        [QYUtils alertError:error] ;
//        return nil ;
//    } else {
//        QY_camera *camera = [QY_camera camera] ;
//        
//        GDataXMLElement *root = [xmlDoc rootElement] ;
//        
//        camera.cameraId = [[root attributeForName:@"id"] stringValue] ;
//        NSString *ownerId = [self getStringValueForElement:root name:@"owner"] ;
//        camera.jpro = [self getStringValueForElement:root name:@"jpro"] ;
//        
//        [camera setOwner:[QY_appDataCenter userWithId:ownerId]] ;
//        
//        NSError *savingError ;
//        [QY_appDataCenter saveObject:camera error:&savingError] ;
//        
//        if ( savingError ) {
//            QYDebugLog(@"保存失败 error = %@",savingError) ;
//            [QYUtils alertError:error] ;
//        } else {
//            QYDebugLog(@"保存成功 camera = %@",camera) ;
//        }
//        
//        return camera ;
//    }
//}

+ (void)initCameraSetting:(QY_cameraSetting *)setting withCameraIdXMLStr:(NSString *)xmlStr error:(NSError **)error {
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:error] ;
    
    if ( *error ) {
        [QYUtils alertError:*error] ;
    } else {
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        //相机本体
        NSString *cameraId = [[root attributeForName:@"id"] stringValue] ;
        QY_camera *camera = [QY_camera insertCameraById:cameraId] ;
        camera.jpro = [self getStringValueForElement:root name:@"jpro"] ;
        setting.toCamera = camera ;
        //拥有者
        NSString *ownerId = [self getStringValueForElement:root name:@"owner"] ;
        camera.owner = [QY_user insertUserById:ownerId] ;

        //昵称
        NSString *nickname = [self getStringValueForElement:root name:@"nickname"] ;
        if ( nickname ) {
            setting.nickName = nickname ;
        }
    }
}

+ (void)initCamera:(QY_camera *)camera withProfileXMLStr:(NSString *)xmlStr error:(NSError **)error {
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:error] ;
    
    if ( *error ) {
        [QYUtils alertError:*error] ;
    } else {
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        NSString *cameraId = [[root attributeForName:@"id"] stringValue] ;
        camera.cameraId = cameraId ;
        
        NSString *ownerId = [self getStringValueForElement:root name:@"owner"] ;
        camera.owner = [QY_user insertUserById:ownerId] ;        
    }
}

+ (void)initFriendSetting:(QY_friendSetting *)setting withFriendIdXMLStr:(NSString *)xmlStr error:(NSError **)error {
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:error] ;
    
    if ( *error ) {
        [QYUtils alertError:*error] ;
    } else {
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        NSString *ownerId = [QYUser currentUser].userId ;
        
        NSString *userId = [[root attributeForName:@"id"] stringValue] ;
        setting.owner = [QY_appDataCenter userWithId:ownerId] ;
        setting.toFriend = [QY_appDataCenter userWithId:userId] ;
        setting.toFriend.jpro = [self getStringValueForElement:root name:@"jpro"] ;

        setting.black = @([[self getStringValueForElement:root name:@"black"] integerValue]);
        setting.fans = @([[self getStringValueForElement:root name:@"fans"] integerValue]) ;
        setting.follow = @([[self getStringValueForElement:root name:@"follow"] integerValue]) ;
        setting.shield = @([[self getStringValueForElement:root name:@"shield"] integerValue]) ;
        setting.remarkName = [self getStringValueForElement:root name:@"remarkname"] ;
        setting.toFriend.userName = [self getStringValueForElement:root name:@"username"] ;
        QYDebugLog(@"setting.toFriend = %@",setting.toFriend) ;
    }
}

+ (void)initUser:(QY_user *)user withProfileXMLStr:(NSString *)xmlStr error:(NSError **)error {
    assert(user) ;
    QYDebugLog(@"init user xmlStr = %@",xmlStr) ;
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:error] ;
    
    if ( *error ) {
        [QYUtils alertError:*error] ;
    } else {
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        user.userName = [self getStringValueForElement:root name:@"username"] ;
        user.nickname = [self getStringValueForElement:root name:@"nickname"] ;
        user.gender = [self getStringValueForElement:root name:@"gender"] ;
        user.location = [self getStringValueForElement:root name:@"location"] ;
        
        //2008年06月21日 --> NSDate
        NSString *birthdayStr = [self getStringValueForElement:root name:@"birthday"] ;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy年MM月dd日"] ;
        NSDate *birthday = [formatter dateFromString:birthdayStr] ;
        user.birthday = birthday ;
        
        user.signature = [self getStringValueForElement:root name:@"signature"] ;
    }
}

#pragma mark - Core Data Model To Xml String

+ (NSString *)QY_friendSettingXMLString:(QY_friendSetting *)setting {
    GDataXMLElement *userTag = [GDataXMLNode elementWithName:@"user"] ;
    [userTag addAttribute:[GDataXMLNode attributeWithName:@"id" stringValue:setting.toFriend.userId]] ;
    
    NSArray *childs = @[@{@"username":setting.toFriend.userName},
                        @{@"nickname":setting.toFriend.nickname},
                        @{@"remarkname":setting.remarkName?:setting.toFriend.userName},
                        @{@"follow":[setting.follow stringValue]},
                        @{@"fans":[setting.fans stringValue]},
                        @{@"black":[setting.black stringValue]},
                        @{@"shield":[setting.shield stringValue]},
                        @{@"jpro":setting.toFriend.jpro?:@"qycam.com:50300"}] ;
    
    [childs enumerateObjectsUsingBlock:^(NSDictionary *dic , NSUInteger idx, BOOL *stop) {
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [userTag addChild:[GDataXMLNode elementWithName:key stringValue:value]] ;
        }] ;
    }] ;
    
    return [self xmlStrWithRootElement:userTag] ;
}

@end