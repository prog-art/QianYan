//
//  QY_SocketAgent_v2.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "QY_Block_Define.h"
#import "QY_JRMAPIInterface.h"

typedef NS_ENUM(NSInteger, APP_State) {
    APP_State_Started = 1 ,//刚启动，没有IP和PORT
    APP_State_JDAS_CONNECTED = 2 ,//[暂态，短暂]JDAS连接
    
    APP_State_JRM_READY = 3 ,//JDAS获取IP和PORT成功并断开连接[这个时候，IP和PORT是有值的]
    APP_State_JRM_CONNECTED = 4 ,//[暂态，短暂]JRM已连接
    APP_State_JRM_DEVICE_DID_LOGIN = 5 ,//[JRM连接后，自动发送DEVICE LOGIN]所有操作必须在这个状态的－－这个状态能1.注册、2.登录
    APP_State_JRM_USER_DID_LOGIN = 6 ,//[用户登录后]所有操作都能进行
} ;

/**
 *  代理，接收客户端的操作，生成Descriptor，并调用SocketService
 *  处于组件最上层，下一层是QY_SocketService，最底层是socket
 */
@interface QY_SocketAgent : NSObject<QY_JRMAPIInterface>

/**
 *  单例
 */
+ (instancetype)shareInstance ;

/**
 *  退出登录的时候清理纪录
 */
+ (void)logoff ;

#pragma mark -

/**
 *  程序状态
 */
@property (readwrite,nonatomic,assign) APP_State state ;

//JRM 服务器地址
@property (nonatomic) NSString *JRM_IP ;
@property (assign) NSUInteger JRM_Port ;

#pragma mark - test

#pragma mark - JRM

///**
// *  检查contacts（电话号码）是否有千衍账号
// *
// *  @param contacts    电话号码
// *  @param complection
// */
//- (void)checkContacts:(NSString *)contacts HaveQYAccountComplection:(QYArrayBlock)complection ;

@end
