//
//  QY_JRMDataPharser.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_JRMDataPacket.h"
#import "QY_jclient_jrm_protocol_Marco.h"

extern NSUInteger api211SuccessDataLen ;
extern NSUInteger api251SuccessDataLen ;
extern NSUInteger api251FailedDataLen ;
extern NSUInteger api252FullDataLen ;

/**
 *  协议版本 <<JRM通信协议(2015-4-29 10.41.11 3120)>>
 */
@interface QY_JRMDataPharser : NSObject

/**
 *  根据 JRM_REQUEST_OPERATION_TYPE tag 来确认解析data的方法。
 *
 *  @param data 服务器返回data
 *  @param tag  发起请求时候的操作类型，根据操作类型选择解析器(方法),操作类型为文档编号 例2.1.1 设备登录 -> (long)211
 *
 *  @return 解析好的数据包 QY_JRMDataPacket,数据不完整时返回nil
 */
+(QY_JRMDataPacket *)pharseDataWithData:(NSData *)data Tag:(JRM_REQUEST_OPERATION_TYPE)tag ;

#pragma mark -- test

#warning 测试用例中使用的方法，之后请隐藏
+ (NSUInteger)getLen:(NSData *)data ;

+ (JOSEPH_COMMAND)getCmd:(NSData *)data ;

+ (NSString *)getStringValue:(NSData *)data range:(NSRange)range ;

+ (NSInteger)getIngeterValue:(NSData *)data range:(NSRange)range ;

@end
