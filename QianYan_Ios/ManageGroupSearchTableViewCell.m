//
//  ManageGroupSearchTableViewCell.m
//  群组管理
//
//  Created by WardenAllen on 15/8/12.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "ManageGroupSearchTableViewCell.h"

@interface ManageGroupSearchTableViewCell ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ManageGroupSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
