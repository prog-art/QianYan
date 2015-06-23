//
//  QY_comment.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_comment.h"
#import "QY_feed.h"

#import "QY_jms_parameter_key_marco.h"

@implementation QY_comment

@dynamic content;
@dynamic comment_id;
@dynamic pub_date;
@dynamic user_id;
@dynamic feed;


- (instancetype)initWithDictionary:(NSDictionary *)commentDic {
    if ( self = [super init] ) {
        self.comment_id = commentDic[QY_key_id] ;
        NSArray *keys = @[QY_key_content,QY_key_pub_date,QY_key_user_id] ;
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            [self setValue:commentDic[key] forKey:key] ;
        }] ;
    }
    return self ;
}

+ (NSSet *)commentWithDicArray:(NSArray *)dicArray {
    if ( !dicArray ) return nil ;
    NSMutableSet *result = [NSMutableSet set] ;
    
    [dicArray enumerateObjectsUsingBlock:^(NSDictionary *commentDic, NSUInteger idx, BOOL *stop) {
        [result addObject:[[self alloc] initWithDictionary:commentDic]] ;
    }] ;
    
    return result ;
}

@end
