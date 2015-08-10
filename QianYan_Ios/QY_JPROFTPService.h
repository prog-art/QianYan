//
//  QY_JPROFTPService.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/8/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QY_JPROFTPService : NSObject

+ (instancetype)shareInstance ;

- (void)testDownload:(NSString *)url ;

@end
