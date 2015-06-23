//
//  QY_JRMGCDSocketDelegater_v2.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/24.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "QY_Block_Define.h"

/**
 *  1. 负责处理GCDAsyncSocketDelegate的回调
 *  2. 这个类按照JRM协议中商定的方式，读取数据 
 *      1. data len
 *      2. all data ( cmd && values )
 *      3. if needed read append data
 */
@interface QY_JRMGCDSocketDelegater : NSObject<GCDAsyncSocketDelegate>

/**
 *  某些消息需要通知给父亲
 */
@property (weak) id<GCDAsyncSocketDelegate> superDelegate ;

/**
 *  唯一要处理的连接jrm服务器的socket
 */
@property (weak) GCDAsyncSocket *jrmSocket ;

- (void)connectToJRMHost:(NSString *)host
                    Port:(NSUInteger)port
             Complection:(QYResultBlock)complection ;

- (void)deviceLogin2JRMWithComplection:(QYResultBlock)complection ;

- (void)userRelogin2JRMWithUsername:(NSString *)username Password:(NSString *)password Complection:(QYResultBlock)complection ;


@end