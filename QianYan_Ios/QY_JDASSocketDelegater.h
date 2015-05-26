//
//  QY_JDASSocketDelegater.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//
//  处理连接JDAS的Delegate类。在完成读取数据之后处理生成 JRM ip 和 port ，回调dataReadComplection。

#import <Foundation/Foundation.h>

#import <CocoaAsyncSocket/AsyncSocket.h>
#import "QY_Common.h"

#define JDAS_DATA_LENGTH 6

#import "QY_JDASSocketDelegaterDelegate.h"

@interface QY_JDASSocketDelegater : NSObject<AsyncSocketDelegate>

///**
// *  数据读取完成后，回调block
// */
//@property (nonatomic ,copy) QYHostPortBlock dataReadComplection ;

@property (nonatomic, weak) id<QY_JDASSocketDelegaterDelegate> delegate ;

- (instancetype)initWithDelegate:(id<QY_JDASSocketDelegaterDelegate>)delegate ;

@end
