//
//  QY_feed.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_feed.h"
#import "QY_AlertMessage.h"
#import "QY_attach.h"
#import "QY_comment.h"
#import "QY_user.h"

@implementation QY_feed

@dynamic type;
@dynamic attachCount;
@dynamic messageCount;
@dynamic commentCount;
@dynamic diggCount;
@dynamic feedId;
@dynamic modDate;
@dynamic pubDate;
@dynamic content;
@dynamic messages;
@dynamic attaches;
@dynamic owner;
@dynamic comments;
@dynamic diggedByUsers;

#pragma mark - AFeed

/**
 *  发布时间
 */
- (NSDate *)aPubDate {
    return self.pubDate ;
}

/**
 *  谁操作的
 */
- (id<AUser>)aOwner {
    return (id<AUser>)self.owner ;
}

/**
 *  唯一表识
 */
- (NSString *)aUUId {
    return self.feedId ;
}

/**
 *  说说内容
 */
- (NSString *)aContent {
    return self.content ;
}

/**
 *  说说附件，图片或视频。id<Attach>
 */
- (NSArray *)aAttaches {
    return [self.attaches allObjects] ;
}

/**
 *  类型[1-3],1视频,2图片,3文字
 */
- (NSInteger)aType {
    return [self.type integerValue] ;
}

/**
 *  是否被当前用户点赞了
 */
- (BOOL)aDiggedByCurrentUser {
    return [self.diggedByUsers containsObject:self.owner] ;
}

/**
 *  被点赞次数
 */
- (NSInteger)aDiggCount {
    return [self.diggCount integerValue] ;
}

/**
 *  评论
 */
- (NSArray *)aComments {
    return [self.comments allObjects] ;
}

@end
