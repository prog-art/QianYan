//
//  QY_SocketService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#warning 1 Byte = 8 bit = 2 HEX (2位16进制)

#import "QY_SocketService.h"
#import "QYUtils.h"

@interface QY_SocketService () <AsyncSocketDelegate> {
    
}

@property AsyncSocket *socket ;

@end

@implementation QY_SocketService

+ (instancetype)shareInstance {
    static QY_SocketService *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QY_SocketService alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

- (instancetype)init {
    self = [super init] ;
    if ( self ) {
        _socket = [[AsyncSocket alloc] initWithDelegate:self] ;
    }
    return  self ;
}

#pragma mark -

- (void)connectToHostCompletion:(QYBooleanBlock)completion {
    QYDebugLog() ;
    
    [QYUtils runInGlobalQueue:^{
        NSError *error ;
        BOOL result = [_socket connectToHost:QIANYAN_HOST_IP onPort:QIANYAN_HOST_PORT withTimeout:QIANYAN_HOST_CONNECT_TIMEOUT error:&error] ;
        
        if ( result == TRUE ) {
            QYDebugLog(@"连接成功") ;
            completion( TRUE , nil ) ;
        } else {
            QYDebugLog(@"连接失败 error = %@",error.localizedDescription) ;
            completion( FALSE , error ) ;
        }
        
    }] ;

}

- (BOOL)connectToHost:(NSError **)error {
    QYDebugLog() ;
    BOOL result = [_socket connectToHost:QIANYAN_HOST_IP onPort:QIANYAN_HOST_PORT withTimeout:QIANYAN_HOST_CONNECT_TIMEOUT error:error] ;
    if ( result ) {
        QYDebugLog(@"连接成功") ;
    } else {
        QYDebugLog(@"连接失败 error = %@",*error) ;
    }
    return result ;
}

- (void)reconnected {
    
}

- (void)sendMessage {
    QYDebugLog() ;
    
    NSData *data ;
    {
        //第一种
        Byte testByte[] = { 0x00 , 0x08 , 0x00 , 0x00 ,0x00 ,0x28 , 0x00 ,0x00,0x00 ,0x1e } ;
        data = [[NSData alloc] initWithBytes:testByte length:sizeof(testByte)/sizeof(Byte)] ;
    }
    
    {
        //第二种
        NSString *testData = [QYUtils QY_FormatStringFromNSInteger:8 ToLength:2] ;
        testData = [testData stringByAppendingString:[QYUtils QY_FormatStringFromNSInteger:LOGIN2JRM_REQUEST_CMD ToLength:4]] ;
        testData = [testData stringByAppendingString:[QYUtils QY_FormatStringFromNSInteger:JOSEPH_DEVICE_JCLIENT ToLength:4]] ;
        QYDebugLog(@"dataString = %@",testData) ;
        //NSString *testData = @"0008000000280000001e" ;
        data = [testData dataUsingEncoding:NSUTF8StringEncoding] ;
    }

    

    QYDebugLog(@"data = %@",data) ;
    
    [_socket writeData:data withTimeout:10 tag:0] ;
}

//- (void)sendMessage {
//    NSString *inputMsgStr = @"0800400030" ;
//    NSString *content = [inputMsgStr stringByAppendingString:@"\r\n"] ;
//    NSData *data = [content dataUsingEncoding:NSISOLatin1StringEncoding] ;
//    Byte *bytes = (Byte *)[data bytes] ;
//    
//    {
//        //NSData to Byte[]
//        NSString *testString = @"1234567890";
//        NSData *testData = [testString dataUsingEncoding: NSUTF8StringEncoding];
//        Byte *testByte = (Byte *)[testData bytes];
//        for(int i=0;i<[testData length];i++)
//            NSLog(@"testByte = %s\n",testByte) ;
//    }
//    
//    {
//        //Byte[] to NSData
//        Byte byte[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
//        NSData *adata = [[NSData alloc] initWithBytes:byte length:24];
//    }
//    
////    {
////        //Byte[] to Hex
////        Byte *bytes = (Byte *)[data bytes];
////        NSString *hexStr=@"";
////        for(int i=0;i<[data length];i++)
////        {
////            NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes & 0xff];///16进制数
////            if([newHexStr length]==1)
////                hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
////            else
////                hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
////        }
////        NSLog(@"bytes 的16进制数为:%@",hexStr);
////    }
//    
//    {
//        //16进制数－>Byte数组
//        NSString *hexString = @"3e435fab9c34891f"; //16进制字符串
//        int j=0;
//        Byte bytes[128]; ///3ds key的Byte 数组， 128位
//        for(int i=0;i<[hexString length];i++)
//        {
//            int int_ch; /// 两位16进制数转化后的10进制数
//            unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//            int int_ch1;
//            if(hex_char1 >= '0' && hex_char1 <='9')
//                int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//            else if(hex_char1 >= 'A' && hex_char1 <='F')
//                int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//            else
//                int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
//            i++;
//            unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//            int int_ch2;
//            if(hex_char2 >= '0' && hex_char2 <='9')
//                int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//            else if(hex_char1 >= 'A' && hex_char1 <='F')
//                int_ch2 = hex_char2-55; //// A 的Ascll - 65
//            else
//                int_ch2 = hex_char2-87; //// a 的Ascll - 97
//            int_ch = int_ch1+int_ch2;
//            NSLog(@"int_ch=%d",int_ch);
//            bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
//            j++;
//        }
//        NSData *newData = [[NSData alloc] initWithBytes:bytes length:128];
//        NSLog(@"newData=%@",newData);
//    }
//    
//}

#pragma mark - AsyncSocketDelegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    QYDebugLog(@"连接服务器成功 Host:%@ Port:%d",host,port) ;
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    QYDebugLog(@"message did write");
    [sock readDataWithTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    QYDebugLog(@"data = %@",data) ;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    QYDebugLog(@"遇到错误断开连接 error = %@",err) ;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    QYDebugLog(@"Socket did disconnect") ;
}

@end
