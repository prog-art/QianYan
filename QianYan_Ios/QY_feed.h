//
//  QY_feed.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_AlertMessage, QY_attache, QY_comment;

@interface QY_feed : NSManagedObject

@property (nonatomic, retain) NSNumber * attach_count;
@property (nonatomic, retain) NSNumber * comment_count;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * digg_count;
@property (nonatomic, retain) NSNumber * message_count;
@property (nonatomic, retain) NSString * feed_id;
@property (nonatomic, retain) NSNumber * pub_date;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSNumber * mod_date;
@property (nonatomic, retain) NSNumber * digg;
@property (nonatomic, retain) NSSet *attachs;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *messages;

- (instancetype)initWithFeedDic:(NSDictionary *)feedDic ;

@end

@interface QY_feed (CoreDataGeneratedAccessors)

- (void)addAttachsObject:(QY_attache *)value;
- (void)removeAttachsObject:(QY_attache *)value;
- (void)addAttachs:(NSSet *)values;
- (void)removeAttachs:(NSSet *)values;

- (void)addCommentsObject:(QY_comment *)value;
- (void)removeCommentsObject:(QY_comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addMessagesObject:(QY_AlertMessage *)value;
- (void)removeMessagesObject:(QY_AlertMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
