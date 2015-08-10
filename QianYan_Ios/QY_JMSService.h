//
//  QY_JMSService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_Block_Define.h"

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

/**
 *  获取相机状态
 *
 *  @param cameraIds   相机的Id
 *  @param complection 回调返回相机的状态
 */
- (void)getCamerasStateByIds:(NSSet *)cameraIds complection:(QYArrayBlock)complection ;

/**
 *  获取相机实时的缩略图
 *
 *  @param cameraId    相机的Id
 *  @param complection 回调返回相机缩略图的NSData。
 */
- (void)getCameraThumbnailById:(NSString *)cameraId complection:(QYObjectBlock)complection ;

#pragma mark - JMS UDP

/**
 *  开始无限7秒发送心跳包
 */
- (void)startSendHeartBeatMessage ;

/**
 *  停止发送［离线］
 */
- (void)stopSendHeartBeatMessage ;

/**
 *  是否正在发送心跳包
 */
- (BOOL)isSendingHeartBeatMessage ;

@end
