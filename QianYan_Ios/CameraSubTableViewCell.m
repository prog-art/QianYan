//
//  CameraSubTableViewCell.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/7/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "CameraSubTableViewCell.h"

@interface CameraSubTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *tempStateLabel;


@end

@implementation CameraSubTableViewCell
@synthesize imageView;

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setLocationText:(NSString *)locationText {
    _locationLabel.text = locationText;
}

- (NSString *)locationText {
    return _locationLabel.text;
}

- (void)setState:(BOOL)state {
    self.tempStateLabel.text = state ? @"在线" : @"离线" ;
}

- (void)awakeFromNib {
    self.state = FALSE ;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
