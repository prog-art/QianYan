//
//  QYNotify.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QYNotify.h"

@interface QYNotify ()

@property (weak) NSNotificationCenter *center ;

@end

@implementation QYNotify

#pragma mark - Life Cycle ;

+(instancetype)shareInstance {
    static QYNotify *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QYNotify alloc] init] ;
    }) ;
    
    return sharedInstance ;
}

-(instancetype)init {
    self = [super init] ;
    if ( self ) {
        self.center = [NSNotificationCenter defaultCenter] ;
    }
    return self ;
}

#pragma mark - JDAS get JRM IP and Port Right

-(void)addJDASObserver:(id)target selector:(SEL)selector {
    [_center addObserver:target selector:selector name:QY_NOTIFICATION_JDAS_GET_IPandPORT object:nil] ;
}

-(void)removeJDASObserver:(id)target {
    [_center removeObserver:target name:QY_NOTIFICATION_JDAS_GET_IPandPORT object:nil] ;
}

-(void)postJDASNotification:(NSDictionary *)info{
    [_center postNotificationName:QY_NOTIFICATION_JDAS_GET_IPandPORT object:info] ;
}

#pragma mark -

-(void)addObserver:(id)target selector:(SEL)selector {
    [_center addObserver:target selector:selector name:@"" object:nil] ;
}

-(void)removeObserver:(id)target {
    [_center removeObserver:target] ;
}

-(void)postNotification{
    [_center postNotificationName:@"" object:nil] ;
}

@end
