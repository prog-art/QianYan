//
//  QY_JMSService.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JMSService.h"
#import "JRMDataFormatUtils.h"
#import "JRMDataParseUtils.h"

#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

#import "QY_Common.h"

#import "QY_jms_parameter_key_marco.h"
#import "QY_jms_marco.h"
#import "QYGCDAsyncSocket.h"

#import "QY_CamDataFactor.h"

typedef NS_ENUM(NSInteger, JMS_DATA_READ_OPERATION ) {
    JMS_DATA_READ_OPERATION_JMS_DATA = 10 ,//JMS服务器的部分。
    JMS_DATA_READ_OPERATION_CAM_DATA = 20 ,//转发的相机部分。
} ;

typedef NS_ENUM(NSInteger, JMS_SERVICE_OPERATION ) {
    JMS_SERVICE_OPERATION_GET_CAMERA_STATE = 1 ,//读取单个相机的状态
    JMS_SERVICE_OPERATION_GET_CAMERAS_STATES = 2 ,//读取多个相机的状态
    JMS_SERVICE_OPERATION_GET_CAMERA_THUMBNAIL = 3 ,//去读单个相机的缩略图
} ;

@interface QY_JMSService ()<GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>

@property (atomic) NSMutableArray *sockets ;

- (NSData *)JMSLoginData ;

@property (strong,nonatomic) GCDAsyncUdpSocket *udpSocket ;
@property (strong,nonatomic) NSTimer *HBTimer ;

@end

@implementation QY_JMSService

+ (instancetype)shareInstance {
    static QY_JMSService *sharedInstace = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[QY_JMSService alloc] init] ;
    }) ;
    return sharedInstace ;
}

- (instancetype)init {
    if ( self = [super init]) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    self.sockets = [NSMutableArray array] ;
}

- (void)configIp:(NSString *)ip Port:(NSString *)port {
    if ( !ip && !port ) {
        [NSException raise:@"ip port info config exception" format:@"空的ip和port传入"] ;
        return ;
    }
    _jms_ip = ip ;
    _jms_port = port ;
}

#pragma mark - getter & setter

@synthesize jms_ip = _jms_ip ;
@synthesize jms_port = _jms_port ;

- (NSString *)jms_ip {
    return _jms_ip ? : JMS_IP ;
}

- (NSString *)jms_port {
    return _jms_port ? : JMS_PORT ;
}

- (NSString *)device_id {
    return [QYUser currentUser].coreUser.userId ;
}

#pragma mark - helper 

- (NSData *)getJmsDataByCameraId:(NSString *)cameraId type:(NSUInteger)type time:(NSUInteger)time {
    NSMutableData *jmsData = [NSMutableData data] ;
    
    NSData *cameraIdData = [JRMDataFormatUtils formatStringValueData:cameraId
                                                               toLen:JMS_DATA_LEN_OF_KEY_CAMID] ;
    NSData *typeData = [JRMDataFormatUtils formatIntegerValueData:type
                                                            toLen:JMS_DATA_LEN_OF_KEY_TYPE] ;
    NSData *timeData = [JRMDataFormatUtils formatIntegerValueData:0
                                                            toLen:JMS_DATA_LEN_OF_KEY_TIME] ;
    
    [@[cameraIdData,typeData,timeData] enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
        [jmsData appendData:data] ;
    }] ;
    
    return jmsData ;
}

- (QYGCDAsyncSocket *)getASocket {
    QYGCDAsyncSocket *socket = [[QYGCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()] ;
    return socket ;
}

- (NSData *)JMSLoginData {
    NSMutableData *loginData = [NSMutableData data] ;
    {
        NSData *device_idData = [JRMDataFormatUtils formatStringValueData:self.device_id
                                                                    toLen:JMS_DATA_LEN_OF_KEY_DEVICE_ID];
        NSData *device_typeData = [JRMDataFormatUtils formatIntegerValueData:JMS_DEVICE_IOS
                                                                       toLen:JMS_DATA_LEN_OF_KEY_DEVICE_TYPE] ;
        NSData *keyData = [JRMDataFormatUtils formatStringValueData:JMS_LOGIN_KEY
                                                              toLen:JMS_DATA_LEN_OF_KEY_KEY] ;
        
        [@[device_idData,device_typeData,keyData] enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
            [loginData appendData:data] ;
        }] ;
    }
    
    return loginData ;
}

#pragma mark - JMS tcp请求

/**
 *  获取相机状态
 *
 *  @param cameraIds   相机的Id
 *  @param complection 回调返回相机的状态
 */
- (void)getCamerasStateByIds:(NSSet *)cameraIds complection:(QYArrayBlock)complection {
    QYDebugLog(@"获取相机[%@]的状态",cameraIds) ;
    static NSUInteger type = 6013 ;
    
    QYGCDAsyncSocket *socket = [self getASocket] ;
    
    socket.complection = ^(id object,NSError *error) {
        if ( complection ) {
            complection(object,error) ;
        }
    } ;
    
    if (!cameraIds || cameraIds.count == 0 ) {
        socket.complection(@[],nil) ;
        socket.complection = nil ;
        return ;
    }

    NSArray *cameraIdArr = [cameraIds allObjects] ;
    
    //生成各部分的数据
    NSData *cameraIdData = [JRMDataFormatUtils formatStringValueData:cameraIdArr[0]
                                                               toLen:JMS_DATA_LEN_OF_KEY_CAMID] ;
    NSData *typeData = [JRMDataFormatUtils formatIntegerValueData:type
                                                            toLen:JMS_DATA_LEN_OF_KEY_TYPE] ;
    NSData *timeData = [JRMDataFormatUtils formatIntegerValueData:0
                                                            toLen:JMS_DATA_LEN_OF_KEY_TIME] ;
    NSString *cameraIdsStr = [cameraIdArr componentsJoinedByString:@"&"] ;
    cameraIdsStr = [cameraIdsStr stringByAppendingString:@"&"] ;
    
    NSData *CamData = [cameraIdsStr dataUsingEncoding:NSUTF8StringEncoding] ;
    NSData *lengthData = [JRMDataFormatUtils formatIntegerValueData:[CamData length]
                                                              toLen:JMS_DATA_LEN_OF_KEY_LENGTH] ;
    
    NSArray *dataArr = @[cameraIdData,typeData,timeData,lengthData,CamData] ;
    
    NSMutableData *packageData = [NSMutableData data] ;
    
    [dataArr enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
        [packageData appendData:data] ;
    }] ;
    
    [self.sockets addObject:socket] ;
    [self startWorkWithData:packageData socket:socket operation:JMS_SERVICE_OPERATION_GET_CAMERAS_STATES] ;
}

/**
 *  获取相机实时的缩略图
 *
 *  @param cameraId    相机的Id
 *  @param complection 回调返回相机缩略图的NSData。
 */
- (void)getCameraThumbnailById:(NSString *)cameraId complection:(QYObjectBlock)complection {
    QYDebugLog(@"获取相机[%@]缩略图",cameraId) ;
    static NSUInteger type = 6030 ;
    static NSUInteger cmd = 1360 ;
    
    QYGCDAsyncSocket *socket = [self getASocket] ;
    
    socket.complection = ^(id obj,NSError *error) {
        if ( complection ) {
            complection(obj,error) ;
        }
    } ;
    
    if ( !cameraId ) {
        socket.complection(nil,nil) ;
        socket.complection = nil ;
        return ;
    }
    
    NSData *cameraIdData = [JRMDataFormatUtils formatStringValueData:cameraId
                                                               toLen:JMS_DATA_LEN_OF_KEY_CAMID] ;
    NSData *typeData = [JRMDataFormatUtils formatIntegerValueData:type
                                                            toLen:JMS_DATA_LEN_OF_KEY_TYPE] ;
    NSData *timeData = [JRMDataFormatUtils formatIntegerValueData:0
                                                            toLen:JMS_DATA_LEN_OF_KEY_TIME] ;
    
    NSData *lengthData ;
    NSMutableData *camData = [NSMutableData data] ;
    {
        NSData *cam_lengthData = [JRMDataFormatUtils formatIntegerValueData:(JMS_DATA_LEN_OF_KEY_CMD + JMS_DATA_LEN_OF_KEY_CAMDATA_DATA)
                                                                      toLen:JMS_DATA_LEN_OF_KEY_CAMDATA_LENGTH];
        NSData *cam_cmdData = [JRMDataFormatUtils formatIntegerValueData:cmd
                                                                   toLen:JMS_DATA_LEN_OF_KEY_CMD] ;
        NSData *cam_dataData = [JRMDataFormatUtils formatStringValueData:@"1"
                                                                   toLen:JMS_DATA_LEN_OF_KEY_CAMDATA_DATA] ;
        
        NSArray *camDataArr = @[cam_lengthData,cam_cmdData,cam_dataData] ;
        [camDataArr enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
            [camData appendData:data] ;
        }] ;
        lengthData = [JRMDataFormatUtils formatIntegerValueData:[camData length]
                                                          toLen:JMS_DATA_LEN_OF_KEY_LENGTH] ;
    }
    
    NSMutableData *packageData = [NSMutableData data] ;
    
    NSArray *dataArr = @[cameraIdData,typeData,timeData,lengthData,camData] ;
    
    [dataArr enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
        [packageData appendData:data] ;
    }] ;

    [self.sockets addObject:socket] ;
    [self startWorkWithData:packageData socket:socket operation:JMS_SERVICE_OPERATION_GET_CAMERA_THUMBNAIL] ;
}
//
//#warning 未重写。
//- (void)getCameraStateById:(NSString *)cameraId {
//    //基本没用这个接口，用的下面那个。
//    static NSUInteger type = 6010 ;
//    static NSUInteger cmd = 1340 ;
//    
//    NSData *cameraIdData = [JRMDataFormatUtils formatStringValueData:cameraId
//                                                               toLen:JMS_DATA_LEN_OF_KEY_CAMID] ;
//    NSData *typeData = [JRMDataFormatUtils formatIntegerValueData:type
//                                                            toLen:JMS_DATA_LEN_OF_KEY_TYPE] ;
//    NSData *timeData = [JRMDataFormatUtils formatIntegerValueData:0
//                                                            toLen:JMS_DATA_LEN_OF_KEY_TIME] ;
//    
//    NSData *lengthData = [JRMDataFormatUtils formatIntegerValueData:(JMS_DATA_LEN_OF_KEY_CMD_LENGTH + JMS_DATA_LEN_OF_KEY_CMD)
//                                                              toLen:JMS_DATA_LEN_OF_KEY_LENGTH] ;
//    
//    NSData *cmdLengthData = [JRMDataFormatUtils formatIntegerValueData:JMS_DATA_LEN_OF_KEY_CMD
//                                                                 toLen:JMS_DATA_LEN_OF_KEY_CMD_LENGTH] ;
//    NSData *cmdData = [JRMDataFormatUtils formatIntegerValueData:cmd
//                                                           toLen:JMS_DATA_LEN_OF_KEY_CMD] ;
//    
//    //组装
//    NSArray *dataArr = @[cameraIdData,typeData,timeData,lengthData,cmdLengthData,cmdData] ;
//    
//    NSMutableData *packageData = [NSMutableData data] ;
//    
//    [dataArr enumerateObjectsUsingBlock:^(NSData *data , NSUInteger idx, BOOL *stop) {
//        [packageData appendData:data] ;
//    }] ;
//    
//    //发送
//    [self startWorkWithData:packageData Tag:JMS_SERVICE_OPERATION_GET_CAMERA_STATE] ;
//}

#pragma mark - JMS UDP请求

- (GCDAsyncUdpSocket *)udpSocket {
    if ( !_udpSocket ) {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)] ;
    }
    return _udpSocket ;
}

- (BOOL)isSendingHeartBeatMessage {
    return self.HBTimer ;
}

- (void)startSendHeartBeatMessage {
    if ( self.HBTimer ) {
        QYDebugLog(@"已经在发送了") ;
        return ;
    }
    QYDebugLog(@"开始发送心跳包,先连接") ;
    
    if ( ![self.udpSocket isConnected]) {
        [self.udpSocket connectToHost:self.jms_ip
                               onPort:[self.jms_port integerValue]
                                error:NULL] ;
    }
}

/**
 *  停止发送［离线］
 */
- (void)stopSendHeartBeatMessage {
    if ( [self.HBTimer isValid]) {
        [self.HBTimer invalidate] ;
        self.HBTimer = nil ;
    }
    
    if ( ![self.udpSocket isClosed]) {
        [self.udpSocket close] ;
    }
}

- (void)sendMessage {
    QYDebugLog(@"发送心跳包") ;
    NSString *deviceId = self.device_id ;
    NSString *messageType = @"30" ;//IOS TYPE
    NSData *deviceIdData = [JRMDataFormatUtils formatStringValueData:deviceId toLen:16] ;
    NSData *messageTypeData = [JRMDataFormatUtils formatStringValueData:messageType toLen:4] ;
    NSMutableData *HBData = [NSMutableData data] ;
    [HBData appendData:deviceIdData] ;
    [HBData appendData:messageTypeData] ;
    
    [self.udpSocket sendData:HBData withTimeout:5.0f tag:0] ;
}

#pragma mark - GCDAsyncUdpSocketDelegate

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection is successful.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    QYDebugLog(@"udp连接jms成功") ;
    //连接后开始监听
    [sock beginReceiving:NULL] ;
    //连接后开始发送
    [self sendMessage] ;
    self.HBTimer = [NSTimer scheduledTimerWithTimeInterval:7.0f target:self selector:@selector(sendMessage) userInfo:nil repeats:YES] ;
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
    QYDebugLog(@"udp连接jms失败 error = %@",error) ;
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
//    QYDebugLog(@"3 tag = %ld",tag) ;
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    QYDebugLog(@"4 tag = %ld error = %@",tag,error) ;
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *cmd = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    QYDebugLog(@"5 cmd = %@ ,data = %@",cmd,data) ;
    if ( [cmd isEqualToString:@"HB"] ) {
        //7秒后在次发送
    } else
    if ([cmd isEqualToString:@"LOGIN"]) {
        //发送登录jms的data
        
    } else
    if ([cmd isEqualToString:@"LOGOUT"]) {
        //退出登录！
        //停止！
        [self.HBTimer invalidate] ;
        [sock close] ;
#warning 别处登录
        [QYUtils alert:@"别处登录！需要退出登录！正在施工。"] ;
    }
    
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    QYDebugLog(@"6 error = %@",error) ;
    //置空
    if ( self.HBTimer && [self.HBTimer isValid]) {
        [self.HBTimer invalidate] ;
        self.HBTimer = nil ;
    }
    self.udpSocket = nil ;
}



#pragma mark - d(^_^o)

- (void)startWorkWithData:(NSData *)data socket:(QYGCDAsyncSocket *)socket operation:(JMS_SERVICE_OPERATION)operation {
    QYDebugLog(@"d(^_^o)") ;
    
    if ( ![socket isConnected] ) {
        QYDebugLog(@"JMS未连接，开始重新连接") ;
        [self makeSocket:socket connectToJMSHost:self.jms_ip Port:self.jms_port Complection:^(BOOL success, NSError *error) {
            if ( success ) {
                QYDebugLog(@"JMS连接成功") ;
                [self startWorkWithData:data socket:socket operation:operation] ;
            } else {
                QYDebugLog(@"JMS连接失败 error = %@",error) ;
                socket.complection(nil,error) ;
                socket.complection = nil ;
            }
        }] ;
        return ;
    }
    
    QYDebugLog(@"发送data[%@]",data) ;
    [socket writeData:data withTimeout:10 tag:operation] ;
}

- (void)makeSocket:(QYGCDAsyncSocket *)socket connectToJMSHost:(NSString *)jms_ip Port:(NSString *)jms_port Complection:(QYResultBlock)complection {
    socket.connectComplection = complection ;
    
    NSError *error ;
    [socket connectToHost:jms_ip onPort:[jms_port integerValue] error:&error] ;
#warning 没处理错误
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(QYGCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    QYDebugLog(@"连接到jms服务器 %@:%hu",host,port) ;
    
    //发送登录JMS信息
    NSData *loginData = self.JMSLoginData ;
    
    QYDebugLog(@"JMS LOGIN DATA = %@",loginData)
    [sock writeData:loginData withTimeout:10 tag:-1] ;
}


- (void)socket:(QYGCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    JMS_DATA_READ_OPERATION readOperation = ( tag / 10 ) * 10 ;
    
    switch (readOperation) {
        case JMS_DATA_READ_OPERATION_JMS_DATA : {
            sock.senderId =[JRMDataParseUtils getStringValue:data range:NSMakeRange(0, 16)] ;
            sock.type = [JRMDataParseUtils getIntegerValue:data range:NSMakeRange(16, 4)] ;
            sock.time = [JRMDataParseUtils getIntegerValue:data range:NSMakeRange(20, 4)] ;
            sock.dataLen = [JRMDataParseUtils getIntegerValue:data range:NSMakeRange(24, 4)] ;
            
            
            [sock readDataToLength:sock.dataLen withTimeout:10.0f tag:( tag % 10 )+ JMS_DATA_READ_OPERATION_CAM_DATA ] ;
            
            break ;
        }
            
        case JMS_DATA_READ_OPERATION_CAM_DATA : {
            NSData *camData = data ;
            QYDebugLog(@"CamData = %@",camData) ;
            
            JMS_SERVICE_OPERATION JMSOperation = tag % 10 ;
            
            switch (JMSOperation) {
                case 1 : {
                    NSString *state = [JRMDataParseUtils getStringValue:camData range:NSMakeRange(6, 2)] ;
                    
                    QYDebugLog(@"state = %@",[state integerValue] == 0 ?@"离线":@"在线") ;
                    //#warning 这里没有调用，就不返回的！注意！
                    [NSException raise:@"Unuserd method" format:@"检查这里，删除就ok"] ;
                    
                    sock.Obj = [state integerValue] == 0 ? @"离线" : @"在线" ;
                    
                    break ;
                }
                    
                case 2 : {
                    //                    NSString *lastString = [JRMDataParseUtils getStringValue:camData] ;
                    NSArray *stateArr = [NSJSONSerialization JSONObjectWithData:camData options:kNilOptions error:NULL] ;
                    sock.Obj = stateArr ;
                    break ;
                }
                    
                case 3 : {
                    QYDebugLog(@"camData = %@",camData) ;
                    if ( camData.length == 8 ) {
                        camData = nil ;
                    } else {
                        camData = [camData subdataWithRange:NSMakeRange(10, camData.length - 10)] ;
                    }
                    
                    sock.Obj = camData ;
                    break ;
                }
                    
                default:
                    break;
            }
            
            [sock disconnect] ;
            
            break ;
        }
            
        default:
            break;
    }
}

- (void)socket:(QYGCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if ( tag == -1 ) {
        QYDebugLog(@"jms login data 已经发送到了jms服务器") ;
        
        if ( sock.connectComplection ) {
            sock.connectComplection(true,nil) ;
            sock.connectComplection = nil ;
        }
        
    } else {
        QYDebugLog(@"data已经发送到了jms服务器") ;
        [sock readDataToLength:28 withTimeout:10.0f tag:JMS_DATA_READ_OPERATION_JMS_DATA+tag] ;
    }
}

- (void)socketDidDisconnect:(QYGCDAsyncSocket *)sock withError:(NSError *)err {
    QYDebugLog(@"JMS连接断开 error = %@ , sock = %@",err,sock) ;
    if ( sock.complection ) {
        sock.complection(sock.Obj,err) ;
        sock.complection = nil ;
    }
    
    [self.sockets removeObject:sock] ;
}

#pragma mark - JMS 相机
#warning 测试阶段

//配置
- (void)getCameraConfigParameterById:(NSString *)cameraId complection:(QYInfoBlock)complection {
    assert(complection) ;
    NSUInteger type ;
    NSUInteger time ;
    NSData *jmsData = [self getJmsDataByCameraId:cameraId type:type time:time] ;
}

- (void)configImageQualityForCameraId:(NSString *)cameraId quality:(NSUInteger)quality complection:(QYInfoBlock)complection {
    
}


@end