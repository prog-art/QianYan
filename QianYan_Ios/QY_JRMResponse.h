//
//  QY_JRMResponse.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_jclient_jrm_protocol_Marco.h"

#import "QY_JRMAPIPhraseRule.h"

@protocol QY_JRMResponsePhraseRuleDataSource <NSObject>

@required

/**
 *  通过解析出的cmd去获取对应指派的解析rule
 *
 *  @param cmd
 *
 *  @return
 */
- (QY_JRMAPIPhraseRule *)getPhraseRuleByCmd:(JOSEPH_COMMAND)cmd ;

/**
 *  请求是成功还是失败
 *
 *  @param cmd
 *
 *  @return
 */
- (BOOL)requestSuccessedByCmd:(JOSEPH_COMMAND)cmd ;

@end


/**
 *  上层Agent看到的返回，通过Phrase Rule 和 NSData生成。
 */
@interface QY_JRMResponse : NSObject

/**
 *  通过 服务器返回的NSData 和 被指派 phrase rule 生成
 *
 *  @param data           服务器返回的data body
 *  @param ruleDataSource 负责指派phraseRule
 *
 *  @return
 */
+ (instancetype)responseWithData:(NSData *)data
                  ruleDataSource:(id<QY_JRMResponsePhraseRuleDataSource>)ruleDataSource ;

- (instancetype)initWithData:(NSData *)data
              ruleDataSource:(id<QY_JRMResponsePhraseRuleDataSource>)ruleDataSource ;

@property (weak) id<QY_JRMResponsePhraseRuleDataSource> ruleDataSource ;

#pragma mark -

/**
 *  [预留]服务器返回的cmd，用于检查
 */
@property (assign) JOSEPH_COMMAND cmd ;

@property (nonatomic) NSArray *values ;

- (id)valueAtIndex:(NSInteger)index ;

/**
 *  附件
 */
@property (nonatomic) NSData *attachmentData ;

/**
 *  是否包含附件
 */
- (BOOL)attachment ;

/**
 *  附件长度
 */
@property (nonatomic) NSUInteger attachmentLen ;

/**
 *  请求成功或失败
 */
@property (assign) BOOL success ;

@end
