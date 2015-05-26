//
//  QY_JRMSocketDelegater.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CocoaAsyncSocket/AsyncSocket.h>
#import "QY_Common.h"
#import "QY_SocketService.h"

@interface QY_JRMSocketDelegater : NSObject<AsyncSocketDelegate>

@property (weak) id<QY_SocketServiceDelegate> delegate ;

- (instancetype)initWithDelegate:(id<QY_SocketServiceDelegate>)delegate ;

@end
