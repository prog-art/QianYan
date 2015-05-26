//
//  NSError+QYError.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QYErrorDoMain @"com.QianYan.QianYan_ios.ErrorDomain"

typedef NS_ENUM(NSInteger, QianYan_ErrorCode) {
    API2529_Para_Error               = 1 ,//参数错误
    API2529_Binding_Error            = 2 ,//绑定出错
    API2529_Camera_IS_Been_Bindinged = 3 ,//相机已经被绑定了
    
    RegisteStep1_Error = 11 ,//注册第一步出错，网络原因。
    RegisteStep2_Error = 12 ,//注册第二步出错，获取JPRO服务器信息出错。
    RegisteStep3_Error = 13 ,//注册第三部，创建temp.xml时出错
} ;

#pragma mark -

@interface NSError (QYError)

+ (instancetype)QYErrorWithCode:(QianYan_ErrorCode)code userInfo:(NSDictionary *)dict ;

+ (instancetype)QYErrorWithCode:(QianYan_ErrorCode)code description:(NSString *)desc ;

@end
