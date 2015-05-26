//
//  JRMvalue.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JRMvalueDescription.h"

/**
 *  一个数据模型，描述jrmdata中的value值，长度len，和value的type。
 */
@interface JRMvalue : NSObject

+ (instancetype)objectWithValue:(id)value description:(JRMvalueDescription *)description ;

- (instancetype)initWithValue:(id)value description:(JRMvalueDescription *)description ;

- (instancetype)initWithValue:(id)value valueLen:(NSUInteger)len valueType:(JRMValueType)type ;

+ (instancetype)objectWithValue:(id)value valueLen:(NSUInteger)len valueType:(JRMValueType)type ;

#pragma mark - 属性

/**
 *  value的描述(type,len)
 */
@property (nonatomic,readonly) JRMvalueDescription *valueDescription ;

/**
 *  值的本体(字符串 NSString
 *          数字 NSNumber
 *          图片 [UIImage data])
 */
@property (nonatomic,readonly) id value ;

/**
 *  value的长度
 */
- (NSUInteger)len ;

/**
 *  value的type
 */
- (JRMValueType)type ;

@end