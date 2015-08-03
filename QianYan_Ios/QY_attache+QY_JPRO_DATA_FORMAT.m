//
//  QY_attache+QY_JPRO_DATA_FORMAT.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_attache+QY_JPRO_DATA_FORMAT.h"

#import "CoreDataCategory.h"

#import "QY_Common.h"

@implementation QY_attach (QY_JPRO_DATA_FORMAT)

+ (QY_attach *)attach {
    QY_attach *attach = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:[QY_appDataCenter managedObjectContext]] ;
    return attach ;
}

+ (QY_attach *)attachWithId:(NSString *)attachId {
    assert(attachId) ;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attachId = %@",attachId] ;
    QY_attach *attach = (id)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate];
    
    if ( !attach ) {
        attach = [self attach] ;
        attach.attachId = attachId ;
    }
    
    return attach ;
}

- (void)initWithDictionary:(NSDictionary *)attacheDic {
#warning attach的small字段呢？！！！
    NSDictionary *keys2keys = @{QY_key_src:NSStringFromSelector(@selector(src)),
                                QY_key_type:NSStringFromSelector(@selector(type)),
                                QY_key_small:NSStringFromSelector(@selector(small)),
                                } ;
    
    [keys2keys enumerateKeysAndObjectsUsingBlock:^(NSString *remoteKey, NSString *localKey, BOOL *stop) {
        [self setValue:attacheDic[remoteKey] forKey:localKey] ;
    }] ;
    
    self.userId = [attacheDic[QY_key_user_id] stringValue] ;
    self.pubDate = [QYUtils timestampStr2date:[attacheDic[QY_key_pub_date] stringValue]] ;
}

+ (NSSet *)attacheWithDicArray:(NSArray *)dicArray {
    if ( !dicArray ) return nil ;
    NSMutableSet *attaches = [NSMutableSet set] ;
    
    [dicArray enumerateObjectsUsingBlock:^(NSDictionary *attacheDic, NSUInteger idx, BOOL *stop) {
        NSString *attachId = [attacheDic[QY_key_id] stringValue] ;
        QY_attach *attach = [self attachWithId:attachId] ;
        
        [attach initWithDictionary:attacheDic] ;
        
        [attaches addObject:attach] ;
    }] ;
    
    return attaches ;
}

@end