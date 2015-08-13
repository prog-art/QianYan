//
//  ManageGroupTableViewCell.m
//  群组管理
//
//  Created by WardenAllen on 15/8/12.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "ManageGroupTableViewCell.h"

@interface ManageGroupTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation ManageGroupTableViewCell

- (void)setAvatarImage:(UIImage *)avatarImage {
    self.avatarImageView.image = avatarImage;
}

- (UIImage *)avatarImage {
    return self.avatarImageView.image;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (NSString *)name {
    return self.nameLabel.text;
}

- (void)setIsChosen:(BOOL)isChosen {
    if (isChosen) {
        self.selectImageView.image = [UIImage imageNamed:@"群组管理-成员选中.png"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"群组管理-成员未选中.png"];
    }
}

- (BOOL)isChosen {
    return self.isChosen;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
