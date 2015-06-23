//
//  QY_QRCodeUtils.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_QRCodeUtils.h"

#import "QRCodeGenerator.h"
#import "QRCodeReaderViewController.h"
#import "QY_QRCodeReaderDelegater.h"

#import "QY_jclient_jrm_protocol_Marco.h"

#import "QYUtils.h"

const NSString *kQYIOS_deviceType = @"30" ;
//[NSString stringWithFormat:@"%ld",(long)JOSEPH_DEVICE_JCLIENT] ;

const NSInteger kQRStrLenFieldLen = 2 ;
const CGFloat kQRImageSize = 300 ;

const JOSEPH_DEVICE_TYPE device_type = JOSEPH_DEVICE_JCLIENT ;//30
const JOSEPH_DEVICE_TYPE debug_device_type = JOSEPH_DEVICE_JCLIENT_NANJING_2 ;//722

#warning 测试用722类型，正式更换为device_type
#define TargetDeviceType debug_device_type

@implementation QY_QRCodeUtils

+ (UIImage *)QY_generateQRImageOfWifiWithESSID:(NSString *)ESSID Password:(NSString *)password UserId:(NSString *)userId {
    static NSString *operationTyep = @"NJQY" ;
    
    NSArray *array = @[operationTyep ,
                       [self getFormatLenStr:ESSID.length] ,
                       [self getFormatLenStr:password.length] ,
                       [self getFormatLenStr:userId.length] ,
                       [self getFormatLenStr:@"".length],
                       ESSID ,
                       password ,
                       userId ,
                       @""] ;
    
    NSString *qrStr = [array componentsJoinedByString:@""] ;
    UIImage *qrImage = [QRCodeGenerator qrImageForString:qrStr imageSize:kQRImageSize] ;
    
    return qrImage ;
}

//+ (UIImage *)QY_generateQRImageOfBindingCameraWithCameraId:(NSString *)cameraId Password:(NSString *)password {
//    static NSString *operationTyep = @"ENTRYID" ;
//    
//    NSString *deviceType = [NSString stringWithFormat:@"%ld",(long)TargetDeviceType] ;
//    
//    NSArray *array = @[operationTyep ,
//                       [self getFormatLenStr:cameraId.length] ,
//                       [self getFormatLenStr:password.length] ,
//                       [self getFormatLenStr:deviceType.length] ,
//                       [self getFormatLenStr:@"".length] ,
//                       cameraId ,
//                       password ,
//                       deviceType ,
//                       @""] ;
//    
//    NSString *qrStr = [array componentsJoinedByString:@""] ;
//    UIImage *qrImage = [QRCodeGenerator qrImageForString:qrStr imageSize:kQRImageSize] ;
//    
//    return qrImage ;
//}

+ (UIImage *)QY_generateQRImageOfPersonalCardWithUserId:(NSString *)userId {
    static NSString *operationTyep = @"QYUSER" ;
    NSString *deviceType = [NSString stringWithFormat:@"%ld",(long)TargetDeviceType] ;
    
    NSArray *array = @[operationTyep ,
                       [self getFormatLenStr:userId.length] ,
                       [self getFormatLenStr:deviceType.length] ,
                       [self getFormatLenStr:@"".length] ,
                       userId ,
                       deviceType ,
                       @""] ;
    
    NSString *qrStr = [array componentsJoinedByString:@""] ;
    UIImage *qrImage = [QRCodeGenerator qrImageForString:qrStr imageSize:kQRImageSize] ;
    
    return qrImage ;
}

#pragma mark - scan QRCode

/**
 *  Strong 持有对象，结束生命周期后销毁。
 */
QY_QRCodeReaderDelegater *delegateHolder ;

QY_QRCodeReaderDelegater *tempHolder ;

+ (void)startWithDelegater:(UIViewController<QY_QRCodeScanerDelegate> *)delegater {
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new] ;
    reader.hidesBottomBarWhenPushed = YES ;
    reader.modalPresentationStyle = UIModalPresentationFormSheet ;
    delegateHolder = [[QY_QRCodeReaderDelegater alloc] initWithDelegate:delegater] ;
    reader.delegate = delegateHolder ;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        tempHolder = delegateHolder ;
        delegateHolder = nil ;
        [QYUtils runAfterSecs:0.5 block:^{
            QYDebugLog(@"delegate 销毁～")
            tempHolder = nil ;
        }] ;
    }];
    
    [delegater.navigationController pushViewController:reader animated:YES] ;
}

#pragma mark - private method (data format)

/**
 *  用于协议中第二部分，数据长度
 *  例: 3 --> @"03" 和 15 --> @"15"
 *
 *  @param len 长度
 *
 *  @return 格式化好的字符串
 */
+ (NSString *)getFormatLenStr:(NSUInteger)len {
    return [NSString stringWithFormat:@"%02tu",len] ;
}

@end
