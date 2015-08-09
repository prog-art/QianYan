//
//  QYGCDAsyncSocket.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "GCDAsyncSocket.h"

#import "QY_Block_Define.h"

@interface QYGCDAsyncSocket : GCDAsyncSocket

@property (copy) QYResultBlock connectComplection ;

@property (copy) QYObjectBlock complection ;

#pragma mark - requested data 

@property (nonatomic) NSString *senderId ;
@property NSInteger type ;
@property NSInteger time ;
@property NSInteger dataLen ;

#pragma mark - CamData

@property id Obj ;

@end
