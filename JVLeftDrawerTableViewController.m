//
//  JVLeftDrawerTableViewController.m
//  JVFloatingDrawer
//
//  Created by Julian Villella on 2015-01-15.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import "JVLeftDrawerTableViewController.h"
#import "JVLeftDrawerTableViewCell.h"
#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import "SettingsViewController.h"


#import "QY_Common.h"

static const CGFloat kJVTableViewTopInset = 110.0;
static NSString * const kJVDrawerCellReuseIdentifier = @"JVLeftDrawerCellReuseIdentifier";

@interface JVLeftDrawerTableViewController ()

@end

@implementation JVLeftDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
    
    //头像按钮
    UIButton *potraitBtn = [[UIButton alloc] initWithFrame:CGRectMake(36, -40, 60, 60)];
    [potraitBtn setImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    
    [potraitBtn addTarget:self action:@selector(potraitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //昵称按钮
    UIButton *nicknameBtn = [[UIButton alloc] initWithFrame:CGRectMake(98, -36, 80, 25)];
    nicknameBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [nicknameBtn setTitle:@"大静静" forState:UIControlStateNormal];
    [nicknameBtn addTarget:self action:@selector(nicknameBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //会员图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, -10, 85, 24)];
    imageView.image = [UIImage imageNamed:@"会员.png"];
    
    [self.view addSubview:potraitBtn];
    [[QYUser currentUser].coreUser displayCycleAvatarAtImageView:potraitBtn.imageView] ;
    [self.view addSubview:nicknameBtn];
    [self.view addSubview:imageView];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JVLeftDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJVDrawerCellReuseIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.titleText = @"我的好友";
            cell.iconImage = [UIImage imageNamed:@"我的好友.png"];
            break;
            
        case 1:
            cell.titleText = @"我的相册";
            cell.iconImage = [UIImage imageNamed:@"我的相册.png"];
            break;
            
        case 2:
            cell.titleText = @"录像计划";
            cell.iconImage = [UIImage imageNamed:@"录像计划.png"];
            break;
            
        case 3:
            cell.titleText = @"摄像机权限管理";
            cell.iconImage = [UIImage imageNamed:@"摄像机权限管理.png"];
            break;
            
        case 4:
            cell.titleText = @"设置";
            cell.iconImage = [UIImage imageNamed:@"设置.png"];
            break;
            
        case 5:
            cell.titleText = @"版本说明";
            cell.iconImage = [UIImage imageNamed:@"版本说明.png"];
            break;
            
        case 6:
            cell.titleText = @"意见反馈";
            cell.iconImage = [UIImage imageNamed:@"意见反馈.png"];
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell;
}

#pragma mark - Actions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __block UIViewController *destinationViewController = nil;
    
    if(indexPath.row == 4) {
        destinationViewController = [[AppDelegate globalDelegate] systemSettingsTableViewController];
        
        [self test:destinationViewController] ;
        
    } else if (indexPath.row == 1) {
        destinationViewController = [[AppDelegate globalDelegate] myPhotoGraphCollectionViewController];
        
        [self test:destinationViewController] ;
    } else if (indexPath.row == 3){
        destinationViewController = [[AppDelegate globalDelegate] CameraSettingCollectionViewController];
        
        [self test:destinationViewController] ;
    } else if (indexPath.row == 6) {
        destinationViewController = [[AppDelegate globalDelegate] FeedbackViewController];
        
        [self test:destinationViewController] ;
    }
    
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

- (void)nicknameBtnClicked:(UIButton *)sender{

}

- (void)potraitBtnClicked:(UIButton *)sender{
    __block UIViewController *destinationViewController = nil;
    destinationViewController = [[AppDelegate globalDelegate] QRCodeCardViewController];
    
    [self test:destinationViewController] ;
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];

}

- (void)test:(UIViewController *)destinationViewController {
    
    UITabBarController *tbc = (UITabBarController *)[[[AppDelegate globalDelegate] drawerViewController] centerViewController] ;
    
    UINavigationController *nvc = tbc.viewControllers[0] ;
    
    UIViewController *vc = nvc.topViewController ;
    
    [vc.navigationController pushViewController:destinationViewController animated:NO] ;
}


@end