//
//  QY_feed+QY_JPRO_DATA_FORMAT.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_feed+QY_JPRO_DATA_FORMAT.h"

#import "CoreDataCategory.h"

@implementation QY_feed (QY_JPRO_DATA_FORMAT)


- (instancetype)initWithFeedDic:(NSDictionary *)feedDic {
    if ( self = [super init] ) {
#warning BUG
        self.feedId = feedDic[QY_key_id] ;
        NSArray *keys = @[QY_key_message_count,
                          QY_key_attach_count,
                          QY_key_mod_date,
                          QY_key_digg,
                          QY_key_pub_date,
                          QY_key_user_id,
                          QY_key_digg_count,
                          QY_key_content,
                          QY_key_comment_count] ;
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            [self setValue:feedDic[key] forKey:key] ;
        }] ;
        
        self.messages = [QY_alertMessage messageWithDicArray:feedDic[QY_key_messages]] ;
        self.attaches = [QY_attache attacheWithDicArray:feedDic[QY_key_attaches]] ;
        self.comments = [QY_comment commentWithDicArray:feedDic[QY_key_comment]] ;
        
    }
    return self ;
}

@end
