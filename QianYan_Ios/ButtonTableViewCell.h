//
//  ButtonTableViewCell.h
//  TB
//
//  Created by WardenAllen on 15/5/23.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableViewCell.h"

@interface ButtonTableViewCell : SKSTableViewCell
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *buttonImage;
@end
