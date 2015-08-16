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
#import "GroupInfoViewController.h"

#import "QY_Common.h"

@interface GroupManageViewController () <UIAlertViewDelegate>{
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

#pragma mark - IBActions

- (void)toggleCells:(UIRefreshControl*)refreshControl {
    
    [self.curUser fetchFriendGroupComplection:^(BOOL success, NSError *error) {
        [refreshControl endRefreshing] ;
        if ( success ) {
            self.dataSource = [NSMutableArray arrayWithArray:[self.curUser.friendGroups allObjects]] ;
            [self.tableView reloadData] ;
        } else {
            [QYUtils alertError:error] ;
        }
    }] ;
}

- (IBAction)createGroupBtnClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新建群组" message:@"请输入群组名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput ;
    
    [alertView show] ;
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

    [self.tableView addSubview:self.refreshControl] ;
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
    QY_friendGroup *group = self.dataSource[indexPath.row] ;
    
    GroupInfoViewController *vc = (id)[[AppDelegate globalDelegate] GroupInfoViewController] ;
    vc.group = group ;
    [self.navigationController pushViewController:vc animated:YES] ;
    
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell] ;
    
    QY_friendGroup *group = self.dataSource[indexPath.row] ;
    [self.curUser removeFriendGroupsObject:group] ;
    [SVProgressHUD show] ;
    WEAKSELF
    [self.curUser saveFriendGroupInBackGroundComplection:^(BOOL success, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( success ) {
            [QYUtils alert:@"删除成功"] ;
            [QY_appDataCenter saveObject:nil error:NULL] ;
            [weakSelf.dataSource removeObjectAtIndex:indexPath.row] ;
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        } else {
            [QYUtils alertError:error] ;
            [QY_appDataCenter undo] ;
        }
    }] ;
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

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != alertView.cancelButtonIndex ) {
        NSString *groupName = [alertView textFieldAtIndex:0].text ;
        if ( groupName.length == 0 ) {
            [QYUtils alert:@"请输入群组名称"] ;
            return ;
        }
        
        [SVProgressHUD show] ;
        [self.curUser createAFriendGroupWithGroupName:groupName complection:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss] ;
            if ( success ) {
                self.dataSource = [NSMutableArray arrayWithArray:[self.curUser.friendGroups allObjects]] ; ;
                [self.tableView reloadData] ;
            } else {
                QYDebugLog(@"error = %@",error) ;
                [QYUtils alertError:error] ;
            }
        }] ;
    }
}

@end