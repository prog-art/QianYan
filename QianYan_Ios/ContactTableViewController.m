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
#import "QY_SocketAgent.h"
#import "QY_Common.h"

static NSString * const ContactTableViewCellReuseIdentifier = @"ContactTableViewCellReuseIdentifier";

static NSMutableArray *cacheContacts = nil ;

@interface ContactTableViewController () <UISearchBarDelegate,QY_contactUtilsDelegate,ContactTableViewCellDelegate> {
    QY_contactUtils *_utils ;
    
    NSMutableArray *_dataSourceOfContact ;//NSArray <QY_AddressBook> 联系人数组
    NSMutableArray *_displayDataSourceOfContact ;//上述的显示部分。

}

@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchBar;

@property (nonatomic,weak) QY_SocketAgent *socketAgent ;

@end

@implementation ContactTableViewController

#pragma mark - getter & setter 

- (QY_SocketAgent *)socketAgent {
    if ( !_socketAgent ) {
        _socketAgent = [QY_SocketAgent shareInstance] ;
    }
    return _socketAgent ;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    _dataSourceOfContact = cacheContacts ;
    _displayDataSourceOfContact = _dataSourceOfContact ;
    
    if ( !_dataSourceOfContact ) {
        QYDebugLog(@"没有缓存") ;
        _utils = [[QY_contactUtils alloc] initWithDelegate:self] ;
        [_utils getContacts] ;
    } else {
        QYDebugLog(@"有缓存") ;
    }

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
    QYDebugLog(@"fuck") ;
    if ( success ) {
        _dataSourceOfContact = [contacts mutableCopy] ;
        _displayDataSourceOfContact = _dataSourceOfContact ;
        QYDebugLog(@"reload data") ;
        
        [QYUtils runInMainQueue:^{
            cacheContacts = _dataSourceOfContact ;
            [self.tableView reloadData] ;
        }] ;


        [self lookUpContactsHasQYAccount:contacts] ;
    }
}

#pragma mark - private method 

- (void)lookUpContactsHasQYAccount:(NSArray *)contacts {
    __block dispatch_semaphore_t _sema = dispatch_semaphore_create(0) ;

    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _sema = dispatch_semaphore_create(0) ;

        NSArray *tempContacts = [contacts copy] ;

        for ( QY_Contact *contact in tempContacts ) {
            QYDebugLog(@"contact = %@",contact) ;

            [self.socketAgent getUserIdByTelephone:contact.tel Complection:^(NSDictionary *info, NSError *error) {
                if ( !error && info ) {
                    QYDebugLog(@"info = %@",info) ;
                    contact.qy_userId = info[ParameterKey_userId] ;
                }
                dispatch_semaphore_signal(_sema) ;
            }] ;

            dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER) ;
        }

        //sort
        {
            NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"qy_userId" ascending:NO] ;
            tempContacts = [tempContacts sortedArrayUsingDescriptors:@[sortDesc]] ;
        }


        QYDebugLog(@"完成了所有～") ;
        _sema = NULL ;

        _dataSourceOfContact = [tempContacts mutableCopy] ;

        [QYUtils runInMainQueue:^{
            _displayDataSourceOfContact = _dataSourceOfContact ;
            cacheContacts = _dataSourceOfContact ;
            [weakSelf.tableView reloadData] ;
        }] ;
    }) ;
}


#pragma mark - ContactTableViewCellDelegate

- (void)didClickedInviteBtn:(ContactTableViewCell *)cell atIndex:(NSInteger)index {
    QY_Contact *addressBook = _displayDataSourceOfContact[index] ;
    NSString *tel = addressBook.tel ;
    
    [_utils sendSMSmessage:@"来玩千衍吧(((o(*ﾟ▽ﾟ*)o)))" ToTel:tel sender:self] ;
}

- (void)didClickedAddBtn:(ContactTableViewCell *)cell atIndex:(NSInteger)index {
//#warning 添加好友
}


@end
