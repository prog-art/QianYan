//
//  JVRightDrawerTableViewController.m
//  JVFloatingDrawer
//
//  Created by WardenAllen on 15/5/18.
//  Copyright (c) 2015年 JVillella. All rights reserved.
//

#import "ContactTableViewController.h"
#import "ContactTableViewCell.h"

#import "QY_contactService.h"


static NSString * const ContactTableViewCellReuseIdentifier = @"ContactTableViewCellReuseIdentifier";

@interface ContactTableViewController () <UISearchBarDelegate,QY_contactUtilsDelegate,ContactTableViewCellDelegate> {
    QY_contactUtils *_utils ;
    
    NSMutableArray *_dataSourceOfContact ;//NSArray <QY_AddressBook> 联系人数组
    NSMutableArray *_displayDataSourceOfContact ;//上述的显示部分。

}

@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchBar;

@end

@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    _dataSourceOfContact = [NSMutableArray array] ;
    _displayDataSourceOfContact = _dataSourceOfContact ;
    
    _utils = [[QY_contactUtils alloc] initWithDelegate:self] ;
    [_utils getContacts] ;

    self.contactSearchBar.delegate = self ;
    
}

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder] ;
    [self.tableView reloadData] ;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""]) {
        _displayDataSourceOfContact = _dataSourceOfContact ;
        
    } else {
        _displayDataSourceOfContact = [NSMutableArray array] ;
        
        for (QY_Contact *addressBook in _dataSourceOfContact ) {
            NSString *name = [addressBook.name lowercaseString] ;
            
            if ([name containsString:searchText] || [addressBook.tel containsString:searchText]) {
                [_displayDataSourceOfContact addObject:addressBook] ;
            }
        }
    }
    [self.tableView reloadData] ;
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayDataSourceOfContact.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    QY_Contact *addressBook = _displayDataSourceOfContact[indexPath.row] ;

    
    cell.name = addressBook.name ;
    cell.tel = addressBook.tel ;
    cell.userId = addressBook.qy_userId ;

    cell.delegate = self ;
    cell.tag = indexPath.row ;
    
    return cell;
}

#pragma mark - Actions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - QY_contactUtilsDelegate

- (void)didReceiveContactsSuccess:(BOOL)success Contacts:(NSArray *)contacts {
    if ( success ) {
        _dataSourceOfContact = [contacts mutableCopy] ;
        _displayDataSourceOfContact = _dataSourceOfContact ;
        [self.tableView reloadData] ;
    }
}

#pragma mark - ContactTableViewCellDelegate

- (void)didClickedInviteBtn:(ContactTableViewCell *)cell atIndex:(NSInteger)index {
    QY_Contact *addressBook = _displayDataSourceOfContact[index] ;
    NSString *tel = addressBook.tel ;
    
    [_utils sendSMSmessage:@"来玩千衍吧(((o(*ﾟ▽ﾟ*)o)))" ToTel:tel sender:self] ;
}

- (void)didClickedAddBtn:(ContactTableViewCell *)cell atIndex:(NSInteger)index {
    
}


@end
