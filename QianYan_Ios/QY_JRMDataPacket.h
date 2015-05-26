//
//  QY_JRMDataPacket.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QY_jclient_jrm_protocol_Marco.h"

@class JRMvalue ;

/**
 *  数据模型类，在类别提供Encode和Decode方法。
 */
@interface QY_JRMDataPacket : NSObject

/**
 *  构造方法
 *
 *  @param cmd    命令
 *  @param values NSArray<JRMvalue>
 *  @param count  参数个数，用于验证
 *
 *  @return 实例
 */
+ (instancetype)packetWithCmd:(JOSEPH_COMMAND)cmd JRMvalues:(NSArray *)values ValueDescriptionsCount:(NSInteger)count ;

/**
 *  对应上述类方法
 */
- (instancetype)initWithCmd:(JOSEPH_COMMAND)cmd JRMvalues:(NSArray *)values ValueDescriptionsCount:(NSInteger)count ;

#pragma mark - 属性

/**
 *  数据长度
 */
@property (assign,readonly) NSUInteger length ;

/**
 *  cmd代码 enum JOSEPH_COMMAND ;
 */
@property (assign,readonly) JOSEPH_COMMAND cmd ;

/**
 *  值数组
 */
@property (nonatomic,readonly) NSArray *values ;

#pragma mark - 方法

/**
 *  取出第几位的参数
 *
 *  @param index
 *
 *  @return value实例
 */
- (id)valueAtIndex:(NSInteger)index ;

/**
 *  取出第几位的Jvalue
 *
 *  @param index
 *
 *  @return JRMvalue实例
 */
- (JRMvalue *)jvalueAtIndex:(NSInteger)index ;

@end



#pragma mark - decode (NSData --> Obj)

@interface QY_JRMDataPacket (jrmData2obj)

/**
 *  传入jrm data 和 valueDescriptions数组,返回解析好的实例(len,cmd,value)
 *
 *  @param data              JRMData
 *  @param valueDescriptions NSArray<JRMvalueDescription>
 *  @param count             参数个数
 *
 *  @return QY_JRMDataPacket
 */
+ (instancetype)packetWithJRMData:(NSData *)data ValueDescriptions:(NSArray *)valueDescriptions ValueDescriptionsCount:(NSInteger)count ;

@end

#pragma mark - encode (Obj --> NSData)

@interface QY_JRMDataPacket (obj2jrmData)

/**
 *  在实例(len,cmd,value齐全的时候)获取JRMData
 */
- (NSData *)JRMData ;

@end