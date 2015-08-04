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


#import "QY_Common.h"
#import "QY_XMLService.h"
#import "SearchFriendTableViewController.h"

#define kTelephoneLen 11
#define kUserIdLen    8


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
    [self searchWithText:searchBar.text];
    [searchBar resignFirstResponder] ;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchWithText:(NSString *)text {
    
#warning 现只允许搜索userId
    NSString *path = [QY_JPROUrlFactor pathForUserProfile:text] ;
    
    if ( [text isEqualToString:[QYUser currentUser].coreUser.userId ]) {
        [QYUtils alert:@"这是你自己(・Д・)ノ"] ;
    }
    
    [[QY_JPROHttpService shareInstance] downloadFileFromPath:path complection:^(NSString *xmlStr, NSError *error) {
        if ( xmlStr ) {
            NSError *phraseError ;
            
            QY_user *user = [QY_user insertUserById:text] ;
            
            [QY_XMLService initUser:user withProfileXMLStr:xmlStr error:&phraseError] ;
            
            //save
            [QY_appDataCenter saveObject:nil error:NULL] ;
            
            if ( !phraseError && user ) {
                UIViewController *vc = [SearchFriendTableViewController viewControllerWithUser:user] ;
                
                [self.navigationController pushViewController:vc animated:YES] ;
            } else {
                [QYUtils alert:@"查无此人"] ;
            }
        } else {
            [QYUtils alert:@"查无此人"] ;
        }
    }] ;

}

#pragma mark -- Table View Datasource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#warning 待重写
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
    
    switch ( indexPath.row ) {
        case 0 : {
            //添加手机联系人
            destinationViewController = [[AppDelegate globalDelegate] ContactTableViewController];
            [self.navigationController pushViewController:destinationViewController animated:YES] ;
            break;
        }

        case 1 : {
            //扫一扫
            [QY_QRCodeUtils startQRScanWithNavigationController:self.navigationController Delegate:self] ;
            break ;
        }
            
        case 2 : {
            //添加公众号
            [QYUtils alert:@"未开放，敬请期待d(^_^o)"] ;
            break ;
        }
            
        default:
            break;
    }    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

@end