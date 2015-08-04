//
//  QY_SocketService_v2.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_SocketService.h"

#import "QY_JRMGCDSocketDelegater.h"

#import "QY_Common.h"

#import "QY_SocketAgent.h"

#import "QY_JDASGCDSocketDelegater.h"

NSString *const kNotificationName_finishDataReceive = @"kNotificationName_finishDataReceive" ;

@interface QY_SocketService ()<GCDAsyncSocketDelegate>

/**
 *  当前处理的Descriptor
 */
@property (nonatomic,readwrite) QY_JRMAPIDescriptor *currentDescriptor ;

/**
 *  jrm连接
 */
@property (nonatomic) GCDAsyncSocket *jrmSocket ;

/**
 *  用于处理jrmSocket的回调
 */
@property (nonatomic) QY_JRMGCDSocketDelegater *socketDelegater ;

//JRM 服务器地址
@property (nonatomic) NSString *JRM_IP ;
@property (assign) NSUInteger JRM_Port ;

@property (copy) QYJRMResponseBlock apiComplection ;

@end

@implementation QY_SocketService

+ (instancetype)shareInstance {
    static QY_SocketService *sharedInstance = nil ;
    static dispatch_once_t OnceToken ;
    
    dispatch_once(&OnceToken, ^{
        sharedInstance = [[QY_SocketService alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter] ;
    
    [center removeObserver:self name:kNotificationName_finishDataReceive object:nil] ;
    [center addObserver:self selector:@selector(didReceiverAllData) name:kNotificationName_finishDataReceive object:nil] ;
}

#pragma mark - 寻址

- (void)getJRMIPandJRMPORTWithComplection:(QYInfoBlock)complection {
    QYDebugLog(@"开始寻址") ;
    complection = ^(NSDictionary *info,NSError *error) {
        if ( complection ) {
            complection(info,error) ;
        }
    } ;
    
    if ( self.JRM_IP && self.JRM_Port ) {
        QYDebugLog(@"已有缓存") ;
        complection(@{JDAS_DATA_JRM_IP_KEY:self.JRM_IP,
                      JDAS_DATA_JRM_PORT_KEY:@(self.JRM_Port)},nil) ;
    } else {
        QYDebugLog(@"重新寻址") ;
        static QY_JDASGCDSocketDelegater *jdas ;
        jdas = [[QY_JDASGCDSocketDelegater alloc] init] ;
        [jdas getJRMIPandJRMPORTWithComplection:^(NSDictionary *info,NSError *error) {
            if ( !error ) {
                self.JRM_IP = info[JDAS_DATA_JRM_IP_KEY] ;
                self.JRM_Port = [info[JDAS_DATA_JRM_PORT_KEY] unsignedIntegerValue] ;
                QYDebugLog(@"请求到IP = %@ 和 PORT = %lu",self.JRM_IP,(unsigned long)self.JRM_Port) ;
            }
            complection(info,error) ;
            jdas = nil ;
        }] ;
    }
}

- (void)connectToJRMWithComplection:(QYResultBlock)complection {
    QYDebugLog(@"开始重新连接") ;
    complection = ^(BOOL result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    
    [self getJRMIPandJRMPORTWithComplection:^(NSDictionary *info, NSError *error) {
        if ( !error ) {
            QYDebugLog(@"info = %@ self = %@",info,self) ;
            [self connectToJRMHost:self.JRM_IP Port:self.JRM_Port Complection:^(BOOL success, NSError *error) {
                if ( success ) {
                    QYDebugLog(@"连接JRM成功") ;
                    [self.socketDelegater deviceLogin2JRMWithComplection:^(BOOL success, NSError *error) {
                        if ( success ) {
                            QYDebugLog(@"设备登录JRM成功") ;
                            
                            QY_UserReloginDescriptor *reloginDesc = [self.delegate shouldReLoginUserToJRM] ;
                            if ( reloginDesc.shouldReLogin ) {
                                [self.socketDelegater userRelogin2JRMWithUsername:reloginDesc.username Password:reloginDesc.password Complection:complection] ;
                            } else {
                                QYDebugLog(@"不需要重新登录用户") ;
                                complection(true,nil) ;
                            }

                            
                        } else {
                            QYDebugLog(@"设备登录JRM失败 error = %@",error) ;
                            complection(false,error) ;
                        }
                    }] ;
                    
                } else {
                    QYDebugLog(@"连接JRM失败 error = %@",error) ;
                    complection(false,error) ;
                }
            }] ;

        } else {
            QYDebugLog(@"error = %@",error) ;
            error = [NSError QYErrorWithCode:JDAS_GET_JRM_ADDRESS_ERROR description:@"JDAS寻址出错"] ;
            complection(false,error) ;
        }
    }] ;
}

/**
 *  连接到JRM服务器
 */
- (void)connectToJRMHost:(NSString *)host
                    Port:(NSUInteger)port
             Complection:(QYResultBlock)complection {
    complection = ^(BOOL success , NSError *error) {
        if ( complection ) {
            complection(success,error) ;
        }
    } ;
    self.socketDelegater.jrmSocket = self.jrmSocket ;
    [self.socketDelegater connectToJRMHost:host Port:port Complection:complection] ;
}


#pragma mark - work

/**
 *  开始工作，并且上锁。
 *
 *  @param APIDescriptor
 */
- (void)startWithAPIDescriptor:(QY_JRMAPIDescriptor *)APIDescriptor
                   Complection:(QYJRMResponseBlock)complection {
    QYDebugLog(@"\n\n------开始工作------") ;
    self.apiComplection = ^(QY_JRMResponse *result,NSError *error) {
        if ( complection ) {
            complection(result,error) ;
        }
    } ;
    self.currentDescriptor = APIDescriptor ;
    QY_JRMRequest *request = APIDescriptor.request ;
    NSMutableData *data = [request getJRMData] ;
    if ( request.attachment ) {
        NSData *attachmentData = request.attachmentData ;
        [data appendData:attachmentData] ;
    }
    
    if ( [self.jrmSocket isConnected]) {
        QYDebugLog(@"data = %@",data) ;
        [self.jrmSocket writeData:data withTimeout:10 tag:request.apiNo] ;
    } else {
        QYDebugLog(@"未连接") ;
        
        [self connectToJRMWithComplection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"连接成功") ;
                QYDebugLog(@"data = %@",data) ;
                [self.jrmSocket writeData:data withTimeout:10 tag:request.apiNo] ;
            } else {
                QYDebugLog(@"连接失败 error = %@",error) ;
                self.apiComplection(nil,error) ;
                self.apiComplection = nil ;
            }
        }] ;
    }
}

/**
 *  这层出口。
 */
- (void)didReceiverAllData {
    QYDebugLog(@"接收了所有的数据，并解析完成") ;
    
    QY_JRMAPIDescriptor *APIDesc = self.currentDescriptor ;


    if ( APIDesc.request.keepConnecting ) {
        //保持连接
        self.currentDescriptor = nil ;
        QY_JRMResponse *response = APIDesc.response ;
        if ( self.apiComplection ) {
            self.apiComplection(response,nil) ;
        }
    } else {
        //不保持连接
        [self.jrmSocket disconnect] ;
    }
}

#pragma mark - getter && setter 

- (QY_JRMGCDSocketDelegater *)socketDelegater {
    if ( !_socketDelegater ) {
        _socketDelegater = [[QY_JRMGCDSocketDelegater alloc] init] ;
        _socketDelegater.superDelegate = self ;
    }
    return _socketDelegater ;
}

- (GCDAsyncSocket *)jrmSocket {
    if ( !_jrmSocket ) {
        _jrmSocket = [[GCDAsyncSocket alloc] initWithDelegate:self.socketDelegater
                                                delegateQueue:dispatch_get_main_queue()] ;
    }
    return _jrmSocket ;
}


#pragma mark - dealloc 

- (void)dealloc {
    _socketDelegater = nil ;
    _jrmSocket = nil ;
    _currentDescriptor = nil ;
    _apiComplection = nil ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationName_finishDataReceive object:nil] ;
}

#pragma mark -

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if ( err ) {
        QYDebugLog(@"遇到错误断开连接 error = %@",err) ;
        if ( self.apiComplection ) {
            self.apiComplection(nil,err) ;
            self.apiComplection = nil ;
            self.currentDescriptor = nil ;
        }
    } else {
        QYDebugLog(@"JRM Socket did disconnect") ;
        if ( self.apiComplection ) {
            QY_JRMAPIDescriptor *APIDesc = self.currentDescriptor ;
            self.currentDescriptor = nil ;
            QY_JRMResponse *response = APIDesc.response ;
            self.apiComplection(response,nil) ;
        }
        
    }
    
    _jrmSocket = nil ;
    
}

@end