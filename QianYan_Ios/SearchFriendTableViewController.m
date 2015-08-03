//
//  SearchFriendTableViewController.m
//  好友搜索
//
//  Created by WardenAllen on 15/8/3.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "SearchFriendTableViewController.h"
#import "SearchFriendTableViewCell.h"

@interface SearchFriendTableViewController () <UIAlertViewDelegate>

@end

@implementation SearchFriendTableViewController

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
    SearchFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.name = @"Allen";
            return cell;
            break;
            
        case 1:
            cell.name = @"Allen Warden";
            return cell;
            break;
            
        case 2:
            cell.name = @"Allen Wang";
            return cell;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self searchWithIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchWithIndex:(NSInteger) index {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先填写账号!"
//                                                    message:nil
//                                                   delegate:self
//                                          cancelButtonTitle:@"取消"
//                                          otherButtonTitles:@"确定",nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    //UITextField *textField = [alert textFieldAtIndex:0];
//    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
            
        case 1:
            
            break;
            
        default:
            break;
    }
}

@end
