//
//  JRMDataFormatUtils.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "JRMDataFormatUtils.h"

#import "NSString+QY_dataFormat.h"
#import "NSData+QY_dataFormat.h"


@implementation JRMDataFormatUtils

#pragma mark - format data method

/* 数据组装原则 字段名 type   长度      Usage
 * 前补0       len   int    2 bytes  默认
 * 前补0       cmd   int    4 bytes  默认
 * 前补0       value int    看文档    value类型为Int
 * 后补0       value str    看文档    value类型为String时
 *
 * 例:
 *      user_name(string,16bytes,后补0) , user_password(string,32bytes,后补0)
 *      userId(string,16bytes,后补0) , jpro_ip(string,32ytes,后补0)
 *      jpro_port(string,16bytes,__0) , jpro_password
 *
 *
 *
 *
 *
 *
 *
 *
 *
 */


/**
 *  组装Len字段Data
 *
 *  @param len 数据长度
 *
 *  @return Len字段Data
 */
+ (NSData *)formatLenData:(NSUInteger)len {
    return [self formatValueDataFromNormalInteger:len ToLength:JRM_DATA_LEN_OF_KEY_LEN] ;
}

+ (NSData *)formatCmdData:(JOSEPH_COMMAND)cmd {
    return [self formatValueDataFromNormalInteger:cmd ToLength:JRM_DATA_LEN_OF_KEY_CMD] ;
}

//用户名 密码 等
+ (NSData *)formatStringValueData:(NSString *)string toLen:(NSUInteger)dataLen {
    return [self formatBackZeroValueDataFromNormalString:string ToLength:dataLen] ;
}

+ (NSData *)formatNumberValueData:(NSNumber *)number toLen:(NSUInteger)dataLen {
    return [self formatValueDataFromNormalInteger:[number integerValue] ToLength:dataLen] ;
}

+ (NSData *)formatIntegerValueData:(NSInteger)integet toLen:(NSUInteger)dataLen {
    return [self formatValueDataFromNormalInteger:integet ToLength:dataLen] ;
}

#pragma mark - 提取的公共方法

/**
 *  通过Integer 组装Value data
 *
 *  @param integer 数字
 *  @param len     目标长度
 *
 *  @return 组装好的数据
 */
+ (NSData *)formatValueDataFromNormalInteger:(NSInteger)integer ToLength:(NSUInteger)len {
    NSData *valueData ;
    NSString *valueStr = [NSString QY_UInteger2HexString:integer] ;
    NSData *tempValueData = [valueStr QY_HexStrToHexBytes] ;
    valueData = [NSData QY_FillZero:tempValueData ToLen:len] ;
    return valueData ;
}

/**
 *  通过普通字符串 组装尾部填补0的 Value Data
 *
 *  @param string @"123456"
 *  @param len    目标长度
 *
 *  @return 组装好的数据
 */
+ (NSData *)formatBackZeroValueDataFromNormalString:(NSString *)string ToLength:(NSUInteger)len {
    NSData *valueData = [string QY_NormalStrToHexBytes] ;
    valueData = [NSData QY_FillZeroAtBack:valueData ToLen:len];
    return valueData ;
}

@end
