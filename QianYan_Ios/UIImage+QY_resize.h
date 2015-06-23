//
//  UIImage+resize.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/23.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QY_resize)

/**
 *  改变图像的尺寸，方便上传服务器
 *
 *  @param image
 *  @param size
 *
 *  @return
 */
+ (UIImage *)QY_scaleFromImage:(UIImage *)image toSize:(CGSize)size ;

/**
 *  保持原来的长宽比，生成一个缩略图
 *
 *  @param image
 *  @param asize
 *
 *  @return
 */
+ (UIImage *)QY_thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize ;

@end