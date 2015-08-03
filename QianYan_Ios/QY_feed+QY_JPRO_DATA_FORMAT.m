//
//  QY_feed+QY_JPRO_DATA_FORMAT.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_feed+QY_JPRO_DATA_FORMAT.h"

#import "CoreDataCategory.h"

#import "QY_Common.h"

@implementation QY_feed (QY_JPRO_DATA_FORMAT)

+ (QY_feed *)feed {
    QY_feed *feed = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[QY_appDataCenter managedObjectContext]] ;
    return feed ;
}

+ (QY_feed *)feedWithId:(NSString *)feedId {
    assert(feedId) ;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedId = %@",feedId] ;
    QY_feed *feed = (id)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;
    
    if ( !feed ) {
        feed = [self feed] ;
        feed.feedId = feedId ;
    }
    
    return feed ;
}

- (void)initWithFeedDic:(NSDictionary *)feedDic {
    NSDictionary *keys2keys = @{QY_key_message_count:NSStringFromSelector(@selector(messageCount)),
                                QY_key_attach_count:NSStringFromSelector(@selector(attachCount)),
                                QY_key_digg_count:NSStringFromSelector(@selector(diggCount)),
                                QY_key_comment_count:NSStringFromSelector(@selector(commentCount)),
                                } ;
    [keys2keys enumerateKeysAndObjectsUsingBlock:^(NSString *remoteKey, NSString *localKey, BOOL *stop) {
        [self setValue:feedDic[remoteKey] forKey:localKey] ;
    }] ;

    self.type = @([feedDic[QY_key_type] integerValue]) ;
    self.content = feedDic[QY_key_content] ;
    self.modDate = [QYUtils timestampStr2date:[feedDic[QY_key_mod_date] stringValue]] ;
    self.pubDate = [QYUtils timestampStr2date:[feedDic[QY_key_pub_date] stringValue]] ;
    
    self.owner = [QY_user insertUserById:[feedDic[QY_key_user_id] stringValue]] ;
    
    BOOL digg = [feedDic[QY_key_digg] boolValue] ;
    
    if ( digg ) {
        [self removeDiggedByUsersObject:self.owner] ;
    } else {
        [self addDiggedByUsersObject:self.owner] ;
    }
    
#warning messages暂时不写！
//    [self setMessages:[QY_alertMessage messageWithDicArray:feedDic[QY_key_messages]]] ;
    [self setAttaches:[QY_attach attacheWithDicArray:feedDic[QY_key_attaches]]] ;//应该ok
    [self setComments:[QY_comment commentWithDicArray:feedDic[QY_key_comment]]] ;
}

@end
