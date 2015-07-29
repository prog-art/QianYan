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

@property (atomic) NSMutableDictionary *myFriends ;

@end

@implementation ContactViewController

#pragma mark - getter && setter

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        [_refreshControl addTarget:self action:@selector(refreshFriends:) forControlEvents:UIControlEventValueChanged];
        _refreshControl.tintColor = [UIColor blueColor];
    }
    return _refreshControl ;
}

#pragma mark - UIRefreshControl Selector

- (void)refreshFriends:(UIRefreshControl *)refreshControl {
    if ( refreshControl ) {
        [refreshControl beginRefreshing] ;
    }
    
    NSString *path = [NSString stringWithFormat:@"user/%@/friendlist",[QYUser currentUser].userId] ;
    
    [[QY_JPROHttpService shareInstance] getDocumentListForPath:path Complection:^(NSArray *objects, NSError *error) {
        
        if ( refreshControl ) {
            [refreshControl endRefreshing] ;
        }
        
        if ( objects ) {
            QYDebugLog(@"friendList = %@",objects) ;
            [self fetchUserInfo:objects] ;
            
        } else {
            QYDebugLog(@"erro = %@",error) ;
            [QYUtils alertError:error] ;
        }
        
    }] ;
    
}

- (void)fetchUserInfo:(NSArray *)friends {
    //@[100000133.xml]
    
    //check
    NSMutableArray *noDataFriendNames = [NSMutableArray array] ;
    
    [friends enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
        NSString *tempFileName = [fileName stringByDeletingPathExtension] ;
        QY_user *localFriend = [QY_user findUserById:tempFileName] ;
        
        if ( localFriend ) {
            [self.myFriends setObject:localFriend forKey:tempFileName] ;
            QYDebugLog(@"localFriend = %@",localFriend) ;
        } else {
            [noDataFriendNames addObject:fileName] ;
        }
    }] ;
    
    QYDebugLog(@"noDataFriendNames = %@",noDataFriendNames) ;
    
    //没有数据的去服务器拿
    
    dispatch_group_t group = dispatch_group_create() ;
    [noDataFriendNames enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
        
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            NSString *path = [NSString stringWithFormat:@"user/%@/friendlist/%@",[QYUser currentUser].userId,fileName] ;
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
            
            [[QY_JPROHttpService shareInstance] downloadFileFromPath:path complection:^(NSString *xmlStr , NSError *error) {
                if ( xmlStr ) {
                    QYDebugLog(@"file = %@,content = %@",fileName,xmlStr) ;
                    QY_friendSetting *friendSetting = [QY_XMLService getSesttingFromIdXML:xmlStr] ;
                
                    QY_user *friend = friendSetting.toFriend ;
                    
                    QYDebugLog(@"friend = %@",friend) ;
                    
                    [self.myFriends setObject:friend forKey:friend.userId] ;
                    
                } else {
                    QYDebugLog(@"error = %@",error) ;
                }
                dispatch_semaphore_signal(sema) ;
            }] ;
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC) ;
            dispatch_semaphore_wait(sema, timeout) ;
            QYDebugLog(@"group %lu ok",(unsigned long)idx) ;
        }) ;
    }] ;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        QYDebugLog(@"请求结束！") ;
        [self didReceiveUserData] ;
    }) ;
}

- (void)didReceiveUserData {
    QYDebugLog(@"接收到了所有的数据。") ;

    [self.refreshControl endRefreshing] ;
    [self.tableView reloadData] ;
    
    [QY_appDataCenter saveObject:nil error:NULL] ;
}


#pragma mark - life Cycle

- (void)getFriendsFromDataBase {
    self.myFriends = [NSMutableDictionary dictionary] ;
    
    QYUser *curUser = [QYUser currentUser] ;
    
    QY_user *coreUser = curUser.coreUser ;
    
    NSArray *friendsArr = [coreUser.friends allObjects] ;

    [friendsArr enumerateObjectsUsingBlock:^(QY_user *friend, NSUInteger idx, BOOL *stop) {
        [self.myFriends setObject:friend forKey:friend.userId] ;
    }] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFriendsFromDataBase] ;
    
    
    NSArray *sectionIndex = @[@"🔍", @"", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"] ;
    _indexTitle = [sectionIndex mutableCopy] ;
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem; //左侧选择按钮
    self.tableView.rowHeight = 90;
    [self.tableView addSubview:self.refreshControl] ;
    
    // If you set the seperator inset on iOS 6 you get a NSInvalidArgumentException...weird
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    _sections = [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] mutableCopy] ;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
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
//    NSLog(@"cell selected at index path %ld:%ld", (long)indexPath.section, (long)indexPath.row);
//    NSLog(@"selected cell index path is %@", [self.tableView indexPathForSelectedRow]);
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#warning 暂时取消
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section > 1) {
//        return _sections[section-2];
//    } else {
//        return nil;
//    }
//}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    tableView.sectionIndexColor = [UIColor blackColor];
//    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    return _indexTitle;
//}

// Show index titles

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section ;
    
    switch (section) {
        case 0 : {
            UITableViewCell *searchCell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
            return searchCell ;
            break ;
        }
            
        case 1 : {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
            return cell;
            break ;
        }
            
        default : {
            UMTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UMCell" forIndexPath:indexPath];
            
            if ( !cell ) {
                cell = [[UMTableViewCell alloc] init] ;
            }
            
            // optionally specify a width that each set of utility buttons will share
            [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:90.0f];
            cell.delegate = self;
            
            
            QY_user *friend = [self.myFriends allValues][indexPath.row] ;
            
            cell.label.text = friend.userName ;
            
            return cell;
            break ;
        }
            
    }
    
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray array] ;
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"] ;
    
    return rightUtilityButtons;
}

// Set row height on an individual basis

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.;
    } else {
        return 75.;
    }
}


//
//- (CGFloat)rowHeightForIndexPath:(NSIndexPath *)indexPath {
//    return ([indexPath row] * 10) + 60;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want default white
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0 : {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [QYUtils alert:@"删除好友正在做～"] ;
            
//            [_testArray[cellIndexPath.section-2] removeObjectAtIndex:cellIndexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            
//            //删除section
//            if([_testArray [cellIndexPath.section-2] count] == 0) {
//                [_sections removeObjectAtIndex:cellIndexPath.section -2];
//                [_testArray removeObjectAtIndex:cellIndexPath.section-2];
//                [_indexTitle removeObjectAtIndex:cellIndexPath.section];
//                NSLog(@"%ld", cellIndexPath.section-2);
//                
//                [self.tableView reloadSectionIndexTitles];
//                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:cellIndexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
//            }
            
            break;
        }
    
        default:
            break ;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


@end