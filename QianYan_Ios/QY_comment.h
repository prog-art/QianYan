//
//  QY_comment.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_feed;

@interface QY_comment : NSManagedObject

@property (nonatomic, retain) NSString * commentId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) QY_feed *belong2Feed;

@end
