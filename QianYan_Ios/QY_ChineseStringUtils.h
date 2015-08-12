//
//  SPChineseStringUtils.h
//  Sportplus
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.

#import <Foundation/Foundation.h>

@interface QY_ChineseStringUtils : NSObject

/**
 *  获取 NSArray (ChineseString) , 转换并排序
 *
 *  @param arr 待转换的数组 NSArray (id<ChineseString>)
 *
 *  @return NSArray (ChineseString)
 */
+ (NSMutableArray *)QY_getChineseStringArrWithArray:(NSArray *)arr ;

/**
 *  获取缓存的数组
 *
 *  @return NSArray (ChineseString)
 */
+ (NSMutableArray *)getChineseStringArr ;

/**
 *  获取title array 
 *  例:@[@"A",@"B"] ;
 *
 *  @return NSArray (NSString)
 */
+ (NSMutableArray *)getTitleArray ;

@end
