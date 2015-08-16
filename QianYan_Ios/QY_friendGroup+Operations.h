//
//  QY_friendGroup+Operations.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_friendGroup.h"

@interface QY_friendGroup (Operations)

+ (QY_friendGroup *)insertGroupWithGroupId:(NSString *)groupId ;

+ (QY_friendGroup *)groupWithName:(NSString *)groupName owner:(QY_user *)owner ;

+ (NSString *)getXMLStrWithGroups:(NSSet *)groups ;

+ (NSSet *)getGroupsWithXMLStr:(NSString *)xmlStr ;

@end
