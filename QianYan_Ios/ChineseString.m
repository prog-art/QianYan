//
//  ChineseString.m
//  Sportplus
//
//  Created by Forever.H on 15/3/15.
//  Modified By 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.

#import "ChineseString.h"
#import "pinyin.h"

#import "QY_Common.h"

@implementation ChineseString

#pragma mark - Life Cycle

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string {
    if ( self = [self init]) {
        [self setString:string] ;
    }
    return self ;
}

#pragma mark - Setter && Getter

- (void)setString:(NSString *)string {
    QYDebugLog(@"%@",string) ;
    _string = string ;
    [self initPinYinByString] ;
}

#pragma mark - init method

- (void)initPinYinByString {
    QYDebugLog() ;
    if ( !self.string )
        self.string = @"" ;
    
    if ( ![self.string isEqualToString:@""] ) {
        //join the pinYin
        NSString *pinYinResult = [NSString string] ;

        for ( int i = 0 ; i < self.string.length ; i ++ ) {
            NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([self.string characterAtIndex:i])] uppercaseString] ;
            pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter] ;
        }
        
        self.pinYin = pinYinResult ;
    } else {
        self.pinYin = @"" ;
    }
}

#pragma mark - override

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"{\n    string = %@\n    pinYin = %@\n}",_string,_pinYin] ;
    return description ;
}

@end
