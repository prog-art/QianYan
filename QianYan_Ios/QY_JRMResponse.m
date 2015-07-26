//
//  QY_JRMResponse.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMResponse.h"
#import "JRMDataParseUtils.h"

@interface QY_JRMResponse ()

@property (nonatomic) NSData *data ;
@property (nonatomic) QY_JRMAPIPhraseRule *phraseRule ;

@end

@implementation QY_JRMResponse

/**
 *  通过 服务器返回的NSData 和 被指派 phrase rule 生成
 *
 *  @param data           服务器返回的data body
 *  @param ruleDataSource 负责指派phraseRule
 *
 *  @return
 */
+ (instancetype)responseWithData:(NSData *)data
                  ruleDataSource:(id<QY_JRMResponsePhraseRuleDataSource>)ruleDataSource {
    return [[QY_JRMResponse alloc] initWithData:data
                                 ruleDataSource:ruleDataSource] ;
}

- (instancetype)initWithData:(NSData *)data
              ruleDataSource:(id<QY_JRMResponsePhraseRuleDataSource>)ruleDataSource {
    if ( self = [self init] ) {
        self.data = data ;
        self.ruleDataSource = ruleDataSource ;
        [self phrase] ;
    }
    return self ;
}

#pragma mark - 

- (void)phrase {
    assert(self.data) ;
    assert(self.ruleDataSource) ;
    QYDebugLog(@"开始解析") ;
    NSRange cmdRange = NSMakeRange(0, JRM_DATA_LEN_OF_KEY_CMD) ;
    JOSEPH_COMMAND cmd = [JRMDataParseUtils getCmd:self.data range:cmdRange] ;
    self.phraseRule = [self.ruleDataSource getPhraseRuleByCmd:cmd] ;
    
    self.success = [self.ruleDataSource requestSuccessedByCmd:cmd] ;
    
    NSData *data = self.data ;
    __block NSMutableArray *jvalues = [NSMutableArray array] ;
    __block NSUInteger location = JRM_DATA_LEN_OF_KEY_CMD ;
    [self.phraseRule.descriptions enumerateObjectsUsingBlock:^(JRMvalueDescription *description , NSUInteger idx, BOOL *stop) {
        NSRange range = NSMakeRange(location, description.len) ;
        
        JRMvalue *jvalue ;
        
        switch (description.type) {
            case JRMValueType_String : {
                NSString *strValue = [JRMDataParseUtils getStringValue:data range:range] ;
                jvalue = [JRMvalue objectWithValue:strValue description:description] ;
                break;
            }
            
            case JRMValueType_Number : {
                NSNumber *numValue = [JRMDataParseUtils getNumberValue:data range:range] ;
                jvalue = [JRMvalue objectWithValue:numValue description:description] ;
                break ;
            }
                
            case JRMValueType_ImageDataLen : {
                NSNumber *numValue = [JRMDataParseUtils getNumberValue:data range:range] ;
                jvalue = [JRMvalue objectWithValue:numValue description:description] ;
                self.attachmentLen = [numValue integerValue] ;
                break ;
            }
            case JRMValueType_String_List : {
                NSRange range = NSMakeRange(location, data.length - location) ;
                NSArray *strListValue = [JRMDataParseUtils getListValue:data range:range perDataLen:description.len];
                jvalue = [JRMvalue objectWithValue:strListValue description:description] ;
            }
            default:
                break;
        }
        
        if ( jvalue ) {
            [jvalues addObject:jvalue] ;
        }
        location += description.len ;
    }] ;
    self.values = jvalues ;
}

- (void)phraseFinished {
    self.data = nil ;
    self.phraseRule = nil ;
}

/**
 *  是否包含附件
 */
- (BOOL)attachment {
    return self.phraseRule.attachment ;
}

- (id)valueAtIndex:(NSInteger)index {
    if ( index < 0 || index >= self.values.count ) {
        QYDebugLog(@"index越界") ;
        return nil ;
    }
    JRMvalue *jvalue = self.values[index] ;
    return jvalue.value ;
}

@end