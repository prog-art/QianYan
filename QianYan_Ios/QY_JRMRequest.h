//
//  QY_JRMRequest.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_jclient_jrm_protocol_Marco.h"

#import "JRMvalue.h"

/**
 *  包含请求的各种参数
 */
@interface QY_JRMRequest : NSObject

+ (instancetype)requestWithAPINo:(JRM_REQUEST_OPERATION_TYPE)apiNo
                             Cmd:(JOSEPH_COMMAND)cmd
                       JRMValues:(NSArray *)values
                      ValueCount:(NSUInteger)count
                  AttachmentData:(NSData *)attachmentData ;

- (instancetype)initWithAPINo:(JRM_REQUEST_OPERATION_TYPE)apiNo
                          Cmd:(JOSEPH_COMMAND)cmd
                    JRMValues:(NSArray *)values
                   ValueCount:(NSUInteger)count
               AttachmentData:(NSData *)attachmentData ;


#pragma mark

/**
 *  结束时是否保持连接
 */
@property (nonatomic) BOOL keepConnecting ;

/**
 *  API编号
 */
@property (nonatomic) JRM_REQUEST_OPERATION_TYPE apiNo ;

/**
 *  Request请求Command
 */
@property (nonatomic) JOSEPH_COMMAND cmd ;

/**
 *  jrmvalue数组
 */
@property (nonatomic) NSArray *jvalues ;

/**
 *  是否包含附件
 */
@property (assign) BOOL attachment ;

/**
 *  附件的NSData
 */
@property (nonatomic) NSData *attachmentData ;

/**
 *  数据长度
 *
 *  @return
 */
- (NSUInteger)length ;

/**
 *  获得编码
 *
 *  @return
 */
- (NSMutableData *)getJRMData ;

@end