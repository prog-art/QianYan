//  用于生成满足jclient jrm交互协议的工厂类
//
//  QY_MessageFactor.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_jclient_jrm_protocol_Marco.h"

/**
 *  协议版本 <<JRM通信协议(2015-4-29 10.41.11 3120)>>
 */
@interface QY_JRMDataPacketFactor : NSObject

/**
 *  通过统一方式获取参数，方法内部分路。
 *
 *  @param operationType operationType
 *  @param parameters    参数.
 *  @param count         参数个数，用于验证。
 *
 *  @return
 */
+ (NSData *)getDataWithOperationType:(JRM_REQUEST_OPERATION_TYPE)operationType Parameters:(NSDictionary *)parameters ParameterCount:(NSInteger)count ;

@end