//
//  ViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "ViewController.h"

#import "QY_SocketService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error ;
    [[QY_SocketService shareInstance] connectToHost:&error] ;
    
//    [[QY_SocketService shareInstance] sendMessage] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
