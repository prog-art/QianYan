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
    
#pragma mark - Network connective 

#pragma mark - User Operation
    
    USER_DID_NOT_LOGIN = 5 ,//用户未登录
    
    REGISTE_ERROR_USERNAME_EXISTED = 10 ,//用户名已经存在
    
    Login_Error_Username_Or_Password = 20,//用户名或密码出错
    
    
    
    FILEURL_ERROR = 101 ,//提供的文件URL出错
    
#pragma mark - JPRO 
    
    JPRO_UPLOAD_PROFILE_ERROR = 110 ,//上传PROFILE的时候出错
    JPRO_DOWNLOAD_PROFILE_ERROR = 111 ,//下载PROFILE的时候出错
    
#pragma makr - JRM
    
    JRM_DO_NOT_CONNECTED = 200,//JRM服务器未连接
    JRM_GET_USER_JPRO_ERROR = 210,//获取User Jpro信息出错
    JRM_GET_USERID_BY_ID_ERROR ,//获取UserId出错
    
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
