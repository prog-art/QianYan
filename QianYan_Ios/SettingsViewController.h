//
//  SettingsViewController.h
//  QianYan_Ios
//
//  Created by WardenAllen on 15/5/24.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"

@interface SettingsViewController : UIViewController <SKSTableViewDelegate>

@property (nonatomic, weak) IBOutlet SKSTableView *tableView;

@end
