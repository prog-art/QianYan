//
//  QY_JRMDataPacket.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMDataPacket.h"

@implementation QY_JRMDataPacket {
    NSMutableArray *_values ;
}

- (NSMutableArray *)getMvalues {
    if ( _values == nil ) {
        _values = [NSMutableArray array] ;
    }
    return _values ;
}

- (NSArray *)values {
    NSArray *res = [NSArray arrayWithArray:[self getMvalues]] ;
    return res ;
}

- (void)setValues:(NSArray *)values {
    NSMutableArray *mValues = [self getMvalues] ;
    mValues = [values mutableCopy] ;
}

- (void)addValues:(id)obj {
    NSMutableArray *mValues = [self getMvalues] ;
    [mValues addObject:obj] ;
}

@end
