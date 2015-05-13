//
//  QY_JRMDataPacket.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QY_jclient_jrm_protocol_Marco.h"

@interface QY_JRMDataPacket : NSObject

/**
 *  数据长度
 */
@property (assign) NSUInteger length ;

/**
 *  cmd代码 enum JOSEPH_COMMAND ;
 */
@property (assign) JOSEPH_COMMAND cmd ;

/**
 *  值数组
 */
@property (nonatomic,readonly) NSArray *values ;

- (void)addValues:(id)obj ;

@end
