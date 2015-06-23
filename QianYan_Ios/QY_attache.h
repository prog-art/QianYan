//
//  QY_attache.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_feed;

@interface QY_attache : NSManagedObject

@property (nonatomic, retain) NSString * attach_id;
@property (nonatomic, retain) NSString * small;
@property (nonatomic, retain) NSString * src;
@property (nonatomic, retain) NSNumber * pub_date;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) QY_feed *feed;

+ (NSSet *)attacheWithDicArray:(NSArray *)dicArray ;

@end
