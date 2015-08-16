//
//  VideoShareTableViewCell.m
//  VideoShare
//
//  Created by WardenAllen on 15/8/16.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "VideoShareTableViewCell.h"

@interface VideoShareTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UILabel *eventTypeLabel;

@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) IBOutlet UIImageView *isChosenImageView;

@end

@implementation VideoShareTableViewCell

@synthesize imageView;

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setTime:(NSString *)time {
    self.timeLabel.text = time;
}

- (NSString *)time {
    return self.timeLabel.text;
}

- (void)setLocation:(NSString *)location {
    self.locationLabel.text = location;
}

- (NSString *)location {
    return self.locationLabel.text;
}

- (void)setEventType:(NSString *)eventType {
    self.eventTypeLabel.text = eventType;
}

- (NSString *)eventType {
    return self.eventTypeLabel.text;
}

- (void)setIsChosen:(BOOL)isChosen {
    if (isChosen) {
        self.isChosenImageView.image = [UIImage imageNamed:@"群组管理-成员选中"];
    } else {
        self.isChosenImageView.image = [UIImage imageNamed:@"群组管理-成员未选中"];
    }
}

- (BOOL)isChosen {
    return self.isChosen;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
