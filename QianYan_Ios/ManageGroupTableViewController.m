//
//  ManageGroupTableViewController.m
//  群组管理
//
//  Created by WardenAllen on 15/8/12.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "ManageGroupTableViewController.h"
#import "ManageGroupTableViewCell.h"
#import "ManageGroupSearchTableViewCell.h"
#import "QY_Common.h"

@interface ManageGroupTableViewController ()


@property (nonatomic,strong) NSMutableArray *dataSource ;

@end

@implementation ManageGroupTableViewController

#pragma mark - getter && setter 

- (NSMutableArray *)friends {
    return _friends ? : (_friends = [NSMutableArray array] ) ;
}

- (NSMutableArray *)dataSource {
    return _dataSource ? : (_dataSource = [NSMutableArray array] ) ;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    NSMutableSet *friends = [[[QYUser currentUser].coreUser friends] mutableCopy] ;
    
    NSSet *groups = [[QYUser currentUser].coreUser friendGroups] ;
    [groups enumerateObjectsUsingBlock:^(QY_friendGroup *group, BOOL *stop) {
        [group.containUsers enumerateObjectsUsingBlock:^(QY_user *user, BOOL *stop) {
            [friends removeObject:user] ;
        }] ;
    }] ;
    
    [self.friends enumerateObjectsUsingBlock:^(QY_user *user, NSUInteger idx, BOOL *stop) {
        [self.dataSource addObject:@{@"user":user,
                                     @"choosed":@(true)}] ;
    }] ;
    
    [friends enumerateObjectsUsingBlock:^(QY_user *user, BOOL *stop) {
        [self.dataSource addObject:@{@"user":user,
                                     @"choosed":@(FALSE)}] ;
    }] ;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44.;
    } else {
        return 66.;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ManageGroupSearchTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
        return searchCell;
    } else {
        ManageGroupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        QY_user *user = self.dataSource[indexPath.row-1][@"user"] ;
        BOOL choosed = [self.dataSource[indexPath.row-1][@"choosed"] boolValue] ;
        
        
        cell.name = user.displayName ;
        [user displayCycleAvatarAtImageView:cell.avatarImageView] ;
        
        
        cell.isChosen = choosed ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexpath.row:%ld", (long)indexPath.row);
    
    ManageGroupTableViewCell *cell = (ManageGroupTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row > 0) {
        
        BOOL choosed = [self.dataSource[indexPath.row-1][@"choosed"] boolValue] ;
        choosed = choosed ^ 1 ;
        
        QY_user *user = self.dataSource[indexPath.row-1][@"user"] ;
        
        [self.dataSource replaceObjectAtIndex:(indexPath.row - 1) withObject:@{@"user":user,
                                                                               @"choosed":@(choosed)}] ;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)saveBtnClicked:(id)sender {
    
    NSMutableSet *choosedFriends = [NSMutableSet set] ;
    [self.dataSource enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
        BOOL choosed = [dic[@"choosed"] boolValue] ;
        if ( choosed ) {
            QY_user *user = dic[@"user"] ;
            [choosedFriends addObject:user] ;
        }
    }] ;
    
    [self.group setContainUsers:choosedFriends] ;
    
    [SVProgressHUD show] ;
    [[QYUser currentUser].coreUser saveFriendGroupInBackGroundComplection:^(BOOL success, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( success ) {
            [QYUtils alert:@"保存成功"] ;
            [QY_appDataCenter saveObject:nil error:NULL] ;
            [self.navigationController popViewControllerAnimated:YES] ;
        } else {
            [QY_appDataCenter undo] ;
            [QYUtils alertError:error] ;
        }
    }] ;
    
}


@end
