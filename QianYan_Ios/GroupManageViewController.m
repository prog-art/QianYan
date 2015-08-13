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
    NSMutableArray *_testArray ;
    UIRefreshControl *_refreshControl ;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView ;
@property (nonatomic, strong) UIRefreshControl *refreshControl ;

@end

@implementation GroupManageViewController

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
    [refreshControl beginRefreshing] ;
    //    self.useCustomCells = !self.useCustomCells ;
    //    if (self.useCustomCells)
    //    {
    //        self.refreshControl.tintColor = [UIColor yellowColor] ;
    //    }
    //    else
    //    {
    //        self.refreshControl.tintColor = [UIColor blueColor] ;
    //    }
    [self.tableView reloadData] ;
    [refreshControl endRefreshing] ;
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem ; //左侧选择按钮
    self.tableView.rowHeight = 90 ;
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:245/255.0 alpha:1] ;
    
    // If you set the seperator inset on iOS 6 you get a NSInvalidArgumentException...weird
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0) ; // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    _testArray = [NSMutableArray array] ;
    
    for (int i = 0 ; i < 100 ; ++i) {
        NSString *string = [NSString stringWithFormat:@"%d", i] ;
        [_testArray addObject:string] ;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_testArray count] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %ld:%ld", (long)indexPath.section, (long)indexPath.row) ;
    NSLog(@"selected cell index path is %@", [self.tableView indexPathForSelectedRow]) ;
    
    [self.navigationController pushViewController:[[AppDelegate globalDelegate] GroupInfoViewController] animated:YES] ;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}

#pragma mark - UIScrollViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupManageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UMCell" forIndexPath:indexPath] ;
    
    // optionally specify a width that each set of utility buttons will share
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:85.0f] ;
    cell.delegate = self ;
    
    cell.numberOfFriendsLabel.text = _testArray[indexPath.row] ;
    
    return cell ;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray array] ;
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:251/255.0 green:70/255.0 blue:78/255.0 alpha:1.0f]
                                                    icon:[UIImage imageNamed:@"群组管理-删除按钮.png"]] ;
    
    return rightUtilityButtons ;
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
    
    [_testArray removeObjectAtIndex:cellIndexPath.row] ;
    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft] ;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES ;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES ;
            break ;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES ;
            break ;
        default:
            break ;
    }
    
    return YES ;
}

@end