//
//  QY_QRCodeReaderDelegater.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/15.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_QRCodeReaderDelegater.h"

#import "QY_CommonDefine.h"

@implementation QY_QRCodeReaderDelegater

#pragma mark - Life cycle 

- (instancetype)initWithDelegate:(id<QY_QRCodeScanerDelegate>)delegate {
    if ( self = [self init]) {
        self.delegate = delegate ;
    }
    return self ;
}

#pragma mark - Listening for Reader Status

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    QYDebugLog(@"成功扫描 结果%@",result) ;
    
    if ( [self filterQY_qrmessage:result] ) {
        QYDebugLog(@"千衍二维码扫入") ;
    } else {
        QYDebugLog(@"其他二维码扫入") ;
    }
    
    if ( [self.delegate respondsToSelector:@selector(QY_didScanQRCode:)]) {
        [self.delegate QY_didScanQRCode:result] ;
    }
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    QYDebugLog(@"取消扫描") ;
    if ( [self.delegate respondsToSelector:@selector(QY_didCancelQRCodeScan)]) {
        [self.delegate QY_didCancelQRCodeScan] ;
    }
}

#pragma mark - data phrase 文档中 2、绑定摄像机的二维码 和 3、千衍账户的个人名片

- (BOOL)filterQY_qrmessage :(NSString *)qrStr {
    static NSString *BindingCamera = @"ENTRYID" ;
    static NSString *PersonalCard = @"QYUSER" ;
    NSArray *array = @[BindingCamera,PersonalCard] ;
    
    for ( NSString *str in array ) {
        NSRange range = NSMakeRange(0, str.length) ;
        NSString *subStr = [qrStr substringWithRange:range] ;
        if ( [subStr isEqualToString:str] ) {
            return TRUE ;
        }
    }
    return FALSE;
}

@end
