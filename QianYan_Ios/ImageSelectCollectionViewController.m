//
//  ImageSelectCollectionViewController.m
//  图片选择
//
//  Created by WardenAllen on 15/8/10.
//  Copyright (c) 2015年 王东. All rights reserved.
//

#import "ImageSelectCollectionViewController.h"
#import "ImageSelectCollectionViewCell.h"
#import "QY_Common.h"

typedef NS_ENUM(NSInteger, DoneBtnType) {
    DoneBtnTypeCancel = 10 ,//取消
    DoneBtnTypeEnsure = 11 ,//确定
} ;

@interface ImageSelectCollectionViewController () <UIAlertViewDelegate>{
    NSInteger selectedNum ;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnItem ;

@property (strong, nonatomic) NSMutableArray *imageArray ;

@property (strong, nonatomic) NSMutableArray *selectedArray ;

@property (nonatomic) NSMutableArray *dataSource ;

@end

@implementation ImageSelectCollectionViewController

static NSString * const reuseIdentifier = @"Cell" ;

#pragma makr - getter

- (NSMutableArray *)dataSource {
    return _dataSource ? : (_dataSource = [NSMutableArray array]) ;
}

#pragma mark - life cycle

- (void)initDataSource {
    selectedNum = 0 ;
    _selectedArray = [NSMutableArray array] ;
    
#warning 未做压力测试。80kb一张图。
    NSDirectoryEnumerator *enumerator = [QY_FileService test] ;
    NSString *fileName ;
    while ( fileName = [enumerator nextObject]) {
        [self.dataSource addObject:fileName] ;
        [self.selectedArray addObject:@(FALSE)] ;
    }
    
    _imageArray = [NSMutableArray array] ;
}

- (void)setDoneBtnType:(DoneBtnType)type {
    if ( self.barBtnItem.tag == type) return ;
    self.barBtnItem.tag = type ;
    NSString *title = type == DoneBtnTypeCancel ? @"取消" : @"确定" ;
    self.barBtnItem.title = title ;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
   
    [self initDataSource] ;
    
    [self setDoneBtnType:DoneBtnTypeCancel] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:YES] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath] ;
    
    BOOL isSelected = [self.selectedArray[indexPath.row] boolValue] ;
    cell.isChosen = isSelected ;
    
    //
    NSInteger index = indexPath.section * 3 + indexPath.row ;
    NSString *fileName = self.dataSource[index] ;
    [QY_FileService displayScreenShotImageFileName:fileName forUserId:@"10000133" atImageView:cell.photoImageView] ;
    
    //测试用,需改为真实image
//
//    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", (indexPath.row%4)+1]] ;
    return cell ;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageSelectCollectionViewCell *cell = (ImageSelectCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath] ;
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES] ;
    
    BOOL isSelected = [self.selectedArray[indexPath.row] boolValue] ;
    isSelected = isSelected ^ TRUE ;
    if ( isSelected ) {
        if ( selectedNum < 9 ) {
            selectedNum++ ;
            [self.imageArray addObject:cell.image] ;
        } else {
            [QYUtils alert:@"最多只能选9张哦～"] ;
            return ;
        }
        
    } else {
        selectedNum-- ;
        [self.imageArray removeObject:cell.image] ;
    }

    cell.isChosen = isSelected ;
    [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:@(isSelected)] ;
    
    if (selectedNum > 0) {
        [self setDoneBtnType:DoneBtnTypeEnsure] ;
    } else {
        [self setDoneBtnType:DoneBtnTypeCancel] ;
    }
}

#pragma mark - Action

- (IBAction)doneBtnClicked:(UIBarButtonItem *)sender {
    DoneBtnType type = sender.tag ;
    switch (type) {
        case DoneBtnTypeCancel : {
            [self.navigationController popViewControllerAnimated:YES] ;
            break ;
        }
        case DoneBtnTypeEnsure : {
            [self showInputAlertView] ;
            break ;
        }
        default:
            break ;
    }
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ( buttonIndex != alertView.cancelButtonIndex ) {
        NSString *content = [alertView textFieldAtIndex:0].text ;
        [self uploadImagesAndFeed:content] ;
        //确认
    }
}

#pragma mark - helper 

- (void)showInputAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"顺便说两句吧～" message:nil delegate:self cancelButtonTitle:@"不说了" otherButtonTitles:@"确认发表", nil] ;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput ;
    [alertView show] ;
}

- (void)uploadImagesAndFeed:(NSString *)content {
    [SVProgressHUD show] ;
    [QYUtils showNetworkIndicator] ;
    NSArray *images = self.imageArray ;
    if ( images.count == 0 ) return ;
    
    NSInteger attachCount = images.count ;
    __block NSMutableArray *attachIds = [NSMutableArray array] ;
    
    dispatch_group_t group = dispatch_group_create() ;
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f) ;
        
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
            
            [[QY_JPROHttpService shareInstance] uploadImageAttach:imageData Complection:^(id object, NSError *error) {
                
                QYDebugLog(@"id = %@ ,class = %@",object,[object class]) ;
                NSString *attachId ;
                if ( [object isKindOfClass:[NSNumber class]]) {
                    //数字
                    attachId = [object stringValue] ;
                } else
                    if ([object isKindOfClass:[NSString class]]) {
                        //字符串
                        attachId = object ;
                    }
                
                @synchronized(attachIds) {
                    [attachIds addObject:attachId] ;
                }
                
                dispatch_semaphore_signal(sema) ;
            }] ;
    
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)) ;
            dispatch_semaphore_wait(sema, timeout) ;
            
            QYDebugLog(@"%lu上传完成",(unsigned long)idx) ;
        }) ;
        
    }] ;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        QYDebugLog(@"全部上传完成") ;
        if ( attachCount != attachIds.count ) {
            NSString *message = [NSString stringWithFormat:@"部分图片上传失败。。%lu//%ld",attachIds.count,(long)attachCount] ;
            [QYUtils alert:message] ;
        }
        QYDebugLog(@"开始发表") ;
        
        NSSet *attaches = [NSSet setWithArray:attachIds] ;
        
#warning 重构到调用者里！
        [[QY_JPROHttpService shareInstance] createAttachFeedWithContent:content Attaches:attaches Messages:nil Complection:^(NSString *feedId, NSError *error) {
            if ( feedId && !error ) {
                QYDebugLog(@"发表成功！") ;
                [[QY_Notify shareInstance] postFeedNotifyWithId:feedId] ;
                
                [self.navigationController popToRootViewControllerAnimated:YES] ;
            } else {
                QYDebugLog(@"发表失败 error = %@",error) ;
                [QYUtils alertError:error] ;
            }
            
            [QYUtils hideNetworkIndicator] ;
            [SVProgressHUD dismiss] ;
        }] ;
        
    }) ;
}

@end
