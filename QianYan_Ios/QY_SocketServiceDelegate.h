//
//  QY_test.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_UserReloginDescriptor.h"

@protocol QY_SocketServiceDelegate <NSObject>

@required

/**
 *  返回一个QY_UserDescriptor描述是否需要重新登录
 *
 *  @return
 */
- (QY_UserReloginDescriptor *)shouldReLoginUserToJRM ;

@end