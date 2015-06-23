//
//  QY_JRMAPIPhraseRule.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/27.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_jclient_jrm_protocol_Marco.h"
#import "JRMvalueDescription.h"
#import "JRMvalue.h"

/**
 *  解析规则类
 */
@interface QY_JRMAPIPhraseRule : NSObject

/**
 *  获取一个rule实例
 *
 *  @param cmd          targetCMD
 *  @param descriptions JRMvalueDescription描述数组
 *  @param attachment   是否包含附件
 *
 *  @return
 */
+ (instancetype)ruleWithTargetCMD:(JOSEPH_COMMAND)cmd
                     descriptions:(NSArray *)descriptions
                       attachment:(BOOL)attachment ;

- (instancetype)initWithTargetCMD:(JOSEPH_COMMAND)cmd
                     descriptions:(NSArray *)descriptions
                       attachment:(BOOL)attachment ;


#pragma mark - property

/**
 *  目标CMD，针对这个CMD的解析
 */
@property (readonly,nonatomic) JOSEPH_COMMAND targetCMD ;

/**
 *  JRMvalueDescription数组
 */
@property (readonly,nonatomic) NSArray *descriptions ;

/**
 *  是否有附件
 */
@property (readonly,assign) BOOL attachment ;


@end
