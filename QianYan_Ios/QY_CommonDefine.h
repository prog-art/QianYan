//
//  QY_CommonDefine.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/28.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef QianYan_Ios_QY_CommonDefine_h
#define QianYan_Ios_QY_CommonDefine_h

typedef void (^QYBlock)();
typedef void (^QYBooleanBlock)(BOOL Successed , NSError *error);
typedef void (^Int64Block)(int64_t num);

#define QIANYAN_HOST_IP @"jdas.qycam.com"
#define QIANYAN_HOST_PORT 50002
#define QIANYAN_HOST_CONNECT_TIMEOUT 1.0

#define WEAKSELF  typeof(self) __weak weakSelf=self;


#ifdef DEBUG
#   define QYDebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define QYDebugLog(...)
#endif


#endif
