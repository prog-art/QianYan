//
//  QY_JMSService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_Block_Define.h"


#define CameraLedStateKey @"LED"
#define CameraResolutionKey @"RESOLUTION"
#define CameraMoveTriggerKey @"MOVETRIGGER"
#define CameraBritnessKey @"BRITNESS"
#define CameraContrastKey @"CONTRAST"
#define CameraSpeakerKey @"SPEAKER"
#define CameraSpeakerVolumeKey @"SPEAKERVOLUME"
#define CameraMicrophoneKey @"MICROPHONE"
#define CameraMicrophoneVolumeKey @"MICROPHONEVOLUME"
#define CameraImageQualityKey @"IMAGEQUALITY"
#define CameraCodeRateUpperKey @"CODERATEUPPER"

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

#pragma mark - JMS 相机

/**
 *  读取配置
 *
 *  @param cameraId    <#cameraId description#>
 *  @param complection <#complection description#>
 */
- (void)getCameraConfigParameterById:(NSString *)cameraId complection:(QYInfoBlock)complection ;

/**
 *  配置相机图片质量
 *
 *  @param cameraId    <#cameraId description#>
 *  @param quality     1-100
 *  @param complection <#complection description#>
 */
- (void)configImageQualityForCameraId:(NSString *)cameraId quality:(NSUInteger)quality complection:(QYInfoBlock)complection ;

- (void)configCameraId:(NSString *)cameraId MoveTriggerToState:(BOOL)open complection:(QYResultBlock)complection ;

- (void)restartCameraId:(NSString *)cameraId complection:(QYResultBlock)complection ;

@end
