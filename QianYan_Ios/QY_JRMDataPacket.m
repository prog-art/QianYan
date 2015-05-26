//
//  QY_JRMDataPacket.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMDataPacket.h"

#import "JRMvalueDescription.h"

#import "JRMvalue.h"

#import "JRMDataParseUtils.h"
#import "JRMDataFormatUtils.h"

#import "QY_CommonDefine.h"

@interface QY_JRMDataPacket () {
    NSMutableArray *_values ;
}

@property (nonatomic,readwrite) NSArray *valueDescriptions ;

/**
 *  JRMvalue数组,用于保存参数和参数的描述
 */
@property (nonatomic,readwrite) NSArray *jvalues ;

/**
 *  数据长度
 */
@property (assign,readwrite) NSUInteger length ;

/**
 *  cmd代码 enum JOSEPH_COMMAND ;
 */
@property (assign,readwrite) JOSEPH_COMMAND cmd ;

@end

@implementation QY_JRMDataPacket

#pragma mark - Life Cycle

+ (instancetype)packetWithCmd:(JOSEPH_COMMAND)cmd JRMvalues:(NSArray *)values ValueDescriptionsCount:(NSInteger)count {
    return [[QY_JRMDataPacket alloc] initWithCmd:cmd JRMvalues:values ValueDescriptionsCount:count] ;
}

- (instancetype)initWithCmd:(JOSEPH_COMMAND)cmd JRMvalues:(NSArray *)values ValueDescriptionsCount:(NSInteger)count {
    if (count != ( values ? values.count : 0 ) ) {
        QYDebugLog(@"参数错误请检查,reason:count和values数目不一致") ;
        return nil ;
    }
    
    
    if ( self = [self init] ) {
        self.cmd = cmd ;
        self.jvalues = values ;
        self.length = JRM_DATA_LEN_OF_KEY_CMD ;
        
        for ( int i = 0 ; i < values.count ; i++ ) {
            JRMvalue *jvalue = values[i] ;
            self.length += jvalue.len ;
        }
        
    }
    return self ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    self.valueDescriptions = nil ;
}

#pragma mark - 属性

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



#pragma mark - 方法

- (id)valueAtIndex:(NSInteger)index {
    if ( index < 0 || index >= self.jvalues.count ) {
        QYDebugLog(@"value数组越界") ;
        return nil ;
    }
    JRMvalue *jvalue = self.jvalues[index] ;
    return jvalue.value ;
}

- (JRMvalue *)jvalueAtIndex:(NSInteger)index {
    if ( index < 0 || index >= self.jvalues.count ) {
        QYDebugLog(@"jvalue数组越界") ;
        return nil ;
    }    
    return self.jvalues[index] ;
}

@end



#pragma mark - decode (NSData --> Obj)

@implementation QY_JRMDataPacket (jrmData2obj)

+ (instancetype)packetWithJRMData:(NSData *)data ValueDescriptions:(NSArray *)valueDescriptions ValueDescriptionsCount:(NSInteger)count {
    if ( count != valueDescriptions.count ) {
        QYDebugLog(@"警告！请检查参数！") ;
        return nil ;
    }    
    return [[QY_JRMDataPacket alloc] initWithJRMData:data ValueDescriptions:valueDescriptions ValueDescriptionsCount:count] ;
}

- (instancetype)initWithJRMData:(NSData *)data ValueDescriptions:(NSArray *)valueDescriptions ValueDescriptionsCount:(NSInteger)count {
    
    if ( self = [self init] ) {
//        self.valueDescriptions = [NSArray arrayWithObject:valueDescriptions] ;
        //解码
        
        //长度
        self.length = [JRMDataParseUtils getLen:data] ;
        //cmd
        self.cmd = [JRMDataParseUtils getCmd:data] ;
        
        //values
        NSMutableArray *jvalues = [NSMutableArray array] ;
        
        __block NSUInteger location = JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD ;
        [valueDescriptions enumerateObjectsUsingBlock:^(JRMvalueDescription * description, NSUInteger idx, BOOL *stop) {
            NSRange range = NSMakeRange(location, description.len) ;
            
            JRMvalue *jvalue ;
            
            switch (description.type) {
                case JRMValueType_String : {
                    NSString *strValue = [JRMDataParseUtils getStringValue:data
                                                                     range:range] ;
                    jvalue = [JRMvalue objectWithValue:strValue description:description] ;
                    break ;
                }
                case JRMValueType_Number : {
                    NSNumber *numValue = [JRMDataParseUtils getNumberValue:data
                                                                     range:range] ;
                    jvalue = [JRMvalue objectWithValue:numValue
                                           description:description] ;
                    break ;
                }
                case JRMValueType_ImageData : {
#warning 可能会有错 或解决方案，从当前position 都到最后
                    NSData *imageData = [JRMDataParseUtils getImageData:data
                                                                  range:range] ;
                    jvalue = [JRMvalue objectWithValue:imageData
                                           description:description] ;
                    break ;
                }
                default:
                    break;
            }
            
            [jvalues addObject:jvalue] ;
            location += description.len ;
        }] ;
        
        self.jvalues = jvalues ;
        
    }
    return self ;
}

@end



#pragma mark - encode (Obj --> NSData)

@implementation QY_JRMDataPacket (obj2jrmData)

- (NSData *)JRMData {
    NSMutableData *packetData = [NSMutableData data] ;
    
    NSData *lenData = [JRMDataFormatUtils formatLenData:self.length] ;
    [packetData appendData:lenData] ;
    
    NSData *cmdData = [JRMDataFormatUtils formatCmdData:self.cmd] ;
    [packetData appendData:cmdData] ;
    
    [self.jvalues enumerateObjectsUsingBlock:^(JRMvalue *jvalue, NSUInteger idx, BOOL *stop) {
        NSData *valueData ;
        
        switch (jvalue.type) {
            case JRMValueType_String: {
                valueData = [JRMDataFormatUtils formatStringValueData:jvalue.value toLen:jvalue.len] ;
                break;
            }
            case JRMValueType_Number: {
                valueData = [JRMDataFormatUtils formatNumberValueData:jvalue.value toLen:jvalue.len] ;
                break ;
            }
            case JRMValueType_ImageData: {
                valueData = jvalue.value ;
                break ;
            }
            default:
                break;
        }
        [packetData appendData:valueData] ;
    }] ;
    
    return packetData ;
}

@end