//
//  QY_XMLService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QYUser.h"

#import "QY_CoreDataModels.h"
#import "QYConstants.h"

/**
 *  需求:
 *     1.提供XML文本构建的API
 *     2.提供XML文本解析的API
 */
@interface QY_XMLService : NSObject

#pragma mark - Obj --> xml Str

+ (NSString *)getProfileXMLFromUser:(QY_user *)user ;

+ (NSString *)getFriendGroupsXMLFromGroups:(NSSet *)groups ;

#pragma mark - xml Str --> obj 

+ (NSSet *)getGroupsFromXMLStr:(NSString *)xmlStr ;

#pragma mark - Core Data Model

+ (void)initCameraSetting:(QY_cameraSetting *)setting withCameraIdXMLStr:(NSString *)xmlStr error:(NSError **)error ;

+ (void)initCamera:(QY_camera *)camera withProfileXMLStr:(NSString *)xmlStr error:(NSError **)error ;

+ (void)initFriendSetting:(QY_friendSetting *)setting withFriendIdXMLStr:(NSString *)xmlStr error:(NSError **)error ;

+ (void)initUser:(QY_user *)user withProfileXMLStr:(NSString *)xmlStr error:(NSError **)error ;

#pragma mark - Core Data Model To Xml String 

+ (NSString *)QY_friendSettingXMLString:(QY_friendSetting *)setting ;

@end
