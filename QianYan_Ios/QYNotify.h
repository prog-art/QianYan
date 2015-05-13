//  ［单例］通知中心，快速注册NSNotificationCent的Observer
//  QYNotify.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QY_NOTIFICATION_JDAS_GET_IPandPORT @"QY_NOTIFICATION_JDAS_GET_IPandPORT"

@interface QYNotify : NSObject

+(instancetype)shareInstance ;

#pragma mark - JDAS get JRM IP and Port Right

-(void)addJDASObserver:(id)target selector:(SEL)selector ;

-(void)removeJDASObserver:(id)target ;

-(void)postJDASNotification:(NSDictionary *)info ;

@end
