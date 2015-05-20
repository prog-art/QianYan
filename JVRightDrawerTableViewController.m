//
//  JVRightDrawerTableViewController.m
//  JVFloatingDrawer
//
//  Created by WardenAllen on 15/5/18.
//  Copyright (c) 2015年 JVillella. All rights reserved.
//

#import "JVRightDrawerTableViewController.h"
#import "JVRightDrawerTableViewCell.h"
#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"

static NSString * const kJVDrawerCellReuseIdentifier = @"JVRightDrawerCellReuseIdentifier";

@interface JVRightDrawerTableViewController ()

@end

@implementation JVRightDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JVRightDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJVDrawerCellReuseIdentifier forIndexPath:indexPath];
    
    
    
    switch (indexPath.row) {
        case 0:
            cell.titleText = @"扫一扫";
            cell.iconImage = [UIImage imageNamed:@"我的好友.png"];
            break;
            
        case 1:
            cell.titleText = @"添加好友";
            cell.iconImage = [UIImage imageNamed:@"我的相册.png"];
            break;
            
        case 2:
            cell.titleText = @"添加相机";
            cell.iconImage = [UIImage imageNamed:@"录像计划.png"];
            break;
            
        case 3:
            cell.titleText = @"添加相机分组";
            cell.iconImage = [UIImage imageNamed:@"摄像机权限管理.png"];
            break;
            
        case 4:
            cell.titleText = @"WIFI配置";
            cell.iconImage = [UIImage imageNamed:@"设置.png"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Actions

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIViewController *destinationViewController = nil;
//    
//    switch (indexPath.row) {
//        case 0:
//            destinationViewController = [[AppDelegate globalDelegate] drawerSettingsViewController];
//            break;
//        case 1:
//            destinationViewController = [[AppDelegate globalDelegate] drawerSettingsViewController];
//            break;
//        case 2:
//            destinationViewController = [[AppDelegate globalDelegate] drawerSettingsViewController];
//            break;
//        case 3:
//            destinationViewController = [[AppDelegate globalDelegate] drawerSettingsViewController];
//            break;
//        case 4:
//            destinationViewController = [[AppDelegate globalDelegate] drawerSettingsViewController];
//            break;
//            
//        default:
//            break;
//    }
//    
//    [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:destinationViewController];
//    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
//}


@end
