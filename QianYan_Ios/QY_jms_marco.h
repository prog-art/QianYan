//
//  QY_jms_marco.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QY_jms_marco_h
#define QianYan_Ios_QY_jms_marco_h

typedef NS_ENUM(NSUInteger, JMS_DEVICE_TYPE) {
    JMS_DEVICE_ANDROID      = 10, // 安卓手机客户端
    JMS_DEVICE_PC           = 20,// PC客户端
    JMS_DEVICE_IOS          = 30,// 苹果手机客户端
    JMS_DEVICE_IPNC         = 100,// 相机
    JMS_DEVICE_IPNC_SEND    = 101,// 相机IPNC_SEND
    JMS_DEVICE_UPDATAE_TOOL = 200,// 升级工具
    JMS_DEVICE_JSTORE       = 300,// JSTORE
};

typedef NS_ENUM(NSUInteger, JRM_IOS_MESSAGE_TYPE) {
    JMS_IOS_INSTANT_MESSAGE        = 4010,// 即时消息
    JMS_IOS_FRIEND_REQUEST_MESSAGE = 4020,//好友请求
    JMS_IOS_GET_PICTURE            = 4030,// 请求缩略图
    JMS_IOS_SEND_PICTURE           = 4031,// 发送缩略图
    JMS_IOS_MD_ALARM_MESSAGE       = 4040,//移动侦测报警
    JMS_IOS_AUDIO_ALARM_MESSAGE    = 4041,//音频报警
    JMS_IOS_PRE_MESSAGE            = 4042,// 计划报警
    JMS_IOS_SHARE_VIDEO            = 4050,//报警视频分享
    JMS_IOS_MESSAGE_NULL
};

typedef NS_ENUM(NSUInteger, JMS_IPNC_MESSAGE_TYPE) {
    JMS_IPNC_INSTANT_MESSAGE        = 6010,
    JMS_IPNC_FRIEND_REQUEST_MESSAGE = 6020,
    JMS_IPNC_GET_PICTURE            = 6030,
    JMS_IPNC_SEND_PICTURE           = 6031,
    JMS_IPNC_MD_ALARM_MESSAGE       = 6040,
    JMS_IPNC_AUDIO_ALARM_MESSAGE    = 6041,
    JMS_IPNC_PRE_MESSAGE            = 6042,
    JMS_IPNC_PSHARE_VIDEO           = 6050,
    JMS_IPNC_MESSAGE_NULL
};

#endif
