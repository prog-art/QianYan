//
//  QY_friendSetting.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_user;

@interface QY_friendSetting : NSManagedObject

@property (nonatomic, retain) NSNumber * black;
@property (nonatomic, retain) NSNumber * fans;
@property (nonatomic, retain) NSNumber * follow;
@property (nonatomic, retain) NSNumber * shield;
@property (nonatomic, retain) NSString * remarkName;
@property (nonatomic, retain) NSString * toFriendId;
@property (nonatomic, retain) QY_user *owner;

@end
