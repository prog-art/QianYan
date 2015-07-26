//
//  QY_friendGroup.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_user;

@interface QY_friendGroup : NSManagedObject

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * iosGroupId;
@property (nonatomic, retain) NSDate * groupDate;
@property (nonatomic, retain) NSSet *containUsers;
@property (nonatomic, retain) QY_user *owner;
@end

@interface QY_friendGroup (CoreDataGeneratedAccessors)

- (void)addContainUsersObject:(QY_user *)value;
- (void)removeContainUsersObject:(QY_user *)value;
- (void)addContainUsers:(NSSet *)values;
- (void)removeContainUsers:(NSSet *)values;

@end
