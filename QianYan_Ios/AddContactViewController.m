//
//  AddContactViewController.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/6/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AddContactViewController.h"
#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import "SettingsViewController.h"

@interface AddContactViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *addContactTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBar.delegate = self;

    _addContactTableView.dataSource = self;
    _addContactTableView.delegate = self;
    _addContactTableView.tableFooterView = [[UIView alloc] init] ;//关键语句

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark -- Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder] ;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

}

#pragma mark -- Table View Datasource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *firstCell = [_addContactTableView dequeueReusableCellWithIdentifier:@"FirstCell"];
    UITableViewCell *secondCell = [_addContactTableView dequeueReusableCellWithIdentifier:@"SecondCell"];
    UITableViewCell *thirdCell = [_addContactTableView dequeueReusableCellWithIdentifier:@"ThirdCell"];

    if (indexPath.row == 0) {
        return firstCell;
    } else if (indexPath.row == 1) {
        return secondCell;
    } else {
        return thirdCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewController *destinationViewController = nil;
    
    if (indexPath.row == 0) {
        destinationViewController = [[AppDelegate globalDelegate] ContactTableViewController];
        [self.navigationController pushViewController:destinationViewController animated:YES] ;
    }
}

@end
