//
//  QY_AddressBook.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QY_Contact : NSObject

@property NSInteger sectionNumber ;
/**
 *  在联系人列表里的recordId
 */
@property NSInteger recordId ;

/**
 *  联系人姓名 @"张睿"
 */
@property (nonatomic , retain) NSString *name ;

/**
 *  邮箱 @"- -"
 */
@property (nonatomic , retain) NSString *email ;
/**
 *  电话号码 @"18817870386"
 */
@property (nonatomic , retain) NSString *tel ;

/**
 *  千衍的用户系统id，如果有就是添加好友，否则发送短信。
 */
@property (nonatomic , retain) NSString *qy_userId ;

@end
