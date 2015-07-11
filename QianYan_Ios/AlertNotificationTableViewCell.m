//
//  AlertNotificationTableViewCell.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/6/25.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AlertNotificationTableViewCell.h"

@interface AlertNotificationTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;

@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UILabel *eventTypeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *unReadImageView;

@end

@implementation AlertNotificationTableViewCell

#pragma mark -- Getters and Setters

- (void)setImage:(UIImage *)image {
    _videoImageView.image = image;
}

- (UIImage *)image {
    return _videoImageView.image;
}

- (void)setTotalTime:(NSString *)totalTime {
    _totalTimeLabel.text = totalTime;
}

- (NSString *)totalTime {
    return _totalTimeLabel.text;
}

- (void)setTime:(NSString *)time {
    _timeLabel.text = time;
}

- (NSString *)time {
    return _timeLabel.text;
}

- (void)setLocation:(NSString *)location {
    _locationLabel.text = location;
}

- (NSString *)location {
    return _locationLabel.text;
}

- (void)setEventType:(NSString *)eventType {
    _eventTypeLabel.text = eventType;
}

- (NSString *)eventType {
    return _eventTypeLabel.text;
}

- (void)setIsRead:(BOOL)isRead {
    [_unReadImageView setHidden:isRead];
}

- (BOOL)isRead {
    return _unReadImageView.hidden;
}

- (void)awakeFromNib {
    [_videoImageView addSubview:_totalTimeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
