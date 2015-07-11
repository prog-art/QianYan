//
//  SlidingViewManager.m
//  notificationview
//
//  Created by Andrew Drozdov on 11/13/14.
//  Copyright (c) 2014 Andrew Drozdov. All rights reserved.
//

#import "SlidingViewManager.h"

@implementation SlidingViewManager {
    BOOL visible;
    UIView *innerView;
    UIView *containerView;
    UIView *maskView;
}

- (id)initWithInnerView:(UIView*)_innerView containerView:(UIView *)_containerView maskView:(UIView *)_maskView{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    innerView = _innerView;
    containerView = _containerView;
    maskView = _maskView;
    
    return self;
}

- (void)slideViewIn {
    visible = YES;
    
    CGFloat innerWidth = CGRectGetWidth(innerView.frame);
    CGFloat innerHeight = CGRectGetHeight(innerView.frame);
    CGFloat innerX = CGRectGetMinX(innerView.frame);
    
    CGRect original = CGRectMake(innerX, -112, innerWidth, innerHeight);
    CGRect target = CGRectMake(0, 0, innerWidth, innerHeight);
    
    // Add to View
    [innerView setFrame:original];
    [containerView addSubview:maskView];
    [maskView addSubview:innerView];
    
    // Animate In
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [innerView setFrame:target];
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
    
}

- (void)slideViewOut {
    visible = NO;
    
    CGFloat innerWidth = CGRectGetWidth(innerView.frame);
    CGFloat innerHeight = CGRectGetHeight(innerView.frame);
    CGFloat innerX = CGRectGetMinX(innerView.frame);
    
    CGRect original = CGRectMake(innerX, -112, innerWidth, innerHeight);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [innerView setFrame:original];
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
    }];
}

@end
