//
//  SearchFriendTableViewController.m
//  好友搜索
//
//  Created by WardenAllen on 15/8/3.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "SearchFriendTableViewController.h"
#import "SearchFriendTableViewCell.h"

#import "QY_Common.h"
#import "AppDelegate.h"

@interface SearchFriendTableViewController ()<UIAlertViewDelegate>

@property QY_user *searchedUser ;

@end

@implementation SearchFriendTableViewController

+ (SearchFriendTableViewController *)viewControllerWithUser:(QY_user *)user {
    assert(user) ;
    SearchFriendTableViewController *vc = (id)[[AppDelegate globalDelegate] SearchFriendTableViewController] ;
    vc.searchedUser = user ;
    return vc ;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath] ;
    cell.name = self.searchedUser.nickname ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *message = [NSString stringWithFormat:@"用户名:%@",self.searchedUser.nickname] ;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否添加好友" message:message delegate:self cancelButtonTitle:@"手滑了" otherButtonTitles:@"确认", nil] ;
    [alertView show] ;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != alertView.cancelButtonIndex ) {
        if ( [[QYUser currentUser].coreUser.friends containsObject:self.searchedUser]) {
            [QYUtils alert:@"已经是好友了～"] ;
        } else {
            [[QYUser currentUser].coreUser addFriendById:self.searchedUser.userId complection:^(BOOL success, NSError *error) {
                if ( success ) {
                    QYDebugLog(@"添加好友成功") ;
                    [QYUtils alert:@"添加好友成功"] ;
                    [[QY_Notify shareInstance] postFriendNotify] ;
                    [self.navigationController popViewControllerAnimated:YES] ;
                } else {
                    [QYUtils alertError:error] ;
                }
            }] ;
        }
    }
}

@end
