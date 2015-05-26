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

#import <Reachability/Reachability.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface QY_JDASSocketDelegater () {
    NSError *_error ;
    
    Reachability *_reach ;
    BOOL _InternetConnection ;
}

@property (nonatomic , assign) BOOL InternetConnection ;

@end

@implementation QY_JDASSocketDelegater

- (instancetype)initWithDelegate:(id<QY_JDASSocketDelegaterDelegate>)delegate {
    if ( self = [self init]) {
        self.delegate = delegate ;
    }
    return self ;
}

- (instancetype)init {
    if ( self = [super init]) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    _error = nil ;
    _reach = [Reachability reachabilityForInternetConnection] ;
    _InternetConnection = FALSE ;
    
    
    _reach.reachableBlock = ^(Reachability * reachability) {
       dispatch_async(dispatch_get_main_queue(), ^{
           QYDebugLog(@"网络可用") ;
       }) ;
    } ;
    
    _reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            QYDebugLog(@"网络不可用") ;
        }) ;
    } ;
    
    [_reach startNotifier] ;
}

#pragma mark - AsyncSocketDelegate

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
    
    self.InternetConnection = [_reach isReachable] ;
    
    QYDebugLog(@" 连接 %@",self.InternetConnection?@"可用":@"不可用") ;
    
    return self.InternetConnection ;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    QYDebugLog(@"连接服务器成功 Host:%@ Port:%d",host,port) ;
    if ( [self.delegate respondsToSelector:@selector(JDASSocketDidConnect:)]) {
        [self.delegate JDASSocketDidConnect:sock] ;
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    QYDebugLog(@"message did write");
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    QYDebugLog(@"receive data = %@",data) ;
    
    if ( [data length] != JDAS_DATA_LENGTH ) {
        if ( [self.delegate respondsToSelector:@selector(JDASSocketReadNonFullData)]) {
            [self.delegate JDASSocketReadNonFullData] ;
        }
        
        return ;
    }
    
    Byte *dataByte = (Byte *)[data bytes] ;
    
    NSString *hostName = @"";
    for ( int i = 0 ; i < 4 ; i ++) {
        Byte tempB = dataByte[i] ;
        hostName = [hostName stringByAppendingString:[NSString stringWithFormat:@"%d",tempB]] ;
        if ( i < 3 ) {
            hostName = [hostName stringByAppendingString:@"."] ;
        }
    }
    
    NSUInteger port = 0 ;
    for ( int i = 4 ; i < JDAS_DATA_LENGTH ; i ++ ) {
        Byte tempB = dataByte[i] ;
        NSUInteger tempI = (NSUInteger)tempB ;
        port = port * 16 * 16 + tempI ;
    }
    
    if ( [self.delegate respondsToSelector:@selector(JDASSocketDidReadJRMHost:port:)]) {
        [self.delegate JDASSocketDidReadJRMHost:hostName port:port] ;
    }
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    QYDebugLog(@"遇到错误断开连接 error = %@",err) ;
    _error = err ;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    if ( !_error ) {
        if ( [self.delegate respondsToSelector:@selector(JDASSocketDidNormallyDisconnect)]) {
            [self.delegate JDASSocketDidNormallyDisconnect] ;
        }
    } else {
        if ( [self.delegate respondsToSelector:@selector(JDASSocketDidDisconnectWithError:)]) {
            [self.delegate JDASSocketDidDisconnectWithError:_error] ;
        }
    }
}

#pragma mark - 

//- (void)delegateout:(SEL)selector {
//    if ( !self.delegate ) {
//        return ;
//    }
//    
//    if ( [self.delegate respondsToSelector:selector] ) {
//        SuppressPerformSelectorLeakWarning(
//            [self.delegate performSelector:selector] ;
//        ) ;
//    }
//}

- (void)dealloc {
    QYDebugLog(@"dealloc JDAS delegater") ;
}

@end
