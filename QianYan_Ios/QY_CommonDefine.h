//
//  QY_CommonDefine.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QY_CommonDefine_h
#define QianYan_Ios_QY_CommonDefine_h

#define QIANYAN_HOST_IP @"jdas.qycam.com"
#define QIANYAN_HOST_PORT 50002
#define QIANYAN_HOST_CONNECT_TIMEOUT 5.0

#define JDAS_HOST_IP @"jdas.qycam.com"
#define JDAS_HOST_PORT 50002

#define WEAKSELF  typeof(self) __weak weakSelf=self ;


#ifdef DEBUG
#   define QYDebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define QYDebugLog(...)
#endif

//JDAS获取数据后dic[key]
#define JDAS_DATA_JRM_IP_KEY @"JRM_IP_KEY"
#define JDAS_DATA_JRM_PORT_KEY @"JRM_PORT_KEY"

#endif
