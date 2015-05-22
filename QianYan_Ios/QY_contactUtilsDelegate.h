//
//  QY_contactUtilsDelegate.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QY_contactUtilsDelegate <NSObject>

/**
 *  获取Contacts结果
 *
 *  @param success  成功还是失败
 *  @param contacts NSArray<QY_AddressBook>
 */
- (void)didReceiveContactsSuccess:(BOOL)success Contacts:(NSArray *)contacts ;

@end
