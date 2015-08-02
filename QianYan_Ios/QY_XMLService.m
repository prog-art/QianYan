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
//
//+ (NSString *)getUserProfileXML:(id<user2ProfileXMLInterface>)user {
//    GDataXMLElement *userTag = [GDataXMLNode elementWithName:@"user"] ;
//    {
//        GDataXMLElement *userIdAttr = [GDataXMLNode attributeWithName:@"id" stringValue:[user userId]] ;
//        [userTag addAttribute:userIdAttr] ;
//        
//        GDataXMLElement *usernameTag = [GDataXMLNode elementWithName:@"username" stringValue:[user username]] ;
//        [userTag addChild:usernameTag] ;
//        
//        GDataXMLElement *genderTag = [GDataXMLElement elementWithName:@"gender" stringValue:[user gender]] ;
//        [userTag addChild:genderTag] ;
//        
//        GDataXMLElement *locationTag = [GDataXMLElement elementWithName:@"location" stringValue:[user location]] ;
//        [userTag addChild:locationTag] ;
//        
//        NSString *birthdayStr ;
//        {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//            [formatter setDateFormat:@"yyyy年MM月dd日"] ;
//            birthdayStr = [formatter stringFromDate:[user birthday]] ;
//        }
//        
//        GDataXMLElement *birthdayTag = [GDataXMLElement elementWithName:@"birthday" stringValue:birthdayStr] ;
//        [userTag addChild:birthdayTag] ;
//        
//        GDataXMLElement *signTag = [GDataXMLElement elementWithName:@"signature" stringValue:[user signature]] ;
//        [userTag addChild:signTag] ;
//    }
//    
//    return [self xmlStrWithRootElement:userTag] ;
//}
//
//+ (NSString *)getUserIdXML:(id<user2userIdXMLInterface>)user {
//    GDataXMLElement *userTag = [GDataXMLNode elementWithName:@"user"] ;
//    {
//        GDataXMLElement *userIdAttr = [GDataXMLNode attributeWithName:@"id" stringValue:[user userId]] ;
//        [userTag addAttribute:userIdAttr] ;
//        
//        GDataXMLElement *usernameTag = [GDataXMLNode elementWithName:@"username" stringValue:[user username]] ;
//        [userTag addChild:usernameTag] ;
//        
//        GDataXMLElement *nicknameTag = [GDataXMLElement elementWithName:@"nickname" stringValue:[user nickname]] ;
//        [userTag addChild:nicknameTag] ;
//        
//        GDataXMLElement *remarknameTag = [GDataXMLElement elementWithName:@"remarkname" stringValue:[user remarkname]] ;
//        [userTag addChild:remarknameTag] ;
//        
//        GDataXMLElement *followTag = [GDataXMLElement elementWithName:@"follow" stringValue:QY_STR([user follow])] ;
//        [userTag addChild:followTag] ;
//        
//        GDataXMLElement *fansTag = [GDataXMLElement elementWithName:@"fans" stringValue:QY_STR([user fans])] ;
//        [userTag addChild:fansTag] ;
//        
//        GDataXMLElement *blackTag = [GDataXMLElement elementWithName:@"black" stringValue:QY_STR([user black])] ;
//        [userTag addChild:blackTag] ;
//        
//        GDataXMLElement *shieldTag = [GDataXMLElement elementWithName:@"shield" stringValue:QY_STR([user shield])] ;
//        [userTag addChild:shieldTag] ;
//        
//        GDataXMLElement *jproTag = [GDataXMLElement elementWithName:@"jpro" stringValue:[user jpro]] ;
//        [userTag addChild:jproTag] ;
//        
//    }
//    
//    return [self xmlStrWithRootElement:userTag] ;
//}

#pragma mark - xml Str --> obj

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


+ (QY_camera *)getCameraFromIdXML:(NSString *)xmlStr {
    NSError *error ;
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:&error] ;
    
    if ( error ) {
        [QYUtils alertError:error] ;
        return nil ;
    } else {
        QY_camera *camera = [QY_camera camera] ;
        
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        camera.cameraId = [[root attributeForName:@"id"] stringValue] ;
        NSString *ownerId = [self getStringValueForElement:root name:@"owner"] ;
        camera.jpro = [self getStringValueForElement:root name:@"jpro"] ;
        
        [camera setOwner:[QY_appDataCenter userWithId:ownerId]] ;
        
        NSError *savingError ;
        [QY_appDataCenter saveObject:camera error:&savingError] ;
        
        if ( savingError ) {
            QYDebugLog(@"保存失败 error = %@",savingError) ;
            [QYUtils alertError:error] ;
        } else {
            QYDebugLog(@"保存成功 camera = %@",camera) ;
        }
        
        return camera ;
    }
}

+ (QY_camera *)getCameraFromProfileXML:(NSString *)xmlStr {
#warning 没写
    return nil ;
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
    }
}

+ (void)initUser:(QY_user *)user withProfileXMLStr:(NSString *)xmlStr error:(NSError **)error {
    assert(user) ;
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:error] ;
    
    if ( error ) {
        [QYUtils alertError:*error] ;
    } else {
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        user.userName = [self getStringValueForElement:root name:@"username"] ;
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
    [userTag addAttribute:[GDataXMLNode attributeWithName:@"id" stringValue:setting.owner.userId]] ;
    
#warning nickname界面没有，暂时用userName代替。
    NSArray *childs = @[@{@"username":setting.owner.userName},
                        @{@"nickname":setting.owner.userName},
                        @{@"remarkname":setting.remarkName?:setting.owner.userName},
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