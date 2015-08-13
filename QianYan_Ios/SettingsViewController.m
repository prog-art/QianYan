//
//  SettingsViewController.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/5/24.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "SettingsViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "SliderTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "OnlyButtonTableViewCell.h"

@interface SettingsViewController () <SKSTableViewDelegate>

@end

@implementation SettingsViewController

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ;
    if (self) {
    }
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.SKSTableViewDelegate = self ;
    self.tableView.tableFooterView = [[UIView alloc] init] ;//关键语句
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 7) {
        return 3;
    } else {
        return 0;
    }
}

#pragma mark - Table View Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
#warning !!!!
    switch (indexPath.row) {
        case 0 : {
            SwitchTableViewCell *switchCell = [[[NSBundle mainBundle]loadNibNamed:@"SwitchTableViewCell" owner:self options:nil] lastObject] ;
            switchCell.title = @"报警通知" ;
            return switchCell;
            break ;
        }
            
        case 1 : {
            SwitchTableViewCell *switchCell = [[[NSBundle mainBundle]loadNibNamed:@"SwitchTableViewCell" owner:self options:nil] lastObject] ;
            switchCell.title = @"指示灯" ;
            return switchCell;
            break ;
        }

        case 2 : {
            SKSTableViewCell *cell = [[SKSTableViewCell alloc] init];
            
            cell.textLabel.text = @"分辨率";
            if (indexPath.row == 2) {
                cell.isExpandable = YES;
            } else {
                cell.isExpandable = NO;
            }
            return cell;
            break ;
        }

        case 3 : {
            SliderTableViewCell *sliderCell = [[[NSBundle mainBundle]loadNibNamed:@"SliderTableViewCell" owner:self options:nil] lastObject];
            sliderCell.title = @"亮度" ;
            sliderCell.minImage = [UIImage imageNamed:@"最小亮度.png"];
            sliderCell.maxImage = [UIImage imageNamed:@"最大亮度.png"];
            return sliderCell ;
            break ;
        }

        case 4 : {
            SliderTableViewCell *sliderCell = [[[NSBundle mainBundle]loadNibNamed:@"SliderTableViewCell" owner:self options:nil] lastObject];
            sliderCell.title = @"对比度";
            sliderCell.minImage = [UIImage imageNamed:@"最小对比度.png"];
            sliderCell.maxImage = [UIImage imageNamed:@"最大对比度.png"];
            return sliderCell ;
            break ;
        }
            
        case 5 : {
            SliderTableViewCell *sliderCell = [[[NSBundle mainBundle]loadNibNamed:@"SliderTableViewCell" owner:self options:nil] lastObject];
            sliderCell.title = @"麦克风音量";
            sliderCell.minImage = [UIImage imageNamed:@"最小麦克风音量.png"];
            sliderCell.maxImage = [UIImage imageNamed:@"最大麦克风音量.png"];
            return sliderCell ;
            break ;
        }

        case 6 : {
            SliderTableViewCell *sliderCell = [[[NSBundle mainBundle]loadNibNamed:@"SliderTableViewCell" owner:self options:nil] lastObject];
            sliderCell.title = @"扬声器音量";
            sliderCell.minImage = [UIImage imageNamed:@"最小扬声器音量.png"];
            sliderCell.maxImage = [UIImage imageNamed:@"最大扬声器音量.png"];
            return sliderCell ;
            break ;
        }
    
        case 7 : {
            SKSTableViewCell *cell = [[SKSTableViewCell alloc] init] ;
            cell.textLabel.text = @"码率设置";
            if (indexPath.row == 7) {
                cell.isExpandable = YES;
            }
            return cell;
            break ;
        }

        case 8 : {
            SKSTableViewCell *cell = [[SKSTableViewCell alloc] init] ;
            cell.textLabel.text = @"摄像机WIFI列表";
            cell.isExpandable = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            break ;
        }

        case 9 : {
            ButtonTableViewCell *buttonCell = [[ButtonTableViewCell alloc] init] ;
            buttonCell.title = @"重启";
            buttonCell.buttonImage = [UIImage imageNamed:@"重启.png"];
            return buttonCell ;
            break ;
        }

        case 10 : {
            ButtonTableViewCell *buttonCell = [[ButtonTableViewCell alloc] init] ;
            buttonCell.title = @"恢复";
            buttonCell.buttonImage = [UIImage imageNamed:@"恢复.png"];
            return buttonCell ;
            break ;
        }

        case 11 : {
            
            OnlyButtonTableViewCell *onlyButtonCell = [[[NSBundle mainBundle]loadNibNamed:@"OnlyButtonTableViewCell" owner:self options:nil] lastObject] ;
            return onlyButtonCell ;
            break ;
        }
            
        default:
            break;
    }

    return nil ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"分辨率 %ld", (long)indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else if (indexPath.row == 7) {
        cell.textLabel.text = [NSString stringWithFormat:@"码率 %ld", (long)indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        return cell;
    }
}

#pragma mark -- Back Button

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

@end