//
//  NSData+QY_dataFormat.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (QY_dataFormat)

/**
 *  为数据前填充0x00
 *  例:<3212> , 4 --> <0000 3212>
 *
 *  @param data 被填充的数据
 *  @param len  目标数据长度
 *
 *  @return 填充好的数据
 */
+ (NSData *)QY_FillZero:(NSData *)data ToLen:(NSUInteger)len ;

/**
 *  为数据后填充0x00
 *
 *  @param data 被填充的数据
 *  @param len  目标数据长度
 *
 *  @return 填充好的数据
 */
+ (NSData *)QY_FillZeroAtBack:(NSData *)data ToLen:(NSUInteger)len ;

/**
 *  去掉数据前填充0x00
 *
 *  @param data 目标数据
 *
 *  @return 去掉前填充0x00的data
 */
+ (NSData *)QY_FilterPrefixZero:(NSData *)data ;

/**
 *  NSData --> NSString(normal)
 *  例:<37393339 35313738 31407171 2e636f6d> --> 793951781@qq.com
 *
 *  @param data 目标数据
 *
 *  @return 转换好的普通数据
 */
+ (NSString *)QY_NSData2NSString:(NSData *)data ;

@end