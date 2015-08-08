//
//  QY_attache.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_attach.h"
#import "QY_feed.h"


@implementation QY_attach

@dynamic attachId;
@dynamic small;
@dynamic src;
@dynamic type;
@dynamic userId;
@dynamic pubDate;
@dynamic belong2Feed;

#pragma mark - AAttach

/**
 *  日期[排序key]
 */
- (NSDate *)aPubDate {
    return self.pubDate ;
}

/**
 *  唯一标识
 */
- (NSString *)aUUID {
    return self.attachId ;
}

/**
 *  类型
 */
- (NSString *)aType {
    return self.type ;
}

/**
 *  地址
 */
- (NSURL *)aSource {
    return [NSURL URLWithString:self.src] ;
}

@end
