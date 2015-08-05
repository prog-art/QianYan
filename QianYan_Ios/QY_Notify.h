//
//  QY_Notify.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/4.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QY_Notify : NSObject

+ (instancetype)shareInstance ;

#pragma mark - Feed

- (void)addFeedObserver:(id)target selector:(SEL)selector ;

- (void)removeFeedObserver:(id)target ;

- (void)postFeedNotifyWithId:(NSString *)feedId ;

#pragma mark - Friend

- (void)addFriendObserver:(id)target selector:(SEL)selector ;

- (void)removeFriendObserver:(id)target ;

- (void)postFriendNotify ;

#pragma mark - Avatar 

- (void)addAvatarObserver:(id)target selector:(SEL)selector ;

- (void)removeAvatarObserver:(id)target ;

- (void)postAvatarNotify ;

@end
