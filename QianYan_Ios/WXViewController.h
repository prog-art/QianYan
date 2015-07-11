//
//  WXViewController.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingViewManager.h"


@interface WXViewController : UIViewController

- (IBAction)demoButtonClicked:(id)sender;
@property (strong) UIView *maskView;
@property BOOL isShow; // 弹出状态
@property (strong) UIView *notificationView;

@property (strong) SlidingViewManager *svm;
@property (strong) UIButton *wordShareButton;
@property (strong) UIButton *pictureShareButton;
@property (strong) UIButton *videoShareButton;

@property (strong) UILabel *wordShareLabel;
@property (strong) UILabel *pictureShareLabel;
@property (strong) UILabel *videoShareLabel;

@property (strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButtonItem;

@end
