//
//  RacentTableViewController.m
//  最近查看
//
//  Created by WardenAllen on 15/6/22.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "RacentTableViewController.h"
#import "RacentTableViewCell.h"

@interface RacentTableViewController ()

@end

@implementation RacentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init] ;//关键语句
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 107.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RacentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.cameraImageView.image = [UIImage imageNamed:@"最近查看-1.png"];
            cell.cameraNameLabel.text = @"客厅";
            cell.cameraStateImageView.image = [UIImage imageNamed:@"我自己的相机.png"];
            break;
            
        case 1:
            cell.cameraImageView.image = [UIImage imageNamed:@"最近查看-2.png"];
            cell.cameraNameLabel.text = @"卧室";
            cell.cameraStateImageView.image = [UIImage imageNamed:@"在线分享-1.png"];
            break;
            
        case 2:
            cell.cameraImageView.image = [UIImage imageNamed:@"最近查看-3.png"];
            cell.cameraNameLabel.text = @"工作室";
            cell.cameraStateImageView.image = [UIImage imageNamed:@"在线分享-2.png"];
            break;
            
        case 3:
            cell.cameraImageView.image = [UIImage imageNamed:@"最近查看-3.png"];
            cell.cameraNameLabel.text = @"爸妈家";
            cell.cameraStateImageView.image = [UIImage imageNamed:@"在线分享-2.png"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
