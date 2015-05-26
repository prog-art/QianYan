//
//  JRMDataParseUtils.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "JRMDataParseUtils.h"
#import "NSData+QY_dataFormat.h"
#pragma mark - JRMDataParseUtils

@implementation JRMDataParseUtils

+ (NSUInteger)getLen:(NSData *)data {
    return [self getIntegerValue:data range:NSMakeRange(0, JRM_DATA_LEN_OF_KEY_LEN)] ;
}

+ (JOSEPH_COMMAND)getCmd:(NSData *)data {
    return (JOSEPH_COMMAND)[self getIntegerValue:data range:NSMakeRange(JRM_DATA_LEN_OF_KEY_LEN, JRM_DATA_LEN_OF_KEY_CMD)] ;
}

+ (NSString *)getStringValue:(NSData *)data range:(NSRange)range {
    return [NSData QY_NSData2NSString:[data subdataWithRange:range]] ? : @"" ;
}

+ (NSNumber *)getNumberValue:(NSData *)data range:(NSRange)range {
    return @([self getIntegerValue:data range:range]) ;
}

+ (NSInteger)getIntegerValue:(NSData *)data range:(NSRange)range {
    NSInteger res = 0 ;
    Byte *dataByte = (Byte *)[[data subdataWithRange:range] bytes] ;
    for ( int i = 0 ; i < range.length ; i++) {
        Byte tempB = dataByte[i] ;
        NSUInteger tempI = (NSUInteger)tempB ;
        res = res * 256 + tempI ;
    }
    return res ;
}

+ (NSData *)getImageData:(NSData *)data range:(NSRange)range {
    return [data subdataWithRange:range] ;
}

@end