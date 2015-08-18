//
//  QY_CamDataFactor.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_CamDataFactor.h"

#import "QY_Image_configure_cmd.h"
#import "QY_jms_marco.h"
#import "QY_jms_parameter_key_marco.h"
#import "JRMDataFormatUtils.h"

@implementation QY_CamDataFactor

+ (NSData *)getCamDataOfCmd:(NSUInteger)cmd {
    NSMutableData *camData = [NSMutableData data] ;
    {
        NSData *cam_lengthData = [JRMDataFormatUtils formatIntegerValueData:(JMS_DATA_LEN_OF_KEY_CMD )
                                                                      toLen:JMS_DATA_LEN_OF_KEY_CAMDATA_LENGTH] ;
        NSData *cam_cmdData = [JRMDataFormatUtils formatIntegerValueData:cmd toLen:JMS_DATA_LEN_OF_KEY_CMD] ;
        [@[cam_lengthData,cam_cmdData] enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
            [camData appendData:data] ;
        }] ;
    }
    
    return camData ;
}

+ (NSData *)getCamDataOfCmd:(NSUInteger)cmd param:(NSUInteger)param {
    NSMutableData *camData = [NSMutableData data] ;
    {
        NSData *cam_lengthData = [JRMDataFormatUtils formatIntegerValueData:(JMS_DATA_LEN_OF_KEY_CMD + JMS_DATA_LEN_OF_KEY_CAMDATA_DATA)
                                                                      toLen:JMS_DATA_LEN_OF_KEY_CAMDATA_LENGTH] ;
        NSData *cam_cmdData = [JRMDataFormatUtils formatIntegerValueData:cmd toLen:JMS_DATA_LEN_OF_KEY_CMD] ;
        NSData *cam_data = [JRMDataFormatUtils formatIntegerValueData:param toLen:2] ;
        [@[cam_lengthData,cam_cmdData,cam_data] enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
            [camData appendData:data] ;
        }] ;
    }
    return camData ;
}

#pragma mark - 相机参数配置

/**
 *  1.图像质量
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageQuality:(NSUInteger)quality {
    assert(0 <= quality <= 100) ;
    return [self getCamDataOfCmd:IMAGE_QUALITY_CONF param:quality] ;
}

/**
 *  2.图像亮度
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageBritness:(NSUInteger)quality {
    assert(0 <= quality <= 100) ;
    return [self getCamDataOfCmd:IMAGE_BRITNESS_CONF param:quality] ;
}

/**
 *  3.图像对比度
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageContrast:(NSUInteger)quality {
    assert(0 <= quality <= 100) ;
    return [self getCamDataOfCmd:IMAGE_CONTRAST_CONF param:quality] ;
}

/**
 *  4.图片饱和度
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageSaturation:(NSUInteger)quality {
    assert(0 <= quality <= 100) ;
    return [self getCamDataOfCmd:IMAGE_SATURATION_CONF param:quality] ;
}

/**
 *  5.图片色调
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageChroma:(NSUInteger)quality {
    assert(0 <= quality <= 100) ;
    return [self getCamDataOfCmd:IMAGE_CHROMA_CONF param:quality] ;
}

/**
 *  6.码流类型
 *
 *  @param type (0--1) 0:主码流 1:次码流
 */
+ (NSData *)getCamDataOfCodeStreamType:(NSUInteger)type {
    assert(0 <= type <= 1) ;
    return [self getCamDataOfCmd:CODE_STREAM_TYPE_CONF param:type] ;
}

/**
 *  7.分辨率
 *
 *  @param type  (1,4,6,7,16)
 *  @param type2 8中的码流
 */
+ (NSData *)getCamDataOfResolution:(NSUInteger)type withCodeStreamType:(NSUInteger)type2 {
    assert(0 <= type2 <= 1) ;
    return [self getCamDataOfCmd:RESOLUTION_CONF param:type] ;
}

/**
 *  8.相机码率上限
 *
 *  @param upper (32-4096)
 */
+ (NSData *)getCamDataOfCodeRateUpper:(NSUInteger)upper {
    assert(32 <= upper <= 4096) ;
    return [self getCamDataOfCmd:CODE_RATE_UPPER_CONF param:upper] ;
}

@end
