//
//  VideoShareTableViewCell.h
//  VideoShare
//
//  Created by WardenAllen on 15/8/16.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoShareTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isChosen;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSString *eventType;

@property (nonatomic, strong) NSString *durationTime;

@property (nonatomic, strong) UIImage *image;
@end
