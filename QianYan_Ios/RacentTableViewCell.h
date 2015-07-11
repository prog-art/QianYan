//
//  RacentTableViewCell.h
//  最近查看
//
//  Created by WardenAllen on 15/6/22.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RacentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (strong, nonatomic) IBOutlet UILabel *cameraNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cameraStateImageView;

@end
