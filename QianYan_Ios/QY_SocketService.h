//
//  QY_SocketService_v2.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_JRMAPIDescriptor.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "QY_Block_Define.h"

extern NSString *const kNotificationName_finishDataReceive ;

#define RESPONSE_KEY @"RESPONSE_KEK"
#define ERROR_KEY @"ERROR_KEY"

#import "QY_SocketServiceDelegate.h"

/**
 *  基于QY_JRMAPIDescriptor类，对发送数据，接受数据，作处理。
 *  处于组件第二层，底层是 CocoaAsyncSocket/GCDAsyncSocket.h
 *  1.作为主控存在，基于QY_JRMAPIDescriptor进行收发数据，解析数据
 *  2.保存并管理有程序后台连接状态，工作时重连服务器。
 *  3.实时监听网络状况。
 */
@interface QY_SocketService : NSObject

/**
 *  获取单例
 *
 *  @return
 */
+ (instancetype)shareInstance ;

#pragma mark - 寻址

- (void)getJRMIPandJRMPORTWithComplection:(QYInfoBlock)complection ;

/**
 *  开始工作，并且上锁。
 *
 *  @param APIDescriptor
 */
- (void)startWithAPIDescriptor:(QY_JRMAPIDescriptor *)APIDescriptor
                   Complection:(QYJRMResponseBlock)complection ;


/**
 *  当前处理的Descriptor
 */
@property (nonatomic,readonly) QY_JRMAPIDescriptor *currentDescriptor ;

/**
 *  状态，刚启动（jrm未获得），jrm已获得（jrm未连接），jrm已连接（未设备登录），jrm已经设备登录（未用户登录），jrm用户已登录（用户已经登录，能够操作了）
 */
@property (nonatomic) NSString *state ;

@property (weak) id<QY_SocketServiceDelegate> delegate ;

@end

