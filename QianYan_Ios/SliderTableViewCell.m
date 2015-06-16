//
//  SliderTableViewCell.m
//  TB
//
//  Created by WardenAllen on 15/5/23.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "SliderTableViewCell.h"

@interface SliderTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

@implementation SliderTableViewCell

- (NSString *)title {
    return  _titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (UIImage *)minImage {
    return _slider.minimumValueImage;
}

- (void)setMinImage:(UIImage *)minImage {
    _slider.minimumValueImage = minImage;
}

- (UIImage *)maxImage {
    return _slider.maximumValueImage;
}

- (void)setMaxImage:(UIImage *)maxImage {
    _slider.maximumValueImage = maxImage;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
