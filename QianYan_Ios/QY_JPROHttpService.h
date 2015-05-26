//
//  QY_JPROHttpService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <AFNetworking/AFNetworking.h>
//success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure

typedef void(^QY_AFSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) ;
typedef void(^QY_AFFailBlock)(AFHTTPRequestOperation *operation, NSError *error) ;


@interface QY_JPROHttpService : NSObject

+ (void)downLoadTest ;

+ (void)uploadTest ;

@end