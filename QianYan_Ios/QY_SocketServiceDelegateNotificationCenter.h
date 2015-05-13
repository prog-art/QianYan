//
//  QY_SocketServiceDelegateNotificationCenter.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_JRMDataPacket.h"
#import "QY_SocketService.h"

@interface QY_SocketServiceDelegateNotificationCenter : NSObject

+ (void)postDelegate:(id<QY_SocketServiceDelegate>)delegate Notification:(JRM_REQUEST_OPERATION_TYPE)operation WithPacket:(QY_JRMDataPacket *)packet ;

@end
