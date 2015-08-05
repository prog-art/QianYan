//
//  WifiListTableViewCell.m
//  Wi-Fi列表
//
//  Created by WardenAllen on 15/8/3.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "WifiListTableViewCell.h"

@interface WifiListTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *wifiTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *wifiImageView;

@end

@implementation WifiListTableViewCell

- (void)setWifiTitle:(NSString *)wifiTitle {
    _wifiTitleLabel.text = wifiTitle;
}

- (NSString *)wifiTitle {
    return _wifiTitleLabel.text;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitleLabel.text = subTitle;
}

- (NSString *)subTitle {
    return _subTitleLabel.text;
}

- (void)setWifiImage:(UIImage *)wifiImage {
    _wifiImageView.image = wifiImage;
}

- (UIImage *)wifiImage {
    return _wifiImageView.image;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
