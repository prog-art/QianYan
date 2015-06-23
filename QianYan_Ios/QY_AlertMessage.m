//
//  QY_AlertMessage.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_AlertMessage.h"
#import "QY_feed.h"
#import "QY_jms_parameter_key_marco.h"

@implementation QY_AlertMessage

@dynamic content;
@dynamic jipnc_id;
@dynamic msg_id;
@dynamic pub_date;
@dynamic type;
@dynamic user_id;
@dynamic feed;

- (instancetype)initWithDictionary:(NSDictionary *)alertMsgDic {
    if ( self = [super init] ) {
        self.msg_id = alertMsgDic[QY_key_id] ;
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
