//
//  QY_QRCodeScanerDelegate.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QY_QRCodeType) {
    QY_QRCodeType_NULL = 0 ,//不是二维码协议中的类型
    //    QY_QRCodeType_WIFI = 1 ,//联网逻辑
    QY_QRCodeType_Binding_Camera = 2 ,//绑定二维码
    QY_QRCodeType_User = 3 ,//用户名片
} ;

#define QY_QRCODE_DATA_NUM_KEY @"numberOfData"
#define QY_QRCODE_DATA_DIC_KEY @"dictionaryOfData"
#define KEY_FOR_DATA_AT_INDEX(INDEX) [NSString stringWithFormat:@"data%ld",(long)INDEX]

/**
 *  dependency -> QRCodeReaderDelegate
 *
 *  调用扫描二维码的时候，用于接收结果通知。
 */
@protocol QY_QRCodeScanerDelegate <NSObject>

@optional

/**
 *  成功扫描二维码，普通字符串
 *
 *  @param resultStr 结果字符串
 */
- (void)QY_didScanQRCode:(NSString *)resultStr ;

/**
 *  取消扫描二维码
 */
- (void)QY_didCancelQRCodeScan ;

/**
 *  扫描到了某种千衍的二维码结构
 *
 *  @param opetion 扫描到的类型
 *  @param info    各种参数
 */
- (void)QY_didScanOption:(QY_QRCodeType)option userInfo:(NSDictionary *)info ;

@end