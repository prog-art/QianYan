//
//  QY_XMLService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QYUser.h"

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

//ok
+ (id<user2ProfileXMLInterface>)getUserFromProfileXML:(NSString *)xmlStr ;

//ok
+ (id<user2userIdXMLInterface>)getUserFromUserIdXML:(NSString *)xmlStr ;

@end
