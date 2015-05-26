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

@end
