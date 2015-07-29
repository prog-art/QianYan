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

- (NSString *)xmlStringForSaveAtJpro {
    return [QY_XMLService QY_friendSettingXMLString:self] ;
}

- (NSData *)xmlStringDataForTransportByHttp {
    return [[self xmlStringForSaveAtJpro] dataUsingEncoding:NSUTF8StringEncoding] ;
}

@end
