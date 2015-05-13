//
//  QY_JRMDataPharser.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMDataPharser.h"

#import "QYUtils.h"

#import "NSString+QY_dataFormat.h"
#import "NSData+QY_dataFormat.h"

@implementation QY_JRMDataPharser

+(QY_JRMDataPacket *)pharseDataWithData:(NSData *)data Tag:(JRM_REQUEST_OPERATION_TYPE)tag {
    QYDebugLog() ;
    QY_JRMDataPacket *resPacket ;
    
    switch (tag) {
        case JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN:
            resPacket = [self packetFromDeviceLoginResponse:data] ;
            break ;
        case JRM_REQUEST_OPERATION_TYPE_USER_REGISTE:
            resPacket = [self packetFromUserRegisteResponse:data] ;
            break ;
        case JRM_REQUEST_OPERATION_TYPE_USER_LOGIN:
            resPacket = [self packetFromUserLoginResponse:data] ;
            break ;
        default:
            resPacket = nil ;
            [QYUtils alert:[NSString stringWithFormat:@"未知的服务器操作类型%ld",tag]] ;
            break;
    }
    return resPacket ;
}

#pragma mark - 数据解析器(method)

NSUInteger api211SuccessDataLen = JRM_DATA_LENGTH_Len + JRM_DATA_CMD_Len ;
/**
 *  2.1.1  设备登陆返回数据解析
 *  成功：LOGIN2JRM_REPLY_CMD(=41)
 *  失败：断开JRMSocket连接
 *
 *  @param responseData 服务器返回data
 *
 *  @return 解析好的 QY_JRMDataPacket 数据模型。
 */
+(QY_JRMDataPacket *)packetFromDeviceLoginResponse:(NSData *)responseData {
    if ( responseData.length != api211SuccessDataLen ) {
        QYDebugLog(@"211 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"设别登录 data = %@",responseData) ;
    QY_JRMDataPacket *resPacket = [[QY_JRMDataPacket alloc] init];
    
    resPacket.length = [self getLen:responseData] ;
    resPacket.cmd = [self getCmd:responseData] ;
    
    return resPacket ;
}


NSUInteger api251SuccessDataLen = JRM_DATA_LENGTH_Len + JRM_DATA_CMD_Len + 16 ;
NSUInteger api251FailedDataLen = JRM_DATA_LENGTH_Len + JRM_DATA_CMD_Len ;
/**
 *  2.5.1 用户注册返回数据解析
 *
 *  @param responseData 服务器返回data
 *
 *  @return 解析好的 QY_JRMDataPacket 数据模型。
 */
+(QY_JRMDataPacket *)packetFromUserRegisteResponse:(NSData *)responseData {
    if ( responseData.length != api251FailedDataLen && responseData.length !=api251SuccessDataLen) {
        QYDebugLog(@"251 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"用户注册 data = %@",responseData) ;//data = <00140000 019d3130 30303031 33300000 00000000 0000>
    QY_JRMDataPacket *resPacket = [[QY_JRMDataPacket alloc] init];
    
    resPacket.length = [self getLen:responseData] ;
    resPacket.cmd = [self getCmd:responseData] ;
    
    if ( responseData.length == api251SuccessDataLen ) {
#warning 取userId
        QYDebugLog(@"test!") ;
    }
    
    return resPacket ;
}

NSUInteger api252FullDataLen = JRM_DATA_LENGTH_Len + JRM_DATA_CMD_Len ;
/**
 *  2.5.2  用户登录返回数据解析
 *
 *  @param responseData 服务器返回data
 *
 *  @return 解析好的 QY_JRMDataPacket 数据模型。
 */
+(QY_JRMDataPacket *)packetFromUserLoginResponse:(NSData *)responseData {
    if ( responseData.length != api252FullDataLen ) {
        QYDebugLog(@"252 接口 接受数据不完整") ;
        return nil ;
    }
    
    QYDebugLog(@"用户登录 data = %@",responseData) ;//data = <00040000 ffdd>
    QY_JRMDataPacket *resPacket = [[QY_JRMDataPacket alloc] init] ;
    
    resPacket.length = [self getLen:responseData] ;
    resPacket.cmd = [self getCmd:responseData] ;

    return resPacket ;
}








#pragma mark - 数据解析方法(QY应用层协议)

+ (NSUInteger)getLen:(NSData *)data {
    return [self getIngeterValue:data range:NSMakeRange(0, JRM_DATA_LENGTH_Len)] ;
}

+ (JOSEPH_COMMAND)getCmd:(NSData *)data {
    JOSEPH_COMMAND res = [self getIngeterValue:data range:NSMakeRange(JRM_DATA_LENGTH_Len, JRM_DATA_CMD_Len)] ;
    return res ;
}

+ (NSString *)getStringValue:(NSData *)data range:(NSRange)range {
    NSString *resStr = @"" ;
    
    NSData *valueData = [data subdataWithRange:range] ;
    valueData = [NSData QY_FilterPrefixZero:valueData] ;
    resStr = [NSData QY_NSData2NSString:valueData] ;
    
    return resStr ;
}

+ (NSInteger)getIngeterValue:(NSData *)data range:(NSRange)range {
    NSInteger res = 0 ;
    
    NSData *valueData = [data subdataWithRange:range] ;
    
    Byte *dataByte = (Byte *)[valueData bytes] ;
    
    for ( int i = 0 ; i < range.length ; i++) {
        Byte tempB = dataByte[i] ;
        NSUInteger tempI = (NSUInteger)tempB ;
        res = res * 16 * 16 + tempI ;
    }
    
    return res ;
}

@end
