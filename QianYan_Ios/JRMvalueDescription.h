//
//  JRMvalueDescription.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JRMValueType) {
    JRMValueType_String = 1 ,
    JRMValueType_Number = 2 ,
    JRMValueType_ImageData  = 3 ,
    JRMValueType_NULL   = 4 ,
} ;

@interface JRMvalueDescription : NSObject

+ (instancetype)descriptionWithLen:(NSUInteger)len Type:(JRMValueType)type ;

- (instancetype)initWithLen:(NSUInteger)len Type:(JRMValueType)type ;

#pragma mark - 属性

/**
 *  对Value长度的描述
 */
@property (nonatomic,assign) NSUInteger len ;

/**
 *  对Value长度的描述
 */
@property (nonatomic,assign) JRMValueType type ;

@end