//
//  NSString+QY_dataFormat.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "NSString+QY_dataFormat.h"

@implementation NSString(QY_dataFormat)

-(NSData*)QY_HexStrToHexBytes {
    NSMutableData* data = [NSMutableData data];
    
    NSString *tempSelf = (self.length % 2 ) == 0 ? self : [@"0" stringByAppendingString:self] ;
    
    int idx;
    for (idx = 0; idx+2 <= tempSelf.length ; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [tempSelf substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

-(NSData*)QY_NormalStrToHexBytes {
    NSData *data ;
    data = [self dataUsingEncoding:NSUTF8StringEncoding] ;
    return data ;
}

+(NSString *)QY_CMD2HexString:(JOSEPH_COMMAND)cmd {
    NSString *resStr = [NSString stringWithFormat:@"%x",cmd] ;
    return resStr ;
}

+(NSString *)QY_UInteger2HexString:(NSUInteger)integer {
    NSString *resStr = [NSString stringWithFormat:@"%x",integer] ;
    return resStr ;
}

#pragma mark - Private Method

/**
 *  16进制数字符串转10进制数字字符串
 *
 *  @param str 16进制数字符串
 *
 *  @return 10进制数字字符串
 */
+ (NSString *)privateQY_hexStrTo10Str:(NSString *)str {
    return [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,16)];
}

@end