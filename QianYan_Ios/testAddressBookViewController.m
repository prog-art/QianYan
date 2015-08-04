//
//  testAddressBookViewController.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/21.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "testAddressBookViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "QY_contactService.h"

@interface testAddressBookViewController ()<QY_contactUtilsDelegate> {
    NSMutableArray *addressBookTemp ;
    
    ABAddressBookRef addressBooks ;
    
    QY_contactUtils *utils ;
}

@end

@implementation testAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    
    addressBookTemp = [NSMutableArray array] ;
    addressBooks = nil ;
    
    
    utils = [[QY_contactUtils alloc] initWithDelegate:self] ;
//    [utils sendSMSmessage:@"2333" ToTel:@"18817870387" sender:self] ;
    [utils getContacts] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - 

- (void)didReceiveContactsSuccess:(BOOL)success Contacts:(NSArray *)contacts {
}

@end
