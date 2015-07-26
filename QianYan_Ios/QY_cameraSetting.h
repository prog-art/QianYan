//
//  QY_cameraSetting.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_user;

@interface QY_cameraSetting : NSManagedObject

@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * toCameraId;
@property (nonatomic, retain) QY_user *owner;

@end
