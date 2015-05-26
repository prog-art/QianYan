//
//  JRMDataFormatUtils.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QY_jclient_jrm_protocol_Marco.h"

@interface JRMDataFormatUtils : NSObject

//Len 专用
+ (NSData *)formatLenData:(NSUInteger)len ;

//Cmd 专用
+ (NSData *)formatCmdData:(JOSEPH_COMMAND)cmd ;

//用户名 密码 等
+ (NSData *)formatStringValueData:(NSString *)string toLen:(NSUInteger)dataLen ;

//头像图片大小等
+ (NSData *)formatNumberValueData:(NSNumber *)number toLen:(NSUInteger)dataLen ;

//头像图片大小等
+ (NSData *)formatIntegerValueData:(NSInteger)integet toLen:(NSUInteger)dataLen ;

@end