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

+ (NSString *)getUserProfileXML:(id<user2ProfileXMLInterface>)user {
    GDataXMLElement *userTag = [GDataXMLNode elementWithName:@"user"] ;
    {
        GDataXMLElement *userIdAttr = [GDataXMLNode attributeWithName:@"id" stringValue:[user userId]] ;
        [userTag addAttribute:userIdAttr] ;
        
        GDataXMLElement *usernameTag = [GDataXMLNode elementWithName:@"username" stringValue:[user username]] ;
        [userTag addChild:usernameTag] ;
        
        GDataXMLElement *genderTag = [GDataXMLElement elementWithName:@"gender" stringValue:[user gender]] ;
        [userTag addChild:genderTag] ;
        
        GDataXMLElement *locationTag = [GDataXMLElement elementWithName:@"location" stringValue:[user location]] ;
        [userTag addChild:locationTag] ;
        
        NSString *birthdayStr ;
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy年MM月dd日"] ;
            birthdayStr = [formatter stringFromDate:[user birthday]] ;
        }
        
        GDataXMLElement *birthdayTag = [GDataXMLElement elementWithName:@"birthday" stringValue:birthdayStr] ;
        [userTag addChild:birthdayTag] ;
        
        GDataXMLElement *signTag = [GDataXMLElement elementWithName:@"signature" stringValue:[user signature]] ;
        [userTag addChild:signTag] ;
    }
    
    return [self xmlStrWithRootElement:userTag] ;
}

+ (NSString *)getUserIdXML:(id<user2userIdXMLInterface>)user {
    GDataXMLElement *userTag = [GDataXMLNode elementWithName:@"user"] ;
    {
        GDataXMLElement *userIdAttr = [GDataXMLNode attributeWithName:@"id" stringValue:[user userId]] ;
        [userTag addAttribute:userIdAttr] ;
        
        GDataXMLElement *usernameTag = [GDataXMLNode elementWithName:@"username" stringValue:[user username]] ;
        [userTag addChild:usernameTag] ;
        
        GDataXMLElement *nicknameTag = [GDataXMLElement elementWithName:@"nickname" stringValue:[user nickname]] ;
        [userTag addChild:nicknameTag] ;
        
        GDataXMLElement *remarknameTag = [GDataXMLElement elementWithName:@"remarkname" stringValue:[user remarkname]] ;
        [userTag addChild:remarknameTag] ;
        
        GDataXMLElement *followTag = [GDataXMLElement elementWithName:@"follow" stringValue:QY_STR([user follow])] ;
        [userTag addChild:followTag] ;
        
        GDataXMLElement *fansTag = [GDataXMLElement elementWithName:@"fans" stringValue:QY_STR([user fans])] ;
        [userTag addChild:fansTag] ;
        
        GDataXMLElement *blackTag = [GDataXMLElement elementWithName:@"black" stringValue:QY_STR([user black])] ;
        [userTag addChild:blackTag] ;
        
        GDataXMLElement *shieldTag = [GDataXMLElement elementWithName:@"shield" stringValue:QY_STR([user shield])] ;
        [userTag addChild:shieldTag] ;
        
        GDataXMLElement *jproTag = [GDataXMLElement elementWithName:@"jpro" stringValue:[user jpro]] ;
        [userTag addChild:jproTag] ;
        
    }
    
    return [self xmlStrWithRootElement:userTag] ;
}

#pragma mark - xml Str --> obj 

//+ (id<user2ProfileXMLInterface>)getUserFromProfileXML:(NSString *)xmlStr {
//    NSError *error ;
//    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:&error] ;
//    
//    if ( error ) {
//        [QYUtils alertError:error] ;
//        return nil ;
//    } else {
//        QYUser *user ;
//        
//        GDataXMLElement *root = [xmlDoc rootElement] ;
//        
//        NSString *userId = [[root attributeForName:@"id"] stringValue] ;
//        NSString *username = [self getStringValueForElement:root name:@"username"] ;
//        NSString *gender = [self getStringValueForElement:root name:@"gender"] ;
//        NSString *location = [self getStringValueForElement:root name:@"location"] ;
//        //2008年06月21日 --> NSDate
//        NSString *birthdayStr = [self getStringValueForElement:root name:@"birthday"] ;
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//        [formatter setDateFormat:@"yyyy年MM月dd日"] ;
//        NSDate *birthday = [formatter dateFromString:birthdayStr] ;
//        
//        NSString *signature = [self getStringValueForElement:root name:@"signature"] ;
//        
//        user = [QYUser instanceWithUserId:userId
//                                 username:username
//                                   gender:gender
//                                 location:location
//                                 birthday:birthday
//                                signature:signature] ;
//        
//        return user ;
//    }
//}

+ (id<user2userIdXMLInterface>)getUserFromUserIdXML:(NSString *)xmlStr {
    NSError *error ;
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:&error] ;
    
    if ( error ) {
        [QYUtils alertError:error] ;
        return nil ;
    } else {
        QYUser *user ;
        
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        NSString *userId = [[root attributeForName:@"id"] stringValue] ;
        NSString *username = [self getStringValueForElement:root name:@"username"] ;
        NSString *nickname = [self getStringValueForElement:root name:@"nickname"] ;
        NSString *remarkname = [self getStringValueForElement:root name:@"remarkname"] ;
        
        NSString *followStr = [self getStringValueForElement:root name:@"follow"] ;
        NSInteger follow = [followStr integerValue] ;
        
        NSString *fansStr = [self getStringValueForElement:root name:@"fans"] ;
        NSInteger fans = [fansStr integerValue] ;
        
        NSString *blackStr = [self getStringValueForElement:root name:@"black"] ;
        NSInteger black = [blackStr integerValue] ;
        
        NSString *shieldStr = [self getStringValueForElement:root name:@"shield"] ;
        NSInteger shield = [shieldStr integerValue] ;
        
        NSString *jpro = [self getStringValueForElement:root name:@"jpro"] ;
        
        
        user = [QYUser instanceWithUserId:userId
                                 username:username
                                 nickname:nickname
                               remarkname:remarkname
                                   follow:follow
                                     fans:fans
                                    black:black
                                   shield:shield
                                     jpro:jpro] ;
        
        return user ;
    }
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
    return nil ;
}


+ (QY_friendSetting *)getSesttingFromIdXML:(NSString *)xmlStr {
    NSError *error ;
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:&error] ;
    
    if ( error ) {
        [QYUtils alertError:error] ;
        return nil ;
    } else {
        GDataXMLElement *root = [xmlDoc rootElement] ;
        
        NSString *ownerId = [QYUser currentUser].userId ;
        
        NSString *userId = [[root attributeForName:@"id"] stringValue] ;

        QY_friendSetting *setting = [QY_friendSetting setting] ;
        
        setting.owner = [QY_appDataCenter userWithId:ownerId] ;
        setting.toFriend = [QY_appDataCenter userWithId:userId] ;
        //add relationship
        [setting.owner addFriendsObject:setting.toFriend] ;
        
        setting.toFriend.jpro = [self getStringValueForElement:root name:@"jpro"] ;

        setting.black = @([[self getStringValueForElement:root name:@"black"] integerValue]);
        setting.fans = @([[self getStringValueForElement:root name:@"fans"] integerValue]) ;
        setting.follow = @([[self getStringValueForElement:root name:@"follow"] integerValue]) ;
        setting.shield = @([[self getStringValueForElement:root name:@"shield"] integerValue]) ;
        setting.remarkName = [self getStringValueForElement:root name:@"remarkname"] ;
        
        setting.toFriend.userName = [self getStringValueForElement:root name:@"username"] ;
        
        NSError *savingError ;
        [QY_appDataCenter saveObject:nil error:&savingError] ;
        if ( savingError ) {
            QYDebugLog(@"保存失败 error = %@",savingError) ;
            [QYUtils alertError:error] ;
        } else {
            QYDebugLog(@"保存成功 setting = %@",setting) ;
        }
        
        return setting ;
    }
}

+ (QY_user *)getUserFromProfileXML:(NSString *)xmlStr {
    NSError *error ;
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlStr encoding:NSUTF8StringEncoding error:&error] ;
    
    if ( error ) {
        [QYUtils alertError:error] ;
        return nil ;
    } else {
        GDataXMLElement *root = [xmlDoc rootElement] ;
        QY_user *user = [QY_appDataCenter userWithId:[[root attributeForName:@"id"] stringValue]] ;

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

        return user ;
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