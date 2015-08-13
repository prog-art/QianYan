//
//  ViewController.m
//  删除群组成员
//
//  Created by WardenAllen on 15/8/13.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "GroupInfoCollectionViewCell.h"
#import "GroupInfoTableViewCell.h"

@interface GroupInfoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, cellDelegate>

@property (nonatomic, strong) UICollectionView *memberCollectionView ;

@property (nonatomic, strong) NSMutableArray *memberArray ;

@property (nonatomic, strong) UITableView *tableView ;

@end

@implementation GroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init] ;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical] ;
    self.memberCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, 300, 400) collectionViewLayout:flowLayout] ;
    self.memberCollectionView.dataSource = self ;
    self.memberCollectionView.delegate = self ;
    [self.memberCollectionView setScrollEnabled:NO] ;
    
    [self.memberCollectionView registerClass:[GroupInfoCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"] ;
    self.memberCollectionView.backgroundColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0] ;
    
    CALayer *layer = [self.memberCollectionView layer] ;
    [layer setMasksToBounds:YES] ;
    [layer setCornerRadius:8] ;
    [layer setBorderWidth:0.5] ;
    [layer setBorderColor:[[UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0] CGColor]] ;
    
    [self.view addSubview:self.memberCollectionView] ;
    
    self.memberArray = [NSMutableArray array] ;
    for (int i=0 ; i<9 ; i++) {
        [self.memberArray addObject:[NSNumber numberWithInt:i]] ;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 420, 320, 90)] ;
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    [self.tableView registerClass:[GroupInfoTableViewCell class] forCellReuseIdentifier:@"TableViewCell"] ;
    [self.view addSubview:self.tableView] ;
    [self.tableView setScrollEnabled:NO] ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath] ;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    [cell setUp] ;
    if (indexPath.row == 0) {
        cell.title = @"群组名称" ;
        cell.content = @"同学" ;
    } else {
        cell.title = @"相机分配" ;
        cell.content = @"明星" ;
    }
    
    return cell ;
}

#pragma mark - UITableView Delegate

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.memberArray count] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    [cell setUp] ;
    cell.name = [NSString stringWithFormat:@"Cell %d", [[self.memberArray objectAtIndex:indexPath.row] intValue]] ;
    cell.avatarImage = [UIImage imageNamed:@"群组信息-删除成员头像.png"] ;
    cell.canDelete = YES ;
    cell.delegate = self ;
    cell.backgroundColor = [UIColor yellowColor] ;
    return cell ;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.memberCollectionView deselectItemAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - UICollectionView FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 100) ;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4 ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0 ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0) ;
}

#pragma mark - Cell Delegate

- (void)didCell:(GroupInfoCollectionViewCell *)cell CickedDeleteBtn:(UIButton *)sender {
    NSIndexPath *indexPath = [self.memberCollectionView indexPathForCell:cell] ;
    NSInteger index = indexPath.row ;
    
    [self.memberArray removeObjectAtIndex:index] ;
    [self.memberCollectionView deleteItemsAtIndexPaths:@[indexPath]] ;
    
}

@end
