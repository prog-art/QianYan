//
//  QY_CamDataFactor.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRMvalue.h"

@interface QY_CamDataFactor : NSObject

#pragma mark - 相机参数配置

/**
 *  1.图像质量
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageQuality:(NSUInteger)quality ;

/**
 *  2.图像亮度
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageBritness:(NSUInteger)quality ;

/**
 *  3.图像对比度
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageContrast:(NSUInteger)quality ;

/**
 *  4.图片饱和度
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageSaturation:(NSUInteger)quality ;

/**
 *  5.图片色调
 *
 *  @param quality (0--100)
 */
+ (NSData *)getCamDataOfImageChroma:(NSUInteger)quality ;

/**
 *  6.码流类型
 *
 *  @param type (0--1) 0:主码流 1:次码流
 */
+ (NSData *)getCamDataOfCodeStreamType:(NSUInteger)type ;

/**
 *  7.分辨率
 *
 *  @param type  (1,4,6,7,16)
 *  @param type2 8中的码流
 */
+ (NSData *)getCamDataOfResolution:(NSUInteger)type withCodeStreamType:(NSUInteger)type2 ;

/**
 *  8.相机码率上限
 *
 *  @param upper (32-4096)
 */
+ (NSData *)getCamDataOfCodeRateUpper:(NSUInteger)upper ;

@end
