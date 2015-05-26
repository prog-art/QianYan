//
//  JRMvalueDescription.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "JRMvalueDescription.h"

@implementation JRMvalueDescription

+ (instancetype)descriptionWithLen:(NSUInteger)len Type:(JRMValueType)type {
    return [[JRMvalueDescription alloc] initWithLen:len Type:type] ;
}

- (instancetype)initWithLen:(NSUInteger)len Type:(JRMValueType)type {
    if ( self = [self init]) {
        self.len = len ;
        self.type = type ;
    }
    return self ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        self.len = 0 ;
        self.type = JRMValueType_NULL ;
    }
    return self ;
}

@end