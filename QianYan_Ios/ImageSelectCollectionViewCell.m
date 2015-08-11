//
//  ImageSelectCollectionViewCell.m
//  图片选择
//
//  Created by WardenAllen on 15/8/11.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "ImageSelectCollectionViewCell.h"

@interface ImageSelectCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation ImageSelectCollectionViewCell

- (void)setIsChosen:(BOOL)isChosen {
    if (isChosen) {
        self.selectImageView.image = [UIImage imageNamed:@"图片选择-选中.png"];
    } else {
        self.selectImageView.image = nil;
    }
}

- (BOOL)isChosen {
    return self.isChosen;
}

- (void)setImage:(UIImage *)image {
    self.photoImageView.image = image;
}

- (UIImage *)image {
    return self.photoImageView.image;
}

@end
