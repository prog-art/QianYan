//
//  MyPhotoGraphCollectionViewController.m
//  QianYan_Ios
//
//  Created by WardenAllen on 15/6/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "MyPhotoGraphCollectionViewController.h"
#import "QY_Common.h"
#import "PhotoCollectionViewCell.h"

@interface MyPhotoGraphCollectionViewController ()

@property (nonatomic) NSMutableArray *dataSource ;

@end

@implementation MyPhotoGraphCollectionViewController

#pragma makr - getter 

- (NSMutableArray *)dataSource {
    return _dataSource ? : (_dataSource = [NSMutableArray array]) ;
}

#pragma mark -

- (void)initDataSource {
#warning 未做压力测试。80kb一张图。
    NSDirectoryEnumerator *enumerator = [QY_FileService test] ;
    NSString *fileName ;
    while ( fileName = [enumerator nextObject]) {
        [self.dataSource addObject:fileName] ;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    self.navigationItem.leftBarButtonItem.title = @"返回" ;
    self.navigationItem.title = @"相册" ;
    
    [self initDataSource] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:YES] ;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"PhotoCollectionViewCellReuserId" ;
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath] ;
    
    QYDebugLog(@"indexPath = %@",indexPath) ;
    NSInteger index = indexPath.section * 3 + indexPath.row ;
    NSString *fileName = self.dataSource[index] ;
    [QY_FileService displayScreenShotImageFileName:fileName forUserId:@"10000133" atImageView:cell.photoImageView] ;
    
    return cell ;
}

#pragma mark - back

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}


@end
