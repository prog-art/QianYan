//
//  QY_JRMAPIDescriptor.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/24.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMAPIDescriptor.h"
#import "JRMDataParseUtils.h"

@interface QY_JRMAPIDescriptor ()<QY_JRMResponsePhraseRuleDataSource>

@end

@implementation QY_JRMAPIDescriptor

+ (instancetype)descriptorWithRequest:(QY_JRMRequest *)request
                          successRule:(QY_JRMAPIPhraseRule *)successRule
                             failRule:(QY_JRMAPIPhraseRule *)failRule {
    return [[self alloc] initWithRequest:request
                                            successRule:successRule
                                               failRule:failRule] ;
}

- (instancetype)initWithRequest:(QY_JRMRequest *)request
                    successRule:(QY_JRMAPIPhraseRule *)successRule
                       failRule:(QY_JRMAPIPhraseRule *)failRule {
    if ( self = [self init] ) {
        self.request = request ;
        self.success = successRule ;
        self.fail = failRule ;
    }
    return self ;
}

+ (instancetype)descriptorWithRequestBlock:(QY_JRMRequest *(^)(void))request
                          successRuleBlock:(QY_JRMAPIPhraseRule *(^)(void))successRule
                             failRuleBlock:(QY_JRMAPIPhraseRule *(^)(void))failRule {
    return [[self alloc] initWithRequestBlock:request
                             successRuleBlock:successRule
                                failRuleBlock:failRule] ;
}

- (instancetype)initWithRequestBlock:(QY_JRMRequest *(^)(void))request
                    successRuleBlock:(QY_JRMAPIPhraseRule *(^)(void))successRule
                       failRuleBlock:(QY_JRMAPIPhraseRule *(^)(void))failRule {
    if ( self = [self init] ) {
        self.request = request() ;
        self.success = successRule() ;
        self.fail = failRule() ;
    }
    return self ;
}

#pragma mark - 

/**
 *  设置Response，方法内自动根据解析出的CMD选择解析规则。并通过block通知socket delegater是否需要继续读取附件
 *
 *  @param data 从JRM服务器收到Data
 *  @param shouldReadDataBlock 解析后通过此block返回是否需要继续读取附件
 */
- (void)setResponseWithData:(NSData *)data ShouldReadAppendDataBlock:(void(^)(BOOL should,NSUInteger len))shouldReadDataBlock {
    self.response = [QY_JRMResponse responseWithData:data ruleDataSource:self] ;
    
    if ( self.response.attachment ) {
        shouldReadDataBlock(TRUE,self.response.attachmentLen) ;
    } else {
        shouldReadDataBlock(FALSE,0) ;
    }    
}

#pragma mark - getter && setter 

- (void)setAttachmentData:(NSData *)attachmentData {
    self.response.attachmentData = attachmentData ;
}

- (NSData *)attachmentData {
    return self.response.attachmentData ;
}

- (JRM_REQUEST_OPERATION_TYPE)apiNo {
    return self.request ? self.request.apiNo : 0 ;
}

#pragma mark - QY_JRMResponsePhraseRuleDataSource

/**
 *  通过解析出的cmd去获取对应指派的解析rule
 *
 *  @param cmd
 *
 *  @return
 */
- (QY_JRMAPIPhraseRule *)getPhraseRuleByCmd:(JOSEPH_COMMAND)cmd {
    if ( cmd == self.success.targetCMD ) {
        QYDebugLog(@"请求成功") ;
        return self.success ;
    } else
    if ( cmd == self.fail.targetCMD ) {
        QYDebugLog(@"请求失败") ;
        return self.fail ;
    }
    QYDebugLog(@"未知的CMD") ;
    return nil ;
}

/**
 *  请求是成功还是失败
 *
 *  @param cmd
 *
 *  @return
 */
- (BOOL)requestSuccessedByCmd:(JOSEPH_COMMAND)cmd {
    if ( cmd == self.success.targetCMD ) {
        return TRUE ;
    }
    return FALSE ;
}

@end
