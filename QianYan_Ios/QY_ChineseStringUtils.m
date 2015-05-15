//
//  SPChineseStringUtils.m
//  Sportplus
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.

#import "QY_ChineseStringUtils.h"

#import "QY_Common.h"

#import "pinyin.h"
#import "ChineseString.h"

#define DescriptorKey_PINYIN @"pinYin"

@implementation QY_ChineseStringUtils

static NSMutableArray *_titleArray = nil ;
static NSMutableArray *_ChineseStringArr = nil ;


+ (NSMutableArray *)QY_getChineseStringArrWithArray:(NSArray *)arr {
    NSMutableArray *chineseStrArr = [NSMutableArray array] ;
    
    for ( int i = 0 ; i < arr.count ; i++ ) {
        ChineseString *chineseString = [[ChineseString alloc] initWithString:arr[i]];
        
        [chineseStrArr addObject:chineseString] ;
    }
    
    _ChineseStringArr = [self sortTheChindeseStringArr:chineseStrArr] ;
    
    return _ChineseStringArr ;
}

+ (NSMutableArray *)getChineseStringArr {
    return _ChineseStringArr ;
}

+ (NSMutableArray *)getTitleArray {
    return _titleArray ;
}

#pragma mark - private method

/**
 *  排序,并缓存。
 *
 *  @param chineseStringsArray 待排序数组NSArray (ChineseString)
 *
 *  @return 排序后的数组
 */
+ (NSMutableArray *)sortTheChindeseStringArr:(NSMutableArray *)chineseStringsArray {
    NSMutableArray *titleArray = [NSMutableArray array] ;
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DescriptorKey_PINYIN ascending:YES]] ;
    
    [chineseStringsArray sortUsingDescriptors:sortDescriptors] ;
    
    NSMutableArray *arrayForArrays = [NSMutableArray array] ;
    
    BOOL checkValueAtIndex = NO ;
    NSMutableArray *TempArrForGrouping = nil ;
    for (NSInteger index = 0 ; index < [chineseStringsArray count] ; index++ ) {
        ChineseString *chineseStr = (ChineseString *)chineseStringsArray[index] ;
        NSMutableString *strchar = [NSMutableString stringWithString:chineseStr.pinYin] ;
        NSString *sr = [strchar substringToIndex:1] ;
        NSLog(@"%@",sr) ;
        
        if ( ![titleArray containsObject:[sr uppercaseString]]) {
            [titleArray addObject:[sr uppercaseString]] ;
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil] ;
            checkValueAtIndex = NO ;
        }
        
        if ([titleArray containsObject:[sr uppercaseString]]) {
            [TempArrForGrouping addObject:chineseStringsArray[index]] ;
            if (checkValueAtIndex == NO) {
                [arrayForArrays addObject:TempArrForGrouping] ;
                checkValueAtIndex = YES ;
            }
        }
    }
    
    _titleArray = titleArray ;
    return arrayForArrays ;
}

@end
