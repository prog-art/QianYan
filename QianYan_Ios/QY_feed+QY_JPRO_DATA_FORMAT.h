//
//  QY_feed+QY_JPRO_DATA_FORMAT.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_feed.h"

#import "QY_Block_Define.h"

@interface QY_feed (QY_JPRO_DATA_FORMAT)

+ (QY_feed *)feedWithId:(NSString *)feedId ;

- (void)initWithFeedDic:(NSDictionary *)feedDic ;

#pragma mark - operation

+ (void)fetchFeedWithId:(NSString *)feedId complection:(QYObjectBlock)complection ;

- (void)addComment:(NSString *)content complection:(QYResultBlock)complection ;

#warning 接口设计有误
- (void)removeComment:(QY_comment *)comment user:(QY_user *)user complection:(QYResultBlock)complection ;

@end
