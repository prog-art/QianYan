//
//  QY_JMSService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_Block_Define.h"

extern NSString *const kNotificationNameReceiveCamerasState ;

@interface QY_JMSService : NSObject

+ (instancetype)shareInstance ;

@property (nonatomic,readonly) NSString *jms_ip ;
@property (nonatomic,readonly) NSString *jms_port ;
/**
 *  登陆jms后台的device_id ios客户端为user_id，校验码key是:"hello"
 */
@property (nonatomic,readonly) NSString *device_id ;

- (void)configIp:(NSString *)ip Port:(NSString *)port ;

#pragma mark - JMS 请求



#pragma mark - test

- (void)getCameraStateById:(NSString *)cameraId ;

- (void)getCamerasStateByIds:(NSSet *)cameraIds ;

- (void)getCameraThumbnailById:(NSString *)cameraId ;

@end
