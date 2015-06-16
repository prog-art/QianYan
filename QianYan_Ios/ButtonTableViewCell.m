//
//  ButtonTableViewCell.m
//  TB
//
//  Created by WardenAllen on 15/5/23.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "ButtonTableViewCell.h"

@interface ButtonTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ButtonTableViewCell

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (UIImage *)buttonImage {
    return self.button.imageView.image;
}

- (void)setButtonImage:(UIImage *)buttonImage {
    [self.button setImage:buttonImage forState:UIControlStateNormal];
    [self.button setImage:buttonImage forState:UIControlStateHighlighted];
}
- (IBAction)buttonClicked:(id)sender {
    NSLog(@"Button Clicked!");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
