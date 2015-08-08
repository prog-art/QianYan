//
//  QY_comment.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_comment.h"
#import "QY_feed.h"

#import "QY_user.h"

#import "QY_appDataCenter.h"

@implementation QY_comment

@dynamic commentId;
@dynamic content;
@dynamic pubDate;
@dynamic userId;
@dynamic belong2Feed;

+ (QY_comment *)findCommentById:(NSString *)commentId {
    if ( !commentId ) return nil ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentId = %@",commentId] ;
    QY_comment *comment = (id)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;
    return comment ;
}

#pragma mark - AComment

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
#warning 记得改
    return [QY_user insertUserById:self.userId] ;
}

/**
 *  唯一表识
 */
- (NSString *)aUUId {
    return self.commentId ;
}

/**
 *  评论内容
 */
- (NSString *)aContent {
    return self.content ;
}

@end
