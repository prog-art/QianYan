//
//  QY_JRMAPIDescriptor.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/24.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_jclient_jrm_protocol_Marco.h"

#import "QY_JRMRequest.h"
#import "QY_JRMResponse.h"
#import "QY_JRMAPIPhraseRule.h"

/**
 *  用于描述 JRM API，这是一个work model。组件通过这个描述model自动完成工作
 *  1. 根据request model 组装 需要发送的字符串
 *  2. socket收到服务器返回data后，根据cmd code选择success解析方式 or fail解析方式
 *  3.
 */
@interface QY_JRMAPIDescriptor : NSObject

#pragma mark - Init 

+ (instancetype)descriptorWithRequest:(QY_JRMRequest *)request
                          successRule:(QY_JRMAPIPhraseRule *)successRule
                             failRule:(QY_JRMAPIPhraseRule *)failRule ;

- (instancetype)initWithRequest:(QY_JRMRequest *)request
                    successRule:(QY_JRMAPIPhraseRule *)successRule
                       failRule:(QY_JRMAPIPhraseRule *)failRule ;

+ (instancetype)descriptorWithRequestBlock:(QY_JRMRequest *(^)(void))request
                          successRuleBlock:(QY_JRMAPIPhraseRule *(^)(void))successRule
                             failRuleBlock:(QY_JRMAPIPhraseRule *(^)(void))failRule ;

- (instancetype)initWithRequestBlock:(QY_JRMRequest *(^)(void))request
                    successRuleBlock:(QY_JRMAPIPhraseRule *(^)(void))successRule
                       failRuleBlock:(QY_JRMAPIPhraseRule *(^)(void))failRule ;

#pragma mark - Request

/**
 *  [生成通过request内的cmd初始化]API编号 例: 2510
 */
@property (assign,readonly) JRM_REQUEST_OPERATION_TYPE apiNo ;

///**
// *  描述API的功能，通过apiNo生成
// *
// *  @return
// */
//- (NSString *)apiDescription ;

/**
 *  [生成时必要]请求描述，用于负责收纳
 */
@property (nonatomic) QY_JRMRequest *request ;

#pragma mark - Response

/**
 *  成功时的解析规则
 */
@property (nonatomic) QY_JRMAPIPhraseRule *success ;

/**
 *  失败时的解析规则
 */
@property (nonatomic) QY_JRMAPIPhraseRule *fail ;

///**
// *  [生成时必要]指定API成功的返回CMD
// */
//@property (nonatomic) QY_CMD success ;
//
///**
// *  [生成时必要]指定API失败的返回CMD
// */
//@property (nonatomic) QY_CMD fail ;

/**
 *  [后续设置]从服务器拿到的部分
 */
@property (nonatomic) QY_JRMResponse *response ;

/**
 *  设置Response，方法内自动根据解析出的CMD选择解析规则。并通过block通知socket delegater是否需要继续读取附件
 *
 *  @param data 从JRM服务器收到Data
 *  @param shouldReadDataBlock 解析后通过此block返回是否需要继续读取附件
 */
- (void)setResponseWithData:(NSData *)data ShouldReadAppendDataBlock:(void(^)(BOOL should,NSUInteger len))shouldReadDataBlock ;

/**
 *  [后续设置]附件的Data。目前类型就一个：Image
 */
@property (nonatomic) NSData *attachmentData ;



@end