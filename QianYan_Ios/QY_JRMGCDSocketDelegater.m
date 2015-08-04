//
//  QY_JRMGCDSocketDelegater_v2.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/24.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMGCDSocketDelegater.h"

#import "QY_Common.h"

#import "JRMDataParseUtils.h"

#import "QY_JRMAPIDescriptor.h"

#import "QY_SocketService.h"

#import "QY_jclient_jrm_protocol_Marco.h"

#import "JRMDataParseUtils.h"


typedef NS_ENUM(NSInteger, JRM_Socket_Read_tag) {
    JRM_Socket_Read_tag_readDataLen    = 0 ,//读data len
    JRM_Socket_Read_tag_readBody       = 1 ,//读cmd + values
    JRM_Socket_Read_tag_readAppendData = 2 ,//读取附件
    JRM_Socket_Read_tag_DeviceLogin    = 3 ,//设备登录
    JRM_Socket_Read_tag_relogin        = 4 ,//用户重新登录
} ;

@interface QY_JRMGCDSocketDelegater ()

@property (copy) QYResultBlock connect2JRMComplection ;
@property (copy) QYResultBlock deviceLoginComplection ;
@property (copy) QYResultBlock reloginComplection ;

@end

@implementation QY_JRMGCDSocketDelegater

- (void)connectToJRMHost:(NSString *)host
                    Port:(NSUInteger)port
             Complection:(QYResultBlock)complection {
    self.connect2JRMComplection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    
    NSError *error ;
    BOOL result = [self.jrmSocket connectToHost:host onPort:port error:&error] ;
    
    QYDebugLog(@"result = %@ error = %@",result?@"成功":@"失败",error) ;
    if ( error || !result ) {
        QYDebugLog(@"失败") ;
        self.connect2JRMComplection(false,error) ;
        self.connect2JRMComplection = nil ;
    }
}

- (void)deviceLogin2JRMWithComplection:(QYResultBlock)complection {
    self.deviceLoginComplection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;

    QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:211
                                                         Cmd:LOGIN2JRM_REQUEST_CMD
                                                   JRMValues:@[[JRMvalue objectWithValue:@(JOSEPH_DEVICE_JCLIENT)
                                                                                valueLen:4
                                                                               valueType:JRMValueType_Number]]
                                                  ValueCount:1
                                              AttachmentData:nil] ;
    
    NSMutableData *data = [request getJRMData] ;
    
    [self.jrmSocket writeData:data withTimeout:3 tag:JRM_Socket_Read_tag_DeviceLogin] ;
}

- (void)userRelogin2JRMWithUsername:(NSString *)username Password:(NSString *)password Complection:(QYResultBlock)complection {
    self.reloginComplection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    
    QY_JRMRequest *request = [QY_JRMRequest requestWithAPINo:2510
                                                         Cmd:DEVICE_LOGIN2JRM_CMD
                                                   JRMValues:@[[JRMvalue objectWithValue:username
                                                                                valueLen:JRM_DATA_LEN_OF_KEY_username
                                                                               valueType:JRMValueType_String],
                                                               [JRMvalue objectWithValue:password
                                                                                valueLen:JRM_DATA_LEN_OF_KEY_userPassword
                                                                               valueType:JRMValueType_String]]
                                                  ValueCount:2
                                              AttachmentData:nil] ;
    NSData *data = [request getJRMData] ;
    
    [self.jrmSocket writeData:data withTimeout:3 tag:JRM_Socket_Read_tag_relogin] ;
}

#pragma mark - private

- (void)didReadLenData:(NSData *)data onSocket:(GCDAsyncSocket *)sock {
    NSInteger dataLen = [JRMDataParseUtils getIntegerValue:data] ;
    QYDebugLog(@"数据包长度为:%ld",(long)dataLen) ;
    
    [sock readDataToLength:dataLen withTimeout:-1 tag:JRM_Socket_Read_tag_readBody] ;
}

- (void)didReadBodyData:(NSData *)data onSocket:(GCDAsyncSocket *)sock {
    QYDebugLog(@"body data = %@",data) ;

    QY_JRMAPIDescriptor *currentDescriptor = [[QY_SocketService shareInstance] currentDescriptor] ;
    assert(currentDescriptor) ;
    WEAKSELF
    [currentDescriptor setResponseWithData:data ShouldReadAppendDataBlock:^(BOOL should, NSUInteger len) {
        if ( should && len != 0 ) {
            QYDebugLog(@"读取附件 长度:%lu",(unsigned long)len) ;
            [sock readDataToLength:len withTimeout:-1 tag:JRM_Socket_Read_tag_readAppendData] ;
        } else {
            [weakSelf postNotification_finishDataReceiver] ;
        }
    }] ;
}

- (void)didReadAppendData:(NSData *)data onSocket:(GCDAsyncSocket *)sock {
    QYDebugLog(@"append data = %@",data) ;

    QY_JRMAPIDescriptor *currentDescriptor = [[QY_SocketService shareInstance] currentDescriptor] ;
    
    [currentDescriptor setAttachmentData:data] ;
    
    QYDebugLog(@"读取附件完成") ;
    [self postNotification_finishDataReceiver] ;
}

- (void)postNotification_finishDataReceiver {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_finishDataReceive object:nil] ;
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    QYDebugLog(@"JRM服务器连接成功") ;
    if ( self.connect2JRMComplection ) {
        self.connect2JRMComplection(true,nil) ;
        self.connect2JRMComplection = nil ;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    QYDebugLog(@"message did write apiNo = %ld",tag) ;

    if ( tag == JRM_Socket_Read_tag_DeviceLogin || tag == JRM_Socket_Read_tag_relogin) {
        [sock readDataToLength:JRM_DATA_LEN_OF_KEY_LEN + JRM_DATA_LEN_OF_KEY_CMD withTimeout:-1 tag:tag] ;
        return ;
    }
    [sock readDataToLength:JRM_DATA_LEN_OF_KEY_LEN
               withTimeout:-1
                       tag:JRM_Socket_Read_tag_readDataLen] ;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //tag 是 JRM_REQUEST_OPERATION_TYPE
    QYDebugLog(@"did read data = %@ tag = %ld",data,tag) ;
    
    switch (tag) {
        case JRM_Socket_Read_tag_readDataLen : {
            [self didReadLenData:data onSocket:sock] ;
            break;
        }
        case JRM_Socket_Read_tag_readBody : {
            [self didReadBodyData:data onSocket:sock] ;
            break ;
        }
        case JRM_Socket_Read_tag_readAppendData : {
            [self didReadAppendData:data onSocket:sock] ;
        }
        case JRM_Socket_Read_tag_DeviceLogin : {
            if ( self.deviceLoginComplection ) {
                self.deviceLoginComplection(true,nil) ;
                self.deviceLoginComplection = nil ;
            }
            break ;
        }
        case JRM_Socket_Read_tag_relogin : {
            if ( self.reloginComplection ) {
                JOSEPH_COMMAND cmd = [JRMDataParseUtils getCmd:data range:NSMakeRange(2, JRM_DATA_LEN_OF_KEY_CMD)] ;
                if ( cmd == DEVICE_LOGIN2JRM_OK ) {
                    self.reloginComplection(true,nil) ;
                } else {
                    NSError *error = [NSError QYErrorWithCode:JRM_USER_RELOGIN2JRM_ERROR description:@"重新登录失败"] ;
                    self.reloginComplection(false,error) ;
                }
                self.reloginComplection = nil ;
            }
            break ;
        }
        default :
            break ;
    }
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self.superDelegate socketDidDisconnect:sock withError:err] ;
    
    if ( self.deviceLoginComplection ) {
        self.deviceLoginComplection(false,err) ;
        self.deviceLoginComplection = nil ;
    }
    
    if ( self.connect2JRMComplection ) {
        QYDebugLog(@"连接失败。。error = %@",err) ;
        self.connect2JRMComplection(false,err) ;
        self.connect2JRMComplection = nil ;
    }
}

@end