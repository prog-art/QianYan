//
//  JRMvalue.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "JRMvalue.h"

@interface JRMvalue ()

@property (nonatomic,readwrite) JRMvalueDescription *valueDescription ;
@property (nonatomic,readwrite) id value ;

@end

@implementation JRMvalue

+ (instancetype)objectWithValue:(id)value description:(JRMvalueDescription *)description {
    return [[JRMvalue alloc] initWithValue:value description:description] ;
}



+ (instancetype)objectWithValue:(id)value valueLen:(NSUInteger)len valueType:(JRMValueType)type {
    return [[JRMvalue alloc] initWithValue:value valueLen:len valueType:type] ;
}

#pragma mark - Life Cycle

- (instancetype)initWithValue:(id)value description:(JRMvalueDescription *)description {
    if ( self = [self init] ) {
        self.value = value ;
        self.valueDescription = description ;
    }
    return self ;
}

- (instancetype)initWithValue:(id)value valueLen:(NSUInteger)len valueType:(JRMValueType)type {
    if ( self = [self init] ) {
        self.value = value ;
        self.valueDescription = [JRMvalueDescription descriptionWithLen:len Type:type] ;
    }
    return self ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        self.value = nil ;
        self.valueDescription = [JRMvalueDescription descriptionWithLen:0 Type:JRMValueType_NULL] ;
    }
    return self ;
}


#pragma mark - 属性

- (NSUInteger)len {
    return self.valueDescription.len ? : 0 ;
}

- (JRMValueType)type {
    return self.valueDescription.type ? : JRMValueType_NULL ;
}

@end
