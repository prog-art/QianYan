//
//  AlertNotificationTableViewCell.h
//  QianYan_Ios
//
//  Created by WardenAllen on 15/6/25.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertNotificationTableViewCell : UITableViewCell

@property (strong) UIImage *image;
@property (strong) NSString *totalTime;
@property (strong) NSString *time;
@property (strong) NSString *location;
@property (strong) NSString *eventType;
@property BOOL isRead;
@end
