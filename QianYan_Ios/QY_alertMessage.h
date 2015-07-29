//
//  QY_alertMessage.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_feed;

@interface QY_alertMessage : NSManagedObject

@property (nonatomic, retain) NSString * cameraId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSSet *shared2Feeds;
@end

@interface QY_alertMessage (CoreDataGeneratedAccessors)

- (void)addShared2FeedsObject:(QY_feed *)value;
- (void)removeShared2FeedsObject:(QY_feed *)value;
- (void)addShared2Feeds:(NSSet *)values;
- (void)removeShared2Feeds:(NSSet *)values;

@end
