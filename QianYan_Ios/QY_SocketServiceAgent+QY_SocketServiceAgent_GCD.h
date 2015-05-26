//
//  QY_SocketServiceAgent+QY_SocketServiceAgent_GCD.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/4.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_SocketServiceAgent.h"

typedef void(^QYAgentBlock)() ;

@interface QY_SocketServiceAgent (QY_SocketServiceAgent_GCD)

- (void)runAfterSecs:(float)secs block:(QYAgentBlock)block ;

- (void)runInMainQueue:(QYAgentBlock)queue ;

- (void)runInGlobalQueue:(QYAgentBlock)queue ;

@end