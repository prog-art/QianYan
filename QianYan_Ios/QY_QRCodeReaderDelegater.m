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
    
    QY_QRCodeType option = [self filterQY_qrmessage:result] ;
    
    if ( option != QY_QRCodeType_NULL ) {
        QYDebugLog(@"千衍二维码扫入") ;
        if ( [self.delegate respondsToSelector:@selector(QY_didScanOption:userInfo:)]) {
            NSDictionary *info = [self phraseQY_QRStr:result WithOption:option];
            [self.delegate QY_didScanOption:option userInfo:info] ;
        }

    } else {
        QYDebugLog(@"其他二维码扫入") ;
        if ( [self.delegate respondsToSelector:@selector(QY_didScanQRCode:)]) {
            [self.delegate QY_didScanQRCode:result] ;
        }
    }
    
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    QYDebugLog(@"取消扫描") ;
    if ( [self.delegate respondsToSelector:@selector(QY_didCancelQRCodeScan)]) {
        [self.delegate QY_didCancelQRCodeScan] ;
    }
}

#pragma mark - data phrase 文档中 2、绑定摄像机的二维码 和 3、千衍账户的个人名片

/**
 *  过滤
 *
 *  @param qrStr 扫描出的二维码字符串
 *
 *  @return 过滤结果
 */
- (QY_QRCodeType)filterQY_qrmessage :(NSString *)qrStr {
    static NSString *BindingCamera = @"ENTRYID" ;
    static NSString *PersonalCard = @"QYUSER" ;
    NSArray *prefixs = @[BindingCamera,PersonalCard] ;
    QY_QRCodeType type = QY_QRCodeType_NULL ;
    
    
    for ( int i = 0 ; i < prefixs.count ; i++) {
        NSString *prefix = prefixs[i] ;
        BOOL result = [self checkPrefix:prefix targetString:qrStr] ;
        if ( true == result ) {
            type = i == 0 ? QY_QRCodeType_Binding_Camera : QY_QRCodeType_User ;
            break ;
        }
    }
    return type ;
}

- (NSDictionary *)phraseQY_QRStr:(NSString *)qrStr WithOption:(QY_QRCodeType)option{
    static NSString *BindingCamera = @"ENTRYID" ;
    static NSString *PersonalCard = @"QYUSER" ;
    NSString *prefix = option == QY_QRCodeType_Binding_Camera ? BindingCamera : PersonalCard ;
    if ( ![self checkPrefix:prefix targetString:qrStr] ) {
        QYDebugLog(@"前缀错误") ;
        return nil ;
    }
    
    NSRange range = NSMakeRange(prefix.length, qrStr.length - prefix.length) ;
    NSString *dataStr = [qrStr substringWithRange:range] ;
    
    QYDebugLog(@"前缀通过") ;
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary] ;
    
    NSInteger dataCount = option == QY_QRCodeType_Binding_Camera ? 4 : 3 ;
    [info setObject:@(dataCount) forKey:QY_QRCODE_DATA_NUM_KEY] ;
    NSDictionary *data = [self phraseDataStr:dataStr WithDataCount:dataCount] ;
    [info setObject:data forKeyedSubscript:QY_QRCODE_DATA_DIC_KEY] ;

    return info ;
}

/**
 *  _2_2_2_2_Data1_data2_data3_data4 解析
 */
- (NSDictionary *)phraseDataStr:(NSString *)dataStr WithDataCount:(NSInteger)dataCount {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary] ;
    
    NSInteger dataLoc = 2 * dataCount ;
    for ( NSInteger i = 0 ; i < dataCount ; i++ ) {
        NSRange range = NSMakeRange( 2 * i , 2) ;
        NSString *lenStr = [dataStr substringWithRange:range] ;
        NSInteger len = [lenStr integerValue] ;
        
        if (len == 0) {
            continue ;
        }
        
        range = NSMakeRange(dataLoc, len) ;
        NSString *data = [dataStr substringWithRange:range] ;
        
        NSString *key = KEY_FOR_DATA_AT_INDEX(i) ;
//        NSString *key = [NSString stringWithFormat:@"data%ld",(long)i] ;
        
        [dataDic setObject:data forKey:key] ;
        
        dataLoc += len ;
    }
    
    return dataDic ;
}

/**
 *  检查字符串前缀
 *
 *  @param prefix       前缀字符串
 *  @param targetString 目标字符串
 *
 *  @return 是否有前缀
 */
- (BOOL)checkPrefix:(NSString *)prefix targetString:(NSString *)targetString {
    NSRange range = NSMakeRange(0, prefix.length) ;
    NSString *subStr = [targetString substringWithRange:range] ;
    if ( [subStr isEqualToString:prefix] ) return TRUE ;
    return FALSE ;
}

@end