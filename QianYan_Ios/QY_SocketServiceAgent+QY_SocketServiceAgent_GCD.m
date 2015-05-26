//
//  QY_SocketServiceAgent+QY_SocketServiceAgent_GCD.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/4.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_SocketServiceAgent+QY_SocketServiceAgent_GCD.h"

@implementation QY_SocketServiceAgent (QY_SocketServiceAgent_GCD)

- (void)runAfterSecs:(float)secs block:(QYAgentBlock)block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_main_queue(), block) ;
}

- (void)runInMainQueue:(QYAgentBlock)queue {
    dispatch_async(dispatch_get_main_queue(), queue) ;
}

- (void)runInGlobalQueue:(QYAgentBlock)queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue) ;
}

@end