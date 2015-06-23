//
//  QY_JRMAPIPhraseRule.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_JRMAPIPhraseRule.h"

@implementation QY_JRMAPIPhraseRule

+ (instancetype)ruleWithTargetCMD:(JOSEPH_COMMAND)cmd
                     descriptions:(NSArray *)descriptions
                       attachment:(BOOL)attachment {
    return [[self alloc] initWithTargetCMD:cmd
                              descriptions:descriptions
                                attachment:attachment] ;
}

- (instancetype)initWithTargetCMD:(JOSEPH_COMMAND)cmd
                     descriptions:(NSArray *)descriptions
                       attachment:(BOOL)attachment {
    if ( self = [self init] ) {
        _targetCMD = cmd ;
        _descriptions = descriptions ;
        _attachment = attachment ;
    }
    return self ;
}

@end
