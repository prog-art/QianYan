//
//  JRMDataParseUtils.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QY_jclient_jrm_protocol_Marco.h"
#import "QY_Common.h"

#pragma mark - JRMDataParseUtils

@interface JRMDataParseUtils : NSObject

/**
 *  获取 range(0,2)部分的len integer数据
 *
 *  @param data JRMdata
 *
 *  @return 例 <0004****> --> 4
 */
+ (NSUInteger)getLen:(NSData *)data QYDeprecated("第二版socket组件开发完成后停止使用") ;

/**
 *  获取(2,4)部分的cmd integer数据
 *
 *  @param data JRMdata
 *
 *  @return 例 (<00040000 019d> --> 0x019d --> 413 ) --> JCLIENT_REG_NEW_USER_REPLY
 */
+ (JOSEPH_COMMAND)getCmd:(NSData *)data QYDeprecated("第二版socket组件开发完成后停止使用") ;

+ (JOSEPH_COMMAND)getCmd:(NSData *)data range:(NSRange)range ;

/**
 *  获取range 部分的 string数据（无视后0）
 *
 *  @param data  JRMData
 *  @param range 位置
 *
 *  @return 例 <00140000 019d3130 30303031 33300000 00000000 0000> range(6,16) --> @"10000130"
 */
+ (NSString *)getStringValue:(NSData *)data range:(NSRange)range ;

+ (NSString *)getStringValue:(NSData *)data ;

/**
 *  获取range 部分的 NSNumber数据(无视前0)
 *
 *  @param data  JRMData
 *  @param range 位置
 *
 *  @return 例 <0004****> range(0,2) --> @4
 */
+ (NSNumber *)getNumberValue:(NSData *)data range:(NSRange)range ;

/**
 *  获取range 部分的 integer数据(无视前0)
 *
 *  @param data  JRMData
 *  @param range 位置
 *
 *  @return 例 <0004****> range(0,2) --> 4
 */
+ (NSInteger)getIntegerValue:(NSData *)data range:(NSRange)range ;

+ (NSInteger)getIntegerValue:(NSData *)data ;

/**
 *  获取range 部分的 imageData数据
 *
 *  @param data  JRMData
 *  @param range 位置
 *
 *  @return NSData 图片的数据
 */
+ (NSData *)getImageData:(NSData *)data range:(NSRange)range QYDeprecated("第二版socket组件开发完成后停止使用") ;

+ (NSArray *)getListValue:(NSData *)data range:(NSRange)range perDataLen:(NSUInteger)len ;

@end