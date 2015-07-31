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

#import "QY_Common.h"
#import "CameraViewController.h"
#import "QYBaseViewController.h"
#import "AddContactViewController.h"

static NSString * const kJVDrawerCellReuseIdentifier = @"JVRightDrawerCellReuseIdentifier";

@interface JVRightDrawerTableViewController ()<QY_QRCodeScanerDelegate>

@end

@implementation JVRightDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
    
}

#pragma mark - Table View Data Source

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UIViewController *destinationViewController = nil;
    
    switch (indexPath.row) {
        case 0 : {
            //扫一扫
            UITabBarController *tbc = (UITabBarController *)[[[AppDelegate globalDelegate] drawerViewController] centerViewController] ;
            
            UINavigationController *nav = tbc.viewControllers[0] ;
            QYBaseViewController *vc = (QYBaseViewController *)nav.topViewController ;
            
            [QY_QRCodeUtils startQRScanWithNavigationController:nav Delegate:vc] ;
            
            break;
        }
            
        case 1 : {
            //添加好友
            
            NSString *VCSBID = @"AddContactViewControllerSBID" ;
            
            destinationViewController = [[AppDelegate globalDelegate] controllerWithId:VCSBID] ;
            
            [self test:destinationViewController] ;
            
            break ;
        }

            
        case 2 : {
            
            break ;
        }
            
        case 3 : {
            
            break ;
        }
            
        case 4 : {
            destinationViewController = [[AppDelegate globalDelegate] WifiSettingViewController] ;
            [self test:destinationViewController] ;
            break ;
        }
            
        default:
            break;
    }
    
    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

- (void)test:(UIViewController *)destinationViewController {
    
    UITabBarController *tbc = (UITabBarController *)[[[AppDelegate globalDelegate] drawerViewController] centerViewController] ;
    
    UINavigationController *nvc = tbc.viewControllers[0] ;
        
    UIViewController *vc = nvc.topViewController ;
    
    [vc.navigationController pushViewController:destinationViewController animated:YES] ;
}

@end
