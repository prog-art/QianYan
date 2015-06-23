//
//  QY_feed.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_feed.h"
#import "QY_AlertMessage.h"
#import "QY_attache.h"
#import "QY_comment.h"

#import "QY_jms_parameter_key_marco.h"


@implementation QY_feed

@dynamic attach_count;
@dynamic comment_count;
@dynamic content;
@dynamic digg_count;
@dynamic message_count;
@dynamic feed_id;
@dynamic pub_date;
@dynamic type;
@dynamic user_id;
@dynamic mod_date;
@dynamic digg;
@dynamic attachs;
@dynamic comments;
@dynamic messages;

- (instancetype)initWithFeedDic:(NSDictionary *)feedDic {
    if ( self = [super init] ) {
        self.feed_id = feedDic[QY_key_id] ;
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
        
        self.messages = [QY_AlertMessage messageWithDicArray:feedDic[QY_key_messages]] ;
        self.attachs = [QY_attache attacheWithDicArray:feedDic[QY_key_attaches]] ;
        self.comments = [QY_comment commentWithDicArray:feedDic[QY_key_comment]] ;
        
    }
    return self ;
}

@end
