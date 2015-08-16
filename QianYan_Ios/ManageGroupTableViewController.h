//
//  ManageGroupTableViewController.h
//  群组管理
//
//  Created by WardenAllen on 15/8/12.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QY_friendGroup ;

@interface ManageGroupTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *friends ;
@property (strong,nonatomic) QY_friendGroup *group ;

@end
