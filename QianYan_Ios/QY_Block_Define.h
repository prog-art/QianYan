//
//  QY_Block_Define.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QY_Block_Define_h
#define QianYan_Ios_QY_Block_Define_h

@class QYUser ;
@class QY_JRMResponse ;

typedef void (^QYBlock)() ;
typedef void (^QYHostPortBlock)(NSString *hostName , NSUInteger port) ;
typedef void (^QYBooleanBlock)(BOOL Successed , NSError *error) ;
typedef void (^Int64Block)(int64_t num) ;
typedef void (^QYUserBlock)(QYUser *registedUser , NSError *error) ;
typedef void (^QYResultBlock)(BOOL success , NSError *error) ;
typedef void (^QYJRMResponseBlock)(QY_JRMResponse *response ,NSError *error);
typedef void (^QYArrayBlock)(NSArray *objects,NSError *error) ;
typedef void (^QYObjectBlock)(id object,NSError *error);
typedef void (^QYInfoBlock)(NSDictionary *info,NSError *error);

#endif
