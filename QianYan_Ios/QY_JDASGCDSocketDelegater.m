//
//  QY_JDASGCDSocketDelegater.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JDASGCDSocketDelegater.h"

#import "QY_CommonDefine.h"

@interface QY_JDASGCDSocketDelegater ()

@property (copy) QYInfoBlock complection ;

/**
 *  唯一要处理的连接jrm服务器的socket
 */
@property (nonatomic) GCDAsyncSocket *jdasSocket ;

@end

@implementation QY_JDASGCDSocketDelegater

#pragma mark - getter & setter 

- (GCDAsyncSocket *)jdasSocket {
    if ( !_jdasSocket ) {
        _jdasSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()] ;
    }
    return _jdasSocket ;
} ;

#pragma mark - 寻址

- (void)getJRMIPandJRMPORTWithComplection:(QYInfoBlock)complection {
    self.complection = ^(NSDictionary *info,NSError *error) {
        if ( complection ) {
            complection(info,error) ;
        }
    };    
    
    NSError *error ;
    [self.jdasSocket connectToHost:JDAS_HOST_IP onPort:JDAS_HOST_PORT error:&error] ;
    
    if ( error ) {
        complection(nil,error) ;
    }    
}


#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    QYDebugLog(@"jdas已连接") ;
    
    Byte Msg[] = { 0x00 , 0x00 , 0x02 , 0xd2 } ;
    NSData *data = [NSData dataWithBytes:Msg length:sizeof(Msg)/sizeof(Byte)] ;

    if ( sock ) {
        [sock writeData:data withTimeout:10 tag:0] ;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    QYDebugLog(@"请求IP和PORT的数据包已经发送") ;
    
    [sock readDataToLength:6 withTimeout:3 tag:tag] ;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    Byte *dataByte = (Byte *)[data bytes] ;
    
    NSString *hostName = @"" ;
    NSMutableArray *ips = [NSMutableArray array] ;
    for ( int i = 0 ; i < 4 ; i++ ) {
        Byte tempB = dataByte[i] ;
        [ips addObject:[NSString stringWithFormat:@"%d",tempB]] ;
    }
    hostName = [ips componentsJoinedByString:@"."] ;
    
    NSUInteger port = 0 ;
    for ( int i = 4 ; i < 6 ; i++ ) {
        Byte tempB = dataByte[i] ;
        NSUInteger tempI = (NSUInteger)tempB ;
        port = port * 16 * 16 + tempI ;
    }
    
    if ( self.complection ) {
        self.complection(@{JDAS_DATA_JRM_IP_KEY:hostName,
                           JDAS_DATA_JRM_PORT_KEY:@(port)},nil) ;
        self.complection = nil ;
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    if ( self.complection ) {
        self.complection(nil,err) ;
        self.complection = nil ;
    }
}


@end
