//
//  QY_contactUtils.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "QY_contactUtilsDelegate.h"

@interface QY_contactUtils : NSObject

@property (weak) id<QY_contactUtilsDelegate> delegate ;

- (instancetype)initWithDelegate:(id<QY_contactUtilsDelegate>)delegate ;

/**
 *  获取Contacts，结果用delegate接收
 */
- (void)getContacts ;

#pragma mark - 发送短信

/**
 *  发送短信给目标列表
 *
 *  @param content    短信内容
 *  @param recipients 收信人列表
 *  @param sender     当前界面，跳转用。
 */
- (void)sendSMSmessage:(NSString *)content ToTels:(NSArray *)recipients sender:(UIViewController *)sender ;

/**
 *  发送消息给目标电话
 *
 *  @param content   消息内容
 *  @param telephone 目标电话
 *  @param sender    当前界面，跳转用。
 */
- (void)sendSMSmessage:(NSString *)content ToTel:(NSString *)telephone sender:(UIViewController *)sender ;

@end
