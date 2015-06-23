//
//  UIImage+resize.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/6/23.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "UIImage+QY_resize.h"

@implementation UIImage (QY_resize)

/**
 *  改变图像的尺寸，方便上传服务器
 *
 *  @param image
 *  @param size
 *
 *  @return
 */
+ (UIImage *)QY_scaleFromImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size) ;
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)] ;
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 *  保持原来的长宽比，生成一个缩略图
 *
 *  @param image
 *  @param asize
 *
 *  @return
 */
+ (UIImage *)QY_thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage ;
    
    if ( nil == image ) {
        newimage = nil ;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end