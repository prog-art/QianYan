//
//  QY_contactUtils.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_contactUtils.h"

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

#import "QY_AddressBook.h"
#import "QY_Common.h"

typedef void(^QYBlock)() ;

@interface QY_contactUtils () <MFMessageComposeViewControllerDelegate>{
    NSMutableArray *_addressBookTemp ;
    
    ABAddressBookRef addressBooks ;
    
    __weak UIViewController *_sender ;
}

@end

@implementation QY_contactUtils

#pragma mark - Life Cycle 

- (instancetype)initWithDelegate:(id<QY_contactUtilsDelegate>)delegate {
    if ( self = [super init]) {
        self.delegate = delegate ;
    }
    return self ;
}

#pragma mark - public

- (void)getContacts {
    [self getAuthority] ;
}

#pragma mark - test

- (void)sendSMSmessage:(NSString *)content ToTels:(NSArray *)recipients sender:(UIViewController *)sender {
    _sender = sender ;
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    
    if ( [MFMessageComposeViewController canSendText] ) {
        controller.body = content ;
        controller.recipients = recipients ;
        controller.messageComposeDelegate = self ;
        [sender presentViewController:controller animated:YES completion:nil] ;
    }
    
}

- (void)sendSMSmessage:(NSString *)content ToTel:(NSString *)telephone sender:(UIViewController *)sender {
    [self sendSMSmessage:content ToTels:@[telephone] sender:sender] ;
}

#pragma mark - private method

/**
 *  获取权限
 */
- (void)getAuthority {
    
    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 6.0 ) {
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL) ;
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            QYDebugLog(@"success = %d  error = %@",granted,error) ;
            
            if ( granted ) {
                [self getPeoInBookAddress:^{
                    [self output:TRUE Contacts:_addressBookTemp] ;
                }] ;
            } else {
                [self output:FALSE Contacts:nil] ;
            }
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER) ;
            
            QYDebugLog(@"...") ;
        }) ;
    }
}

- (void)getPeoInBookAddress:(QYBlock)complection {
    _addressBookTemp = [self getPeoInBookAddress] ;
    [self filterPeoInBookAddress:_addressBookTemp] ;
    [self SortByUserId:_addressBookTemp] ;
    if ( complection ) {
        complection() ;
    }
}

#pragma mark - 数据处理

/**
 *  排序，通过UserId，有的排前面，没有的排后面。
 *
 *  @param contacts _addressBookTemp ;
 */
- (void)SortByUserId:(NSArray *)contacts {
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"qy_userId" ascending:NO] ;
    NSArray *sortDescriptors = @[sortDescriptor] ;
    NSArray *tempArray = [contacts sortedArrayUsingDescriptors:sortDescriptors] ;
    
    _addressBookTemp = [tempArray mutableCopy] ;
}

/**
 *  过滤掉电话号码为空的和名字为Apple（中国大陆的）
 *
 *  @param contacts _addressBookTemp ;
 */
- (void)filterPeoInBookAddress:(NSArray *)contacts {
    NSMutableArray *filterdContacts = [NSMutableArray array] ;
    
    for ( QY_AddressBook* contact in contacts ) {
        if ( nil == contact.tel ) {
            continue ;
        }
//        if ([@"Apple (中国大陆)" isEqualToString:contact.name] ) {
//            continue ;
//        }
        
        [filterdContacts addObject:contact] ;
    }
    
    _addressBookTemp = filterdContacts ;
}


/**
 *  去掉电话号码中多余的字符
 *  例: @"+86 400-600-8800" --> @"400-600-8800"
 *
 *  @param telNum 电话号码
 */
- (NSString *)filterOtherCharacterOfTelephoneString:(NSString *)telNum {
    if ( !telNum ) {
        return nil ;
    }
    NSRange range ;
    
    range = [telNum rangeOfString:@" "] ;
    
    if ( range.location != NSNotFound ) {
        telNum = [telNum substringFromIndex:range.location + 1] ;
    }
    
    while ( (range = [telNum rangeOfString:@"-"] ).location != NSNotFound ) {
        NSMutableString *mString = [telNum mutableCopy] ;
        [mString replaceCharactersInRange:range withString:@""] ;
        telNum = mString ;
    }
    return telNum ;
}

#pragma mark - 获组联系人数据

- (NSMutableArray *)getPeoInBookAddress {
    NSMutableArray *addressBookTemp = [NSMutableArray array] ;
    
    //所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks) ;
    //通讯录人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks) ;
    
    //循环，获取每个人的个人信息
    for ( NSInteger i = 0 ; i < nPeople ; i++ ) {
        //新建一个addressbook model类
        
        QY_AddressBook *addressBook = [[QY_AddressBook alloc] init] ;
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i) ;
        
        //name
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty) ;
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty) ;
        CFStringRef abFullName = ABRecordCopyCompositeName(person) ;
        
        NSString *nameString = (__bridge NSString *)abName ;
        NSString *lastNameString = (__bridge NSString *)abFullName ;
        
        if ( (__bridge id)abFullName != nil ) {
            nameString = (__bridge NSString *)abFullName ;
        } else {
            if ( (__bridge id)abLastName != nil ) {
                nameString = [NSString stringWithFormat:@"%@ %@",nameString,lastNameString] ;
            }
        }
        addressBook.name = nameString ;
        //record Id
        addressBook.recordId = (int)ABRecordGetRecordID(person) ;
        
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty ,
            kABPersonEmailProperty
        } ;
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID) ;
        
        for ( NSInteger j = 0 ; j < multiPropertiesTotal ; j++ ) {
            ABPropertyID property = multiProperties[j] ;
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property) ;
            
            NSInteger valuesCount = 0 ;
            
            if ( valuesRef != nil ) {
                valuesCount = ABMultiValueGetCount(valuesRef) ;
            }
            
            if ( 0 == valuesCount) {
                CFRelease(valuesRef) ;
                continue ;
            }
            //获取电话号码和email
            for ( NSInteger k = 0 ; k < valuesCount ; k++ ) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef) ;
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        addressBook.tel = [self filterOtherCharacterOfTelephoneString:addressBook.tel] ;
        [addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        
    }
    
    return addressBookTemp ;
}

#pragma mark - MFMessageComposeViewControllerDelegate 消息发送

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    QYDebugLog(@"...") ;
    [_sender dismissViewControllerAnimated:YES completion:nil] ;
    
    switch ( result ) {
        case MessageComposeResultCancelled:
            QYDebugLog(@"Message cancelled") ;
            break;
        case MessageComposeResultFailed :
            QYDebugLog(@"Message failed") ;
            break ;
        case MessageComposeResultSent :
            QYDebugLog(@"Message send") ;
            break ;
        default:
            break;
    }
    
}

#pragma mark - 输出

- (void)output:(BOOL)success Contacts:(NSArray *)contacts {
    if ( [self.delegate respondsToSelector:@selector(didReceiveContactsSuccess:Contacts:)]) {
        [self.delegate didReceiveContactsSuccess:success Contacts:contacts] ;
    }
}

@end