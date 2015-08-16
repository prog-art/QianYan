//
//  QY_friendGroup+Operations.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_friendGroup+Operations.h"

#import "QY_appDataCenter.h"
#import "QY_Common.h"

@implementation QY_friendGroup (Operations)

+ (QY_friendGroup *)insertGroupWithGroupId:(NSString *)groupId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iosGroupId = %@",groupId] ;
    
    QY_friendGroup *group = (id)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;
    if ( !group ) {
        group = [self group] ;
        group.iosGroupId = groupId ;
    }    
    return group ;
}

+ (QY_friendGroup *)group {
    QY_friendGroup *group = (id)[QY_appDataCenter insertObjectForName:NSStringFromClass(self)] ;
    return group ;
}

+ (QY_friendGroup *)groupWithName:(NSString *)groupName owner:(QY_user *)owner {
    if ( !groupName || !owner ) return nil ;
    QY_friendGroup *group = [self group] ;
    group.groupName = groupName ;
    group.owner = owner ;
    group.groupDate = [NSDate date] ;
    group.iosGroupId = [QYUtils uuid] ;
    return group ;
}

+ (NSString *)getXMLStrWithGroups:(NSSet *)groups {
    return [QY_XMLService getFriendGroupsXMLFromGroups:groups] ;
}

+ (NSSet *)getGroupsWithXMLStr:(NSString *)xmlStr {
    return [QY_XMLService getGroupsFromXMLStr:xmlStr] ;
}

@end
