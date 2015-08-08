//
//  QY_attache.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "QYSocialDataModelInterface.h"

@class QY_feed;

@interface QY_attach : NSManagedObject<AAttach>

@property (nonatomic, retain) NSString * attachId;
@property (nonatomic, retain) NSString * small;
@property (nonatomic, retain) NSString * src;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) QY_feed *belong2Feed;

@end
