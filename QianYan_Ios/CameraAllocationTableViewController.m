//
//  CameraAllocationTableViewController.m
//  相机分配
//
//  Created by WardenAllen on 15/8/4.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "CameraAllocationTableViewController.h"
#import "CameraAllocationTableViewCell.h"

@interface CameraAllocationTableViewController ()

@end

@implementation CameraAllocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CameraAllocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.isAllowed = YES;
    cell.title = @"客厅";
    
    // Configure the cell...
    
    return cell;
}

@end
