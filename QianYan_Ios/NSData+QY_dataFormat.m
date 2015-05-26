//
//  NSData+QY_dataFormat.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "NSData+QY_dataFormat.h"

#import "NSString+QY_dataFormat.h"

@implementation NSData(QY_dataFormat)

+ (NSData *)QY_FillZero:(NSData *)data ToLen:(NSUInteger)len {
    NSMutableData *mdata = [NSMutableData data] ;
    
    NSUInteger zeroLen = len - data.length ;
    
    [mdata increaseLengthBy:zeroLen] ;
    [mdata appendBytes:[data bytes] length:[data length]] ;
    
    return mdata ;
}

+ (NSData *)QY_FillZeroAtBack:(NSData *)data ToLen:(NSUInteger)len {
    NSMutableData *mdata ;

    NSUInteger zeroLen = len - data.length ;
    NSMutableData *zeroData = [NSMutableData dataWithLength:zeroLen] ;
    
    mdata = [data mutableCopy] ;
    [mdata appendData:zeroData] ;
    
    return mdata ;
}

+ (NSData *)QY_FilterPrefixZero:(NSData *)data {
    NSData *resData ;
    
    Byte *bytes = (Byte *)[data bytes] ;
    
    NSInteger index ;
    for ( int i = 0 ; i < data.length ; i++) {
        Byte tempB = bytes[i] ;
        if ( tempB != 0x00 ) {
            index = i ;
            break ;
        }
    }
    
    NSRange range = NSMakeRange(index, data.length - index) ;
    resData = [[data mutableCopy] subdataWithRange:range] ;
    return resData ;
}

+ (NSString *)QY_NSData2NSString:(NSData *)data {
    NSString *resStr ;
    resStr = [NSString stringWithUTF8String:[data bytes]] ;
    return resStr ;
}

@end