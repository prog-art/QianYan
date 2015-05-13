//
//  QY_SocketServiceDelegateNotificationCenter.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_SocketServiceDelegateNotificationCenter.h"

#import "QY_JRMDataPharser.h"

@implementation QY_SocketServiceDelegateNotificationCenter

#pragma mark 发送通知QY_SocketServiceDelegate

+ (void)postDelegate:(id<QY_SocketServiceDelegate>)delegate Notification:(JRM_REQUEST_OPERATION_TYPE)operation WithPacket:(QY_JRMDataPacket *)packet {
    switch (operation) {
        case JRM_REQUEST_OPERATION_TYPE_DEVICE_LOGIN:
            [self postDeviceLoginResultTo:delegate Packet:packet] ;
            break;
        case JRM_REQUEST_OPERATION_TYPE_USER_REGISTE:
            [self postUserRegisteResultTo:delegate Packet:packet] ;
            break ;
        case JRM_REQUEST_OPERATION_TYPE_USER_LOGIN:
            [self postUserLoginResultTo:delegate Packet:packet] ;
            break ;
        default:
            break;
    }
}

#pragma mark - 

+ (void)postDeviceLoginResultTo:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {

    if ( [delegate respondsToSelector:@selector(QY_deviceLoginSuccessed:)]) {
        if ( !packet) {
            QYDebugLog(@"未知错误，socket连接断开") ;
            [delegate QY_deviceLoginSuccessed:FALSE] ;
            return ;
        }
        QYDebugLog(@"设备登录成功") ;
        [delegate QY_deviceLoginSuccessed:TRUE] ;
    }
}

// 251
+ (void)postUserRegisteResultTo:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    if ( [delegate respondsToSelector:@selector(QY_userRegisteSuccessed:userId:)]) {
        if ( !packet ) {
            QYDebugLog(@"注册失败") ;
            [delegate QY_userRegisteSuccessed:FALSE userId:nil] ;
            return ;
        }
        
        if ( packet.length == api251SuccessDataLen - JRM_DATA_LENGTH_Len) {
            QYDebugLog(@"注册成功") ;
            [delegate QY_userRegisteSuccessed:TRUE userId:packet.values[0]] ;
        } else {
            QYDebugLog(@"注册失败") ;
            [delegate QY_userRegisteSuccessed:FALSE userId:nil] ;
        }
    }
}

// 252
+ (void)postUserLoginResultTo:(id<QY_SocketServiceDelegate>)delegate Packet:(QY_JRMDataPacket *)packet {
    if ( [delegate respondsToSelector:@selector(QY_userLoginSuccessed:) ]) {
        if ( !packet ) {
            QYDebugLog(@"登录失败") ;
            [delegate QY_userLoginSuccessed:FALSE] ;
            return ;
        }
        
        if ( packet.cmd == DEVICE_LOGIN2JRM_OK) {
            QYDebugLog(@"登录成功") ;
            [delegate QY_userLoginSuccessed:TRUE] ;
        } else {
            QYDebugLog(@"登录失败") ;
            [delegate QY_userLoginSuccessed:FALSE] ;
        }
    }
}

@end
