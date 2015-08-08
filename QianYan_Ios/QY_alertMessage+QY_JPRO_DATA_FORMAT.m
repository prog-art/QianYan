//
//  QY_alertMessage+QY_JPRO_DATA_FORMAT.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_alertMessage+QY_JPRO_DATA_FORMAT.h"
#import "QY_jpro_parameter_key_marco.h"
#import "QY_appDataCenter.h"
#import "QYUtils.h"

@implementation QY_alertMessage (QY_JPRO_DATA_FORMAT)

+ (QY_alertMessage *)alertMessage {
    return (id)[QY_appDataCenter insertObjectForName:NSStringFromClass(self)] ;
}

+ (QY_alertMessage *)alertMessageWithId:(NSString *)messageId {
    if ( !messageId ) return nil ;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageId = %@",messageId] ;
    QY_alertMessage *message = (id)[QY_appDataCenter findObjectWithClassName:NSStringFromClass(self) predicate:predicate] ;
    
    if ( !message ) {
        message = [self alertMessage] ;
        message.messageId = messageId ;
    }
    
    return message ;
}

- (void)initWithDictionary:(NSDictionary *)alertMsgDic {    
    //read 字段舍弃。
    
    NSDictionary *keys2keys = @{QY_key_jipnc_id:NSStringFromSelector(@selector(cameraId)),
                                QY_key_type:NSStringFromSelector(@selector(type))} ;
    [keys2keys enumerateKeysAndObjectsUsingBlock:^(NSString *remoteKey, NSString *localKey, BOOL *stop) {
        [self setValue:alertMsgDic[remoteKey] forKey:localKey] ;
    }] ;
    
    self.userId = [alertMsgDic[QY_key_user_id] stringValue] ;
    self.content = alertMsgDic[QY_key_content] ;
    self.pubDate = [QYUtils timestampStr2date:[alertMsgDic[QY_key_pub_date] stringValue]] ;
}

+ (NSSet *)messageWithDicArray:(NSArray *)alertMessageDics {
    if ( !alertMessageDics ) return nil ;
    NSMutableSet *alertMessages = [NSMutableSet set] ;
    
    [alertMessageDics enumerateObjectsUsingBlock:^(NSDictionary *alertMsgDic, NSUInteger idx, BOOL *stop) {
        
        NSString *messageId = [alertMsgDic[QY_key_id] stringValue] ;
        
        QY_alertMessage *message = [QY_alertMessage alertMessageWithId:messageId] ;
        
        [message initWithDictionary:alertMsgDic] ;
        
        [alertMessages addObject:message] ;
    }] ;
    
    return alertMessages ;
} ;

@end
