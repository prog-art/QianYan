//
//  QY_UserReloginDescriptor.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QY_UserReloginDescriptor : NSObject

@property (nonatomic) NSString *username ;
@property (nonatomic) NSString *password ;
@property (nonatomic) BOOL shouldReLogin ;

@end