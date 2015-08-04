//
//  QY_comment+QY_JPRO_DATA_FORMAT.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_comment+QY_JPRO_DATA_FORMAT.h"

#import "QY_jpro_parameter_key_marco.h"

#import "QY_Common.h"

@implementation QY_comment (QY_JPRO_DATA_FORMAT)

+ (QY_comment *)comment {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[QY_appDataCenter managedObjectContext]] ;
}

+ (QY_comment *)commentWithId:(NSString *)commentId {
    assert(commentId) ;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commentId = %@",commentId] ;
    QY_comment *comment = (id)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate];
    
    if ( !comment ) {
        comment = [self comment] ;
        comment.commentId = commentId ;
    }
    
    return comment ;
}

- (void)initWithDictionary:(NSDictionary *)commentDic {
    
#warning userId换为user!!![之后看换不换]
    NSDictionary *keys2keys = @{QY_key_content:NSStringFromSelector(@selector(content))} ;
    
    [keys2keys enumerateKeysAndObjectsUsingBlock:^(NSString *remoteKey, NSString *localKey, BOOL *stop) {
        [self setValue:commentDic[remoteKey] forKey:localKey] ;
    }] ;
    
    self.userId = [commentDic[QY_key_user_id] stringValue] ;
    
    self.pubDate = [QYUtils timestampStr2date:[commentDic[QY_key_pub_date] stringValue]] ;
}

+ (NSSet *)commentWithDicArray:(NSArray *)dicArray {
    if ( !dicArray ) return nil ;
    NSMutableSet *comments = [NSMutableSet set] ;
    
    [dicArray enumerateObjectsUsingBlock:^(NSDictionary *commentDic, NSUInteger idx, BOOL *stop) {
        NSString *commentId = [commentDic[QY_key_id] stringValue];
        QY_comment *comment = [self commentWithId:commentId] ;
        
        [comment initWithDictionary:commentDic] ;

        [comments addObject:comment] ;
    }] ;
    
    return comments ;
}

@end
