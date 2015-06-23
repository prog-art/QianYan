//
//  QY_JDASGCDSocketDelegater.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "QY_Block_Define.h"

@interface QY_JDASGCDSocketDelegater : NSObject<GCDAsyncSocketDelegate>

#pragma mark - 寻址

- (void)getJRMIPandJRMPORTWithComplection:(QYInfoBlock)complection ;

@end
