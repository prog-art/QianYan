//
//  ChineseString.h
//  Sportplus
//
//  Created by Forever.H on 15/3/15.
//  Modified By 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.

#import <Foundation/Foundation.h>

@interface ChineseString : NSObject

/**
 *  源字符串
 */
@property(nonatomic, copy)NSString *string;

/**
 *  转化的拼音字符串
 */
@property(nonatomic, copy)NSString *pinYin;

- (instancetype)initWithString:(NSString *)string ;

@end
