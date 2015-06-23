//
//  QY_AlertMessage.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QY_feed;

@interface QY_AlertMessage : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * jipnc_id;
@property (nonatomic, retain) NSString * msg_id;
@property (nonatomic, retain) NSNumber * pub_date;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) QY_feed *feed;

- (instancetype)initWithDictionary:(NSDictionary *)alertMsgDic ;
+ (NSSet *)messageWithDicArray:(NSArray *)dicArray ;

@end
