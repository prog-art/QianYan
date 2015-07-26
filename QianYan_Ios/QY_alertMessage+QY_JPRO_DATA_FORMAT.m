//
//  QY_alertMessage+QY_JPRO_DATA_FORMAT.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_alertMessage+QY_JPRO_DATA_FORMAT.h"
#import "QY_jpro_parameter_key_marco.h"

@implementation QY_alertMessage (QY_JPRO_DATA_FORMAT)


- (instancetype)initWithDictionary:(NSDictionary *)alertMsgDic {
    if ( self = [super init] ) {
        self.messageId = alertMsgDic[QY_key_id] ;
        NSArray *keys = @[QY_key_content,QY_key_user_id,QY_key_pub_date,QY_key_content,QY_key_type] ;
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            [self setValue:alertMsgDic[key] forKey:key] ;
        }] ;
    }
    return self ;
}

+ (NSSet *)messageWithDicArray:(NSArray *)dicArray {
    if ( !dicArray ) return nil ;
    NSMutableSet *result = [NSMutableSet set] ;
    
    [dicArray enumerateObjectsUsingBlock:^(NSDictionary *alertMsgDic, NSUInteger idx, BOOL *stop) {
        [result addObject:[[self alloc] initWithDictionary:alertMsgDic]] ;
    }] ;
    
    return result ;
} ;

@end
