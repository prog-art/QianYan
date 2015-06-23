//
//  NSError+QYError.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "NSError+QYError.h"




@implementation NSError (QYError)

+ (instancetype)QYErrorWithCode:(QianYan_ErrorCode)code userInfo:(NSDictionary *)dict {
    return [NSError errorWithDomain:QYErrorDoMain code:code userInfo:dict] ;
}

+ (instancetype)QYErrorWithCode:(QianYan_ErrorCode)code description:(NSString *)desc {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:desc} ;
    return [self QYErrorWithCode:code userInfo:userInfo] ;
}

#pragma mark -

+ (NSString *)QYErrorCodeDescription:(QianYan_ErrorCode)errorCode {
    NSString *desc = @"" ;
    switch ( errorCode ) {
        case API2529_Para_Error :
            desc = @"绑定参数出错" ;
            break;
        case API2529_Binding_Error :
            desc = @"绑定出错" ;
            break ;
        case API2529_Camera_IS_Been_Bindinged :
            desc = @"相机已经绑定给其他用户" ;
            break ;
        default:
            break;
    }
    
    return desc ;
}

@end
