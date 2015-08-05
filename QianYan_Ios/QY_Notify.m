//
//  QY_Notify.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/4.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_Notify.h"

#define kNSNotificationCenter [NSNotificationCenter defaultCenter]

#define kNOTIFICATION_FEED_UPDATED   @"NOTIFICATION_FEED_UPDATED"
#define kNOTIFICATION_FRIEND_UPDATED @"NOTIFICATION_FEED_UPDATED"
#define kNOTIFICATION_AVATAR_UPDATED @"NOTIFICATION_AVATAR_UPDATED"

@interface QY_Notify ()

@property (weak) NSNotificationCenter* center ;

@end

@implementation QY_Notify

+ (instancetype)shareInstance {
    static QY_Notify *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QY_Notify alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        _center = kNSNotificationCenter ;
    }
    return self ;
}

#pragma mark - Feed

- (void)addFeedObserver:(id)target selector:(SEL)selector {
    [_center addObserver:target selector:selector name:kNOTIFICATION_FEED_UPDATED object:nil] ;
}

- (void)removeFeedObserver:(id)target {
    [_center removeObserver:target name:kNOTIFICATION_FEED_UPDATED object:nil] ;
}

- (void)postFeedNotifyWithId:(NSString *)feedId {
    [_center postNotificationName:kNOTIFICATION_FEED_UPDATED object:feedId] ;
}

#pragma mark - Friend

- (void)addFriendObserver:(id)target selector:(SEL)selector {
    [_center addObserver:target selector:selector name:kNOTIFICATION_FRIEND_UPDATED object:nil] ;
}

- (void)removeFriendObserver:(id)target {
    [_center removeObserver:target name:kNOTIFICATION_FRIEND_UPDATED object:nil] ;
}

- (void)postFriendNotify {
    [_center postNotificationName:kNOTIFICATION_FRIEND_UPDATED object:nil] ;
}

#pragma mark - Avatar

- (void)addAvatarObserver:(id)target selector:(SEL)selector {
    [_center addObserver:target selector:selector name:kNOTIFICATION_AVATAR_UPDATED object:nil] ;
}

- (void)removeAvatarObserver:(id)target {
    [_center removeObserver:target name:kNOTIFICATION_AVATAR_UPDATED object:nil] ;
}

- (void)postAvatarNotify {
    [_center postNotificationName:kNOTIFICATION_AVATAR_UPDATED object:nil] ;
}

@end
