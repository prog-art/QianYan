//
//  ImageSelectCollectionViewCell.h
//  图片选择
//
//  Created by WardenAllen on 15/8/11.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSelectCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView ;

@property (nonatomic) BOOL isChosen;

@property (nonatomic, strong) UIImage *image;

@end
