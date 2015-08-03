//
//  QY_feed.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_AlertMessage, QY_attach, QY_comment, QY_user;

@interface QY_feed : NSManagedObject

@property (nonatomic, retain) NSNumber * type;//1视频,2图片,3文字
@property (nonatomic, retain) NSNumber * attachCount;
@property (nonatomic, retain) NSNumber * messageCount;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSNumber * diggCount;

@property (nonatomic, retain) NSString * feedId;
@property (nonatomic, retain) NSString * content ;

@property (nonatomic, retain) NSDate * modDate;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) NSSet *attaches;
@property (nonatomic, retain) NSSet *comments;

@property (nonatomic, retain) QY_user *owner;
@property (nonatomic, retain) NSSet *diggedByUsers;

@end

@interface QY_feed (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(QY_AlertMessage *)value;
- (void)removeMessagesObject:(QY_AlertMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

- (void)addAttachesObject:(QY_attach *)value;
- (void)removeAttachesObject:(QY_attach *)value;
- (void)addAttaches:(NSSet *)values;
- (void)removeAttaches:(NSSet *)values;

- (void)addCommentsObject:(QY_comment *)value;
- (void)removeCommentsObject:(QY_comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addDiggedByUsersObject:(QY_user *)value;
- (void)removeDiggedByUsersObject:(QY_user *)value;
- (void)addDiggedByUsers:(NSSet *)values;
- (void)removeDiggedByUsers:(NSSet *)values;

@end
