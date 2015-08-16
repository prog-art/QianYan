//
//  ViewController.m
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import "ContactViewController.h"
#import "SWTableViewCell.h"
#import "UMTableViewCell.h"

#import "QY_Common.h"
#import "QY_contactService.h"
#import "QY_JPROHttpService.h"
#import "QY_XMLService.h"

@interface ContactViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate> {
    NSMutableArray *_sections ;
    UIRefreshControl *_refreshControl ;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView ;
@property (nonatomic, strong) UIRefreshControl *refreshControl ;
@property (nonatomic, strong) NSMutableArray *indexTitle ;

//@{friendId:QY_friendSetting} ;
@property (nonatomic) NSMutableDictionary *myFriends ;

@property (nonatomic) NSMutableArray *dataSource ;

@end

@implementation ContactViewController

#pragma mark - getter && setter

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        [_refreshControl addTarget:self action:@selector(refreshFriends:) forControlEvents:UIControlEventValueChanged] ;
        _refreshControl.tintColor = [UIColor blueColor] ;
    }
    return _refreshControl ;
}

- (NSMutableDictionary *)myFriends {
    if ( !_myFriends ) {
        _myFriends = [NSMutableDictionary dictionary] ;
        
        [[QYUser currentUser].coreUser.friendSettings enumerateObjectsUsingBlock:^(QY_friendSetting *setting, BOOL *stop) {
            [_myFriends setObject:setting forKey:setting.toFriend.userId] ;
        }] ;
        
    }
    return _myFriends ;
}

- (NSMutableArray *)dataSource {
    return _dataSource ? : ( _dataSource = [NSMutableArray array] ) ;
}

#pragma mark - UIRefreshControl Selector


- (void)refreshFriends:(UIRefreshControl *)refreshControl {
    if ( refreshControl ) {
        [refreshControl beginRefreshing] ;
    }
    
    [[QYUser currentUser].coreUser fetchFriendsComplection:^(NSArray *friendSettings, NSError *error) {
        if ( refreshControl ) {
            [refreshControl endRefreshing] ;
        }
        
        if ( friendSettings ) {
            //置空，refresh的时候会调用这个。lazy loading
            [QYUtils runInMainQueue:^{
                [self beforeReloadData] ;
            }] ;
            
#warning 临时
            [QYUtils runInGlobalQueue:^{
                
                NSMutableArray *friends = [[[QYUser currentUser].coreUser.friends allObjects] mutableCopy] ;
                [friends addObject:[QYUser currentUser].coreUser] ;
                
                NSMutableArray *friendIds = [NSMutableArray array] ;
                [friends enumerateObjectsUsingBlock:^(QY_user *user, NSUInteger idx, BOOL *stop) {
                    [friendIds addObject:user.userId] ;
                }] ;
                
                [[QY_JPROHttpService shareInstance] coverRemoteFriendList:friendIds complection:^(BOOL success, NSError *error) {
                    
                }] ;
            }] ;
            
        }
        
        if ( error ) {
            [QYUtils alertError:error] ;
        }
        
    }] ;
}

//处理数据用
- (void)beforeReloadData {
    _myFriends = nil ;
    [self.tableView reloadData] ;
}

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad] ;

    NSArray *sectionIndex = @[@"🔍", @"", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"] ;
    _indexTitle = [sectionIndex mutableCopy] ;
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem ; //左侧选择按钮
    self.tableView.rowHeight = 90 ;
    [self.tableView addSubview:self.refreshControl] ;
    
    // If you set the seperator inset on iOS 6 you get a NSInvalidArgumentException...weird
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0) ; // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    _sections = [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] mutableCopy] ;
    
    [[QY_Notify shareInstance] addFriendObserver:self selector:@selector(refresh)] ;
    
    [self beforeReloadData] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

- (void)refresh {
    [self refreshFriends:self.refreshControl] ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section <= 1 ) {
        return 1 ;
    }
    return self.myFriends.count ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}

#warning 暂时取消
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section > 1) {
//        return _sections[section-2] ;
//    } else {
//        return nil ;
//    }
//}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    tableView.sectionIndexColor = [UIColor blackColor] ;
//    tableView.sectionIndexBackgroundColor = [UIColor clearColor] ;
//    return _indexTitle ;
//}

// Show index titles

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] ;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] ;
//}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section ;
    
    switch (section) {
        case 0 : {
            UITableViewCell *searchCell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchCell"] ;
            return searchCell ;
            break ;
        }
            
        case 1 : {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
            return cell ;
            break ;
        }
            
        default : {
#warning 写法可能有点问题？
            UMTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UMCell" forIndexPath:indexPath] ;
            
            if ( !cell ) {
                QYDebugLog(@"日") ;
                cell = [[UMTableViewCell alloc] init] ;
            }
            
            // optionally specify a width that each set of utility buttons will share
            [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:90.0f] ;
            cell.delegate = self ;
            
            QY_friendSetting *friendSetting = [self.myFriends allValues][indexPath.row] ;
            
            cell.label.text = friendSetting.displayName ;
            
            [friendSetting.toFriend displayCycleAvatarAtImageView:cell.image] ;
            
            return cell ;
            break ;
        }
            
    }
    
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray array] ;
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"] ;
    
    return rightUtilityButtons ;
}

// Set row height on an individual basis

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44. ;
    } else {
        return 75. ;
    }
}


//
//- (CGFloat)rowHeightForIndexPath:(NSIndexPath *)indexPath {
//    return ([indexPath row] * 10) + 60 ;
//}

#pragma mark - SWTableViewDelegate

//- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
//    switch (state) {
//        case 0:
//            NSLog(@"utility buttons closed") ;
//            break ;
//        case 1:
//            NSLog(@"left utility buttons open") ;
//            break ;
//        case 2:
//            NSLog(@"right utility buttons open") ;
//            break ;
//        default:
//            break ;
//    }
//}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0 : {
            // Delete button was pressed
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell] ;
            
            QY_friendSetting *friendSetting = [self.myFriends allValues][indexPath.row] ;
            
            [SVProgressHUD show] ;
            [[QYUser currentUser].coreUser deleteFriendById:friendSetting.toFriend.userId complection:^(BOOL success, NSError *error) {
                [SVProgressHUD dismiss] ;
                if ( success ) {
                    [QYUtils alert:@"删除好友成功"] ;
#warning 改成删除单个
                    [self refreshFriends:self.refreshControl] ;
                } else {
                    QYDebugLog(@"删除好友失败 error = %@",error) ;
                    [QYUtils alertError:error] ;
                }
            }] ;            
            break ;
        }
    
        default:
            break ;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
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