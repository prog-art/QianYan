//
//  QY_tempHttpService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/5.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_Block_Define.h"

#import "QY_JPRO.h"

#import "QY_jpro_http_protocol.h"

@interface QY_JPROHttpService : NSObject<QY_jpro_http_protocol>

+ (instancetype)shareInstance ;

@property (nonatomic,readonly) NSString *jpro_ip ;
@property (nonatomic,readonly) NSString *jpro_port ;

- (void)configIp:(NSString *)jpro_ip Port:(NSString *)jpro_port ;

@end
