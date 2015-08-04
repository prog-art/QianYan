//
//  QY_JRMRequest.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMRequest.h"

#import "QY_Common.h"

#import "JRMDataFormatUtils.h"

NSString *const kRequestException = @"RqeustException";

@interface QY_JRMRequest () {
    NSUInteger _length ;
}

@end

@implementation QY_JRMRequest

+ (instancetype)requestWithAPINo:(JRM_REQUEST_OPERATION_TYPE)apiNo
                             Cmd:(JOSEPH_COMMAND)cmd
                       JRMValues:(NSArray *)values
                      ValueCount:(NSUInteger)count
                  AttachmentData:(NSData *)attachmentData {
    return [[self alloc] initWithAPINo:apiNo
                                   Cmd:cmd
                             JRMValues:values
                            ValueCount:count
                        AttachmentData:attachmentData] ;
}

- (instancetype)initWithAPINo:(JRM_REQUEST_OPERATION_TYPE)apiNo
                          Cmd:(JOSEPH_COMMAND)cmd
                    JRMValues:(NSArray *)values
                   ValueCount:(NSUInteger)count
               AttachmentData:(NSData *)attachmentData {
    if ( count != ( values ? values.count : 0 )) {
        [NSException raise:kRequestException format:@"参数错误请检查，reason:count和values数目不一致"] ;
    }
    
    if ( self = [self init] ) {
        self.apiNo = apiNo ;
        self.cmd = cmd ;
        self.jvalues = values ;
        if ( nil != attachmentData ) {
            self.attachmentData = attachmentData ;
            self.attachment = TRUE ;
        }
    }
    
    return self ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        self.attachment = FALSE ;
        self.keepConnecting = FALSE ;
    }
    return self ;
}

#pragma mark - 

/**
 *  数据长度
 *
 *  @return
 */
- (NSUInteger)length {
    if ( _length == 0 ) {
        _length = [self calculateDataLength] ;
    }
    return _length ;
}

- (NSUInteger)calculateDataLength {
    __block NSUInteger length = 0 ;
    length += JRM_DATA_LEN_OF_KEY_CMD ;
    [self.jvalues enumerateObjectsUsingBlock:^(JRMvalue *jvalue, NSUInteger idx, BOOL *stop) {
        length += jvalue.len ;
    }] ;
    
    return length;
}

/**
 *  获得JRM编码
 *
 *  @return
 */
- (NSMutableData *)getJRMData {
    NSMutableData *JRMData = [NSMutableData data] ;
    
    NSData *lenData = [JRMDataFormatUtils formatLenData:self.length] ;
    NSData *cmdData = [JRMDataFormatUtils formatCmdData:self.cmd] ;
    [JRMData appendData:lenData] ;
    [JRMData appendData:cmdData] ;
    lenData = nil ;
    cmdData = nil ;
    
    [self.jvalues enumerateObjectsUsingBlock:^(JRMvalue *jvalue, NSUInteger idx, BOOL *stop) {
        NSData *valueData ;
        
        switch (jvalue.type) {
            case JRMValueType_String :
                valueData = [JRMDataFormatUtils formatStringValueData:jvalue.value
                                                                toLen:jvalue.len] ;
                break;
            case JRMValueType_Number :
                valueData = [JRMDataFormatUtils formatNumberValueData:jvalue.value
                                                                toLen:jvalue.len] ;
                break ;
            case JRMValueType_ImageDataLen :
                valueData = [JRMDataFormatUtils formatNumberValueData:jvalue.value
                                                                toLen:jvalue.len] ;
                break ;
            default:
                break;
        }
        [JRMData appendData:valueData] ;
    }] ;
    
    //attachment
    if ( self.attachment && self.attachmentData != nil ) {
        [JRMData appendData:self.attachmentData] ;
    }
    
    return JRMData ;
}

@end
