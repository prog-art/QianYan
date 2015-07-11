//
//  CameraSettingCollectionViewController.m
//  摄像机权限管理
//
//  Created by WardenAllen on 15/6/17.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "CameraSettingCollectionViewController.h"
#import "CameraSettingCollectionViewCell.h"
#import "CameraSettingCollectionReusableView.h"

@interface CameraSettingCollectionViewController ()

@end

@implementation CameraSettingCollectionViewController

static NSString * const reuseIdentifier = @"CameraCell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 4;
        
    } else {
        
        return 2;
        
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CameraSettingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.image = [UIImage imageNamed:@"权限管理-1.png"];
                    cell.location = @"卧室";
                    cell.type = @"公开";
                    break;
                    
                case 1:
                    cell.image = [UIImage imageNamed:@"权限管理-2.png"];
                    cell.location = @"客厅";
                    cell.type = @"公开";
                    break;
                    
                case 2:
                    cell.image = [UIImage imageNamed:@"权限管理-3.png"];
                    cell.location = @"公司";
                    cell.type = @"秘密";
                    break;
                    
                case 3:
                    cell.image = [UIImage imageNamed:@"权限管理-4.png"];
                    cell.location = @"工作室";
                    cell.type = @"秘密";
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.image = [UIImage imageNamed:@"权限管理-5.png"];
                    cell.location = @"McDonald";
                    cell.type = @"分享";
                    break;
                    
                case 1:
                    cell.image = [UIImage imageNamed:@"权限管理-6.png"];
                    cell.location = @"花园";
                    cell.type = @"分享";
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        CameraSettingCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        
        switch (indexPath.section) {
            case 0:
                headerView.title = @"我拥有的相机:";
                break;
                
            case 1:
                headerView.title = @"别人分享给我的相机:";
                break;
                
            default:
                break;
        }
        
        reusableView = headerView;
        
    }
    
    return reusableView;
}


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CameraSettingCollectionViewCell *cell = (CameraSettingCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if ([cell.type isEqualToString:@"公开"]) {
            cell.type = @"秘密";
        }else {
            cell.type = @"公开";
        }
    }
}

#pragma mark -- Back Button

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

@end
