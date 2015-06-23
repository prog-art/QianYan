//
//  QY_attache.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_attache.h"
#import "QY_feed.h"

#import "QY_jms_parameter_key_marco.h"

@implementation QY_attache

@dynamic attach_id;
@dynamic small;
@dynamic src;
@dynamic pub_date;
@dynamic type;
@dynamic user_id;
@dynamic feed;

- (instancetype)initWithDictionary:(NSDictionary *)attacheDic {
    if ( self = [super init] ) {
        self.attach_id = attacheDic[QY_key_id] ;
        NSArray *keys = @[QY_key_src,
                          QY_key_user_id,
                          QY_key_type,
                          QY_key_small,
                          QY_key_pub_date] ;
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            [self setValue:attacheDic[key] forKey:key] ;
        }] ;
    }
    return self ;
}

+ (NSSet *)attacheWithDicArray:(NSArray *)dicArray {
    if ( !dicArray ) return nil ;
    NSMutableSet *result = [NSMutableSet set] ;
    
    [dicArray enumerateObjectsUsingBlock:^(NSDictionary *attacheDic, NSUInteger idx, BOOL *stop) {
        [result addObject:[[self alloc] initWithDictionary:attacheDic]] ;
    }] ;
    
    return result ;
}

@end
