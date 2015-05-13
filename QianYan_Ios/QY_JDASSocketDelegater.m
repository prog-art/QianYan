//
//  QY_JDASSocketDelegater.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JDASSocketDelegater.h"

#import "QYUtils.h"
#import "QYNotify.h"

@implementation QY_JDASSocketDelegater

#pragma mark - AsyncSocketDelegate

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
    QYDebugLog(@" 连接！ ") ;
    return TRUE ;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    QYDebugLog(@"连接服务器成功 Host:%@ Port:%d",host,port) ;
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    QYDebugLog(@"message did write");
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    QYDebugLog(@"receive data = %@",data) ;
    
    if ( [data length] != JDAS_DATA_LENGTH ) {
        if ( _dataReadComplection ) {
            _dataReadComplection(nil , 0) ;
        }
        return ;
    }
    
    Byte *dataByte = (Byte *)[data bytes] ;
    
    NSString *hostName = @"";
    for ( int i = 0 ; i < 4; i ++) {
        Byte tempB = dataByte[i] ;
        hostName = [hostName stringByAppendingString:[NSString stringWithFormat:@"%d",tempB]] ;
        if ( i < 3 ) {
            hostName = [hostName stringByAppendingString:@"."] ;
        }
    }
    
    NSUInteger port = 0 ;
    for ( int i = 4 ; i < JDAS_DATA_LENGTH; i ++ ) {
        Byte tempB = dataByte[i] ;
        NSUInteger tempI = (NSUInteger)tempB ;
        port = port * 16 * 16 + tempI ;
    }
    
    if ( _dataReadComplection ) {
        _dataReadComplection(hostName ,port) ;
    }
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    QYDebugLog(@"遇到错误断开连接 error = %@",err) ;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    QYDebugLog(@"JDAS Socket did disconnect") ;
    [[QYNotify shareInstance] postJDASNotification:nil] ;
}

@end
