//
//  SystemSettingsTableViewController.m
//  
//
//  Created by WardenAllen on 15/6/3.
//
//

#import "SystemSettingsTableViewController.h"
#import "SystemSettingsTableViewCell.h"
#import "SystemSettingsImageTableViewCell.h"
#import "SettingsViewController.h"
#import "AccountInfoViewController.h"
#import "AppDelegate.h"

#import "QY_Common.h"

@interface SystemSettingsTableViewController ()

@end

@implementation SystemSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[QY_Notify shareInstance] addAvatarObserver:self selector:@selector(reloadAvatar)] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)reloadAvatar {
#warning 能改成upload单个吗？
    [self.tableView reloadData] ;
}

- (void)dealloc {
    [[QY_Notify shareInstance] removeAvatarObserver:self] ;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SystemSettingsImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    SystemSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (indexPath.section == 0) {        
        [[QYUser currentUser].coreUser displayCycleAvatarAtImageView:imageCell.imageView] ;
        return imageCell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.settingsText = @"联系人、隐私";
            return cell;
        } else {
            cell.settingsText = @"密码管理";
            return cell;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.settingsText = @"摄像机参数设置";
            return cell;
        } else {
            cell.settingsText = @"摄像机Wifi设置";
            return cell;
        }
    } else {
        cell.settingsText = @"开通付费功能";
        return cell;
    }
}

#pragma mark -- Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:[[AppDelegate globalDelegate] AccountInfoViewController] animated:YES];
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    break;
                    
                case 1:
                    [self.navigationController pushViewController:[[AppDelegate globalDelegate] PasswordManageViewController] animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:[[AppDelegate globalDelegate] settingsViewController] animated:YES];
                    break;
                    
                case 1:
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 3:
            break;
            
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- Back Button

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

@end
