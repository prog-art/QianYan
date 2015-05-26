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

+ (id<user2ProfileXMLInterface>)getUserFromProfileXML:(NSString *)xmlStr {
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
        NSString *gender = [self getStringValueForElement:root name:@"gender"] ;
        NSString *location = [self getStringValueForElement:root name:@"location"] ;
        //2008年06月21日 --> NSDate
        NSString *birthdayStr = [self getStringValueForElement:root name:@"birthday"] ;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy年MM月dd日"] ;
        NSDate *birthday = [formatter dateFromString:birthdayStr] ;
        
        NSString *signature = [self getStringValueForElement:root name:@"signature"] ;
        
        user = [QYUser instanceWithUserId:userId
                                 username:username
                                   gender:gender
                                 location:location
                                 birthday:birthday
                                signature:signature] ;
        
        return user ;
    }
}

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
    return [[[root elementsForName:name] lastObject] stringValue] ;
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

@end