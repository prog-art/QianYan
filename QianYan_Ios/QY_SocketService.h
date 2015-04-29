//  封装一层Socket操作
//  QY_SocketService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CocoaAsyncSocket/AsyncSocket.h>

#import "QY_Common.h"

@interface QY_SocketService : NSObject

+ (instancetype)shareInstance ;

/**
 *  [异步,Global]连接服务器
 *
 *  @param completion
 */
- (void)connectToHostCompletion:(QYBooleanBlock)completion ;

/**
 *  [同步]连接服务器
 *
 *  @param error
 *
 *  @return 连接成功与否
 */
- (BOOL)connectToHost:(NSError **)error ;

- (void)sendMessage ;

@end
