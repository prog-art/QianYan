//
//  QY_QRCodeUtils.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "QY_QRCodeScanerDelegate.h"

/**
 *  1.提供生成二维码的功能。
 *  2.提供唤起二维码扫描组件的功能。
 */
@interface QY_QRCodeUtils : NSObject

#pragma mark - generate QRCode Image

/**
 *  1.生成摄像头连接wifi绑定用户的二维码
 *
 *  @param ESSID    WIFI的ESSID
 *  @param password WIFI密码
 *  @param userId   千衍用户ID
 *
 *  @return 二维码图片
 */
+ (UIImage *)QY_generateQRImageOfWifiWithESSID:(NSString *)ESSID Password:(NSString *)password UserId:(NSString *)userId;

///**
// *  2.生成绑定摄像头的二维码
// *  [Note]:客户端预留方法，估计不会使用。
// *
// *  @param cameraId 摄像头的Id
// *  @param password 摄像头的密码
// *
// *  @return 二维码图片
// */
//+ (UIImage *)QY_generateQRImageOfBindingCameraWithCameraId:(NSString *)cameraId Password:(NSString *)password ;

/**
 *  3.生成千衍账户的个人名片
 *
 *  @param userId 用户Id
 *
 *  @return 二维码图片
 */
+ (UIImage *)QY_generateQRImageOfPersonalCardWithUserId:(NSString *)userId ;

#pragma mark - scan QRCode 

/**
 *  唤起QRCodeScaner
 *
 *  @param sender 扫描结果结果接收者
 */
+ (void)startWithDelegater:(UIViewController<QY_QRCodeScanerDelegate> *)delegater ;

@end
