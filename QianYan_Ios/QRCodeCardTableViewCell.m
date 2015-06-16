//
//  QRCodeCardTableViewCell.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QRCodeCardTableViewCell.h"

@interface QRCodeCardTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *accountIDLabel;

@end

@implementation QRCodeCardTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSString *)accountID {
    return self.accountIDLabel.text;
}

- (void)setAccountID:(NSString *)accountID {
    self.accountIDLabel.text = accountID;
}

@end
