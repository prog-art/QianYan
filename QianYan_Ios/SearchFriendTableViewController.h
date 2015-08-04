//
//  SearchFriendTableViewController.h
//  好友搜索
//
//  Created by WardenAllen on 15/8/3.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QY_user ;

@interface SearchFriendTableViewController : UITableViewController

+ (SearchFriendTableViewController *)viewControllerWithUser:(QY_user *)user ;

@end
