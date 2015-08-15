//
//  ViewController.m
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import "GroupManageViewController.h"
#import "SWTableViewCell.h"
#import "GroupManageTableViewCell.h"
#import "AppDelegate.h"

#import "QY_Common.h"

@interface GroupManageViewController () {
    UIRefreshControl *_refreshControl ;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView ;
@property (nonatomic, strong) UIRefreshControl *refreshControl ;

@property (nonatomic) NSMutableArray *dataSource ;
@property (weak) QY_user *curUser ;

@end

@implementation GroupManageViewController

#pragma mark - getter && setter

- (NSMutableArray *)dataSource {
    return _dataSource ? : ( _dataSource = [NSMutableArray array] ) ;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray array] ;
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:251/255.0 green:70/255.0 blue:78/255.0 alpha:1.0f]
                                                 icon:[UIImage imageNamed:@"群组管理-删除按钮.png"]] ;
    
    return rightUtilityButtons ;
}

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        
        [_refreshControl addTarget:self action:@selector(toggleCells:) forControlEvents:UIControlEventValueChanged] ;
        _refreshControl.tintColor = [UIColor blueColor] ;
    }
    return _refreshControl ;
}

#pragma mark - UIRefreshControl Selector

- (void)toggleCells:(UIRefreshControl*)refreshControl {
    self.dataSource = [NSMutableArray arrayWithArray:[self.curUser.friendGroups allObjects] ] ;
    [refreshControl endRefreshing] ;
    [self.tableView reloadData] ;
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.curUser = [QYUser currentUser].coreUser ;
    //self.navigationItem.leftBarButtonItem = self.editButtonItem ; //左侧选择按钮
    self.tableView.rowHeight = 90 ;
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:245/255.0 alpha:1] ;
    
    // If you set the seperator inset on iOS 6 you get a NSInvalidArgumentException...weird
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0) ; // Makes the horizontal row seperator stretch the entire length of the table view
    }

    self.dataSource = [NSMutableArray arrayWithArray:[self.curUser.friendGroups allObjects]] ;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupManageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UMCell" forIndexPath:indexPath] ;
    
    // optionally specify a width that each set of utility buttons will share
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:85.0f] ;
    cell.delegate = self ;
    
    QY_friendGroup *group = self.dataSource[indexPath.row] ;
    cell.groupNameLabel.text = group.groupName ;
    cell.numberOfFriendsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)group.containUsers.count] ;
    
    return cell ;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %ld:%ld", (long)indexPath.section, (long)indexPath.row) ;
    NSLog(@"selected cell index path is %@", [self.tableView indexPathForSelectedRow]) ;
    
    [self.navigationController pushViewController:[[AppDelegate globalDelegate] GroupInfoViewController] animated:YES] ;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

// Set row height on an individual basis

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64. ;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    switch (state) {
        case 0 :
            NSLog(@"utility buttons closed") ;
            break ;
        case 1 :
            NSLog(@"left utility buttons open") ;
            break ;
        case 2 :
            NSLog(@"right utility buttons open") ;
            break ;
        default:
            break ;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell] ;
    
    [QYUtils alert:@"点击了删除～正在施工！"] ;
//    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft] ;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES ;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1 :
            // set to NO to disable all left utility buttons appearing
            return YES ;
            break ;
        case 2 :
            // set to NO to disable all right utility buttons appearing
            return YES ;
            break ;
        default:
            break ;
    }
    
    return YES ;
}

@end