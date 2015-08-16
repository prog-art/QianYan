//
//  ManageGroupTableViewCell.h
//  群组管理
//
//  Created by WardenAllen on 15/8/12.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageGroupTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, assign) BOOL isChosen;

@property (nonatomic, strong) NSString *name;

@end
