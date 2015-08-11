//
//  ImageSelectCollectionViewController.m
//  图片选择
//
//  Created by WardenAllen on 15/8/10.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "ImageSelectCollectionViewController.h"
#import "ImageSelectCollectionViewCell.h"

@interface ImageSelectCollectionViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnItem;

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (nonatomic) BOOL isSelected;

@end

@implementation ImageSelectCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSelected = NO;
   
#warning imageArray 初始化
    _imageArray = [NSMutableArray array];

    _selectedArray = [NSMutableArray array];
    
    //0表示未选中, 1表示选中
    for (int i=0; i<20; i++) {
        [self.selectedArray addObject:[NSNumber numberWithInt:0]];
    }
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
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning return [self.imageArray count];
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    int selectedNum = [[self.selectedArray objectAtIndex:indexPath.row] intValue];
    
    if (selectedNum == 0) {
        cell.isChosen = NO;
    } else {
        cell.isChosen = YES;
    }
    //测试用,需改为真实image
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", (indexPath.row%4)+1]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int selectedNum = [[self.selectedArray objectAtIndex:indexPath.row] intValue];
    ImageSelectCollectionViewCell *cell = (ImageSelectCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (selectedNum == 0) {
        cell.isChosen = YES;
        [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
    } else {
        cell.isChosen = NO;
        [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:0]];
    }
    
    for (int i=0; i<[self.selectedArray count]; i++) {
        int s = [[self.selectedArray objectAtIndex:i] intValue];
        if (s == 1) {
            if ([self.barBtnItem.title isEqualToString:@"取消"]) {
                [self.barBtnItem setTitle:@"确定"];
                break;
            } else {
                break;
            }
        }
        if (i == [self.selectedArray count]-1) {
            [self.barBtnItem setTitle:@"取消"];
        }
    }
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action
- (IBAction)doneBtnClicked:(id)sender {
#warning 点击取消或者确定事件
}

@end
