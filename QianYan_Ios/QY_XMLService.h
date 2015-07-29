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

/**
 *  需求:
 *     1.提供XML文本构建的API
 *     2.提供XML文本解析的API
 */
@interface QY_XMLService : NSObject

#pragma mark - Obj --> xml Str

//ok
+ (NSString *)getUserProfileXML:(id<user2ProfileXMLInterface>)user ;

//ok
+ (NSString *)getUserIdXML:(id<user2userIdXMLInterface>)user ;


#pragma mark - xml Str --> obj 

////ok
//+ (id<user2ProfileXMLInterface>)getUserFromProfileXML:(NSString *)xmlStr ;

//ok
+ (id<user2userIdXMLInterface>)getUserFromUserIdXML:(NSString *)xmlStr ;

#pragma mark - Core Data Model

+ (QY_camera *)getCameraFromIdXML:(NSString *)xmlStr ;

+ (QY_camera *)getCameraFromProfileXML:(NSString *)xmlStr ;

+ (QY_friendSetting *)getSesttingFromIdXML:(NSString *)xmlStr ;

+ (QY_user *)getUserFromProfileXML:(NSString *)xmlStr ;

#pragma mark - Core Data Model To Xml String 

+ (NSString *)QY_friendSettingXMLString:(QY_friendSetting *)setting ;

@end
