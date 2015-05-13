//
//  QY_JRMSocketDelegater.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//
//  jrm与设备的通信协议为length+cmd+value协议。
//  协议定义如表1-1所示，注意协议中所有的整型(unsigned short、unsigned int等)均以网络字节序存储；value中的字符串（string）以固定长度存储，不足以’\0’填充。
//  jrm与设备通信的架构是C/S，设备的请求（request）与jrm的响应（response）一一对应。


#import "QY_JRMSocketDelegater.h"

#import "QY_jclient_jrm_protocol_Marco.h"
#import "QY_JRMDataPharser.h"
#import "QY_SocketServiceDelegateNotificationCenter.h"

@implementation QY_JRMSocketDelegater

#pragma mark - Life Cycle 

- (instancetype)initWithDelegate:(id<QY_SocketServiceDelegate>)delegate {
    if ( self = [self init] ) {
        self.delegate = delegate ;
    }
    return self ;
}

#pragma mark - AsyncSocketDelegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    QYDebugLog(@"连接服务器成功 Host:%@ Port:%d",host,port) ;
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    QYDebugLog(@"message did write") ;
    [sock readDataWithTimeout:-1 tag:tag] ;
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //tag 是 JRM_REQUEST_OPERATION_TYPE
    QYDebugLog(@"receive data = %@ tag = %ld",data,tag) ;
    
    //数据解析
    QY_JRMDataPacket *packet = [QY_JRMDataPharser pharseDataWithData:data Tag:tag] ;
    //数据通知
    [QY_SocketServiceDelegateNotificationCenter postDelegate:self.delegate Notification:tag WithPacket:packet] ;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    QYDebugLog(@"遇到错误,将要断开连接 error = %@",err) ;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    QYDebugLog(@"JRM Socket did disconnect") ;
}

@end
