//
//  QY_AddressBook.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/5/22.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_AddressBook.h"

@implementation QY_AddressBook

- (NSString *)description {
    NSString *description ;
    
    description = [NSString stringWithFormat:
                   @"{\n"
                   "sectionNumber = %tx \n"
                   "recordId = %tx \n"
                   "name = %@ \n"
                   "email = %@ \n"
                   "telephone = %@ \n"
                   "userId = %@ \n"
                   "}",
                   self.sectionNumber,
                   self.recordId,
                   self.name,
                   self.email,
                   self.tel,
                   self.qy_userId] ;
    
    return description ;
}

@end
