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
    return [self getCmd:data range:NSMakeRange(JRM_DATA_LEN_OF_KEY_LEN, JRM_DATA_LEN_OF_KEY_CMD)] ;
}

+ (JOSEPH_COMMAND)getCmd:(NSData *)data range:(NSRange)range {
    return (JOSEPH_COMMAND)[self getIntegerValue:data range:range] ;
}

+ (NSString *)getStringValue:(NSData *)data range:(NSRange)range {
    return [NSData QY_NSData2NSString:[data subdataWithRange:range]] ? : @"" ;
}

+ (NSNumber *)getNumberValue:(NSData *)data range:(NSRange)range {
    return @([self getIntegerValue:data range:range]) ;
}

+ (NSInteger)getIntegerValue:(NSData *)data range:(NSRange)range {
    return [self getIntegerValue:[data subdataWithRange:range]] ;
}

+ (NSInteger)getIntegerValue:(NSData *)data {
    if (!data) return 0 ;
    NSInteger res = 0 ;
    Byte *dataByte = (Byte *)[data bytes] ;
    for ( int i = 0 ; i < data.length ; i++ ) {
        Byte tempB = dataByte[i] ;
        NSUInteger tempI = (NSUInteger)tempB ;
        res = res * 256 + tempI ;
    }
    return res ;
}

+ (NSData *)getImageData:(NSData *)data range:(NSRange)range {
    return [data subdataWithRange:range] ;
}

+ (NSArray *)getListValue:(NSData *)data range:(NSRange)range perDataLen:(NSUInteger)len {
    if ( range.length % len != 0 ) {
        QYDebugLog(@"请检查数据") ;
        return nil ;
    }
    data = [data subdataWithRange:range] ;
    NSMutableArray *result = [NSMutableArray array] ;
    NSInteger num = range.length / len ;
    
    for (int i = 0 ; i < num ; i++ ) {
        NSRange range = NSMakeRange( i * len , len ) ;
        NSString *str = [self getStringValue:data range:range] ;
        [result addObject:str] ;
    }    
    return result ;
}

@end