//
//  QY_QRCodeScanerDelegate.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  dependency -> QRCodeReaderDelegate
 *
 *  调用扫描二维码的时候，用于接收结果通知。
 */
@protocol QY_QRCodeScanerDelegate <NSObject>

@optional

/**
 *  成功扫描二维码
 *
 *  @param resultStr 结果字符串
 */
- (void)QY_didScanQRCode:(NSString *)resultStr ;

/**
 *  取消扫描二维码
 */
- (void)QY_didCancelQRCodeScan ;


@end

