//
//  SettingsChooseCameraTableViewController.m
//  选择相机
//
//  Created by WardenAllen on 15/8/16.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "SettingsChooseCameraTableViewController.h"
#import "SettingsChooseCemeraTableViewCell.h"
#import "AppDelegate.h"

@interface SettingsChooseCameraTableViewController ()

@end

@implementation SettingsChooseCameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsChooseCemeraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.cameraImage = [UIImage imageNamed:@"设置-选择相机"];
    cell.cameraName = [NSString stringWithFormat:@"卧室相机%ld", indexPath.row + 1];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.navigationController pushViewController:[[AppDelegate globalDelegate] settingsViewController] animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
