//
//  QY_AddressBook.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QY_AddressBook : NSObject

@property NSInteger sectionNumber ;
@property NSInteger recordId ;
@property (nonatomic , retain) NSString *name ;
@property (nonatomic , retain) NSString *email ;
@property (nonatomic , retain) NSString *tel ;

/**
 *  千衍的用户系统id，如果有就是添加好友，否则发送短信。
 */
@property (nonatomic , retain) NSString *qy_userId ;

@end
