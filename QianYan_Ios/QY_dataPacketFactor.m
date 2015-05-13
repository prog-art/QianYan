//
//  QY_MessageFactor.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_dataPacketFactor.h"

#import "QY_jclient_jrm_protocol_Marco.h"

#import "QY_Common.h"

#import "NSString+QY_dataFormat.h"
#import "NSData+QY_dataFormat.h"

@implementation QY_dataPacketFactor
#pragma mark - public method
//2.1.1 设备登录
+ (NSData *)getDeviceLoginData {
    NSMutableData *packetData ;
    
    NSData *lenData ;
    NSData *cmdData ;
    NSMutableData *valueData ;
    
    //len
    NSUInteger len = JRM_DATA_CMD_Len + 4 ;
    lenData = [self formatLenData:len] ;
    //cmd
    JOSEPH_COMMAND cmd = LOGIN2JRM_REQUEST_CMD ;
    cmdData = [self formatCmdData:cmd] ;
    //value
    valueData = [NSMutableData data] ;
    NSData *valueData1 = [self formatValueDataFromNormalInteger:JOSEPH_DEVICE_JCLIENT ToLength:4] ;
    [valueData appendData:valueData1] ;
    
    //format
    packetData = [NSMutableData data] ;
    [packetData appendData:lenData] ;
    [packetData appendData:cmdData] ;
    [packetData appendData:valueData] ;
    return packetData;
}

//2.5.1 用户注册
+ (NSData *)getUserRegisteDataWithUserName:(NSString *)username password:(NSString *)password {
    NSMutableData *packetData ;
    
    NSData *lenData ;
    NSData *cmdData ;
    NSMutableData *valueData ;
    
    //len
    NSUInteger len = JRM_DATA_CMD_Len + 16 + 32 ;
    lenData = [self formatLenData:len] ;
    //cmd
    JOSEPH_COMMAND cmd = JCLIENT_REG_NEW_USER ;
    cmdData = [self formatCmdData:cmd] ;
    //value
    valueData = [NSMutableData data] ;
    
    NSData *usernameData = [self formatBackZeroValueDataFromNormalString:username ToLength:16] ;
    [valueData appendData:usernameData] ;
    NSData *passwordData = [self formatBackZeroValueDataFromNormalString:password ToLength:32] ;
    [valueData appendData:passwordData] ;
    
    //format
    packetData = [NSMutableData data] ;
    [packetData appendData:lenData] ;
    [packetData appendData:cmdData] ;
    [packetData appendData:valueData] ;
    return packetData;
}

//2.5.2 用户登录
+ (NSData *)getUserLoginDataWithUserName:(NSString *)username password:(NSString *)password {
    NSMutableData *packetData ;
    
    NSData *lenData ;
    NSData *cmdData ;
    NSMutableData *valueData ;
    
    //len
    NSUInteger len = JRM_DATA_CMD_Len + 16 + 32 ;
    lenData = [self formatLenData:len] ;
    //cmd
    JOSEPH_COMMAND cmd = DEVICE_LOGIN2JRM_CMD ;
    cmdData = [self formatCmdData:cmd] ;
    //value
    valueData = [NSMutableData data] ;
    NSData *usernameData = [self formatBackZeroValueDataFromNormalString:username ToLength:16] ;
    [valueData appendData:usernameData] ;
    NSData *passwordData = [self formatBackZeroValueDataFromNormalString:password ToLength:32] ;
    [valueData appendData:passwordData] ;
    
    //format
    packetData = [NSMutableData data] ;
    [packetData appendData:lenData] ;
    [packetData appendData:cmdData] ;
    [packetData appendData:valueData] ;
    return packetData;
}

#pragma mark - format data method

+ (NSData *)formatLenData:(NSUInteger)len {
    return [self formatValueDataFromNormalInteger:len ToLength:JRM_DATA_LENGTH_Len] ;
}

+ (NSData *)formatCmdData:(JOSEPH_COMMAND)cmd {
    return [self formatValueDataFromNormalInteger:cmd ToLength:JRM_DATA_CMD_Len] ;
}

+ (NSData *)formatValueDataFromNormalString:(NSString *)string ToLength:(NSUInteger)len {
    NSData *valueData = [string QY_NormalStrToHexBytes] ;
    valueData = [NSData QY_FillZero:valueData ToLen:len] ;
    return valueData ;
}

+ (NSData *)formatValueDataFromNormalInteger:(NSInteger)integer ToLength:(NSUInteger)len {
    NSData *valueData ;
    NSString *valueStr = [NSString QY_UInteger2HexString:integer] ;
    NSData *tempValueData = [valueStr QY_HexStrToHexBytes] ;
    valueData = [NSData QY_FillZero:tempValueData ToLen:len] ;
    return valueData ;
}

+ (NSData *)formatBackZeroValueDataFromNormalString:(NSString *)string ToLength:(NSUInteger)len {
    NSData *valueData = [string QY_NormalStrToHexBytes] ;
    valueData = [NSData QY_FillZeroAtBack:valueData ToLen:len];
    return valueData ;
}

+ (NSData *)formatBackZeroValueDataFromNormalInteger:(NSInteger)integer ToLength:(NSUInteger)len {
    NSData *valueData ;
    NSString *valueStr = [NSString QY_UInteger2HexString:integer] ;
    NSData *tempValueData = [valueStr QY_HexStrToHexBytes] ;
    valueData = [NSData QY_FillZeroAtBack:tempValueData ToLen:len] ;
    return valueData ;
}

@end