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
    
    RegisteStep1_Error = 11 ,//注册第一步出错，registe to jrm出错。
    RegisteStep2_Error = 12 ,//注册第二步出错，获取JPRO服务器信息出错。
    RegisteStep3_Error = 13 ,//注册第三步出错，upload profile.xml出错。
    RegisteStep4_Error = 14 ,//注册第四部出错，移动和重命名temp.xml --> profile.xml
    
    LoginStep1_Error = 21 ,//登录第一步出错，网络原因。
    LoginStep2_Error = 22 ,//登录第二步出错，get userId by username出错［获取UserId失败，请检查网络或联系系统管理员。］
    LoginStep3_Error = 23 ,//登录第三步出错，get user jpro information出错
    LoginStep4_Error = 24 ,//登录第四步出错，get user profile.xml出错
    
    FILEURL_ERROR = 101 ,//提供的文件URL出错
    
    JRM_DO_NOT_CONNECTED = 200,//JRM服务器未连接
    
    JDAS_GET_JRM_ADDRESS_ERROR = 300,//JDAS寻址出错
    JRM_USER_RELOGIN2JRM_ERROR = 301,//用户重新登录JRM错误
} ;

#pragma mark -

@interface NSError (QYError)

+ (instancetype)QYErrorWithCode:(QianYan_ErrorCode)code userInfo:(NSDictionary *)dict ;

+ (instancetype)QYErrorWithCode:(QianYan_ErrorCode)code description:(NSString *)desc ;

#pragma mark -

+ (NSString *)QYErrorCodeDescription:(QianYan_ErrorCode)errorCode ;

@end
