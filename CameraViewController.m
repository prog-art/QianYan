//
//  JVCenterViewController.m
//  JVFloatingDrawer
//
//  Created by Julian Villella on 2015-01-11.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import "AppDelegate.h"
#import "CameraViewController.h"
#import "SKSTableViewCell.h"
#import "RacentTableViewController.h"
#import "CameraSubTableViewCell.h"
#import "QY_SKSTableView.h"

#import "QY_Common.h"

@interface CameraViewController () <SKSTableViewDelegate>

@property (nonatomic, strong) NSArray *contents;

@property (nonatomic, weak) IBOutlet QY_SKSTableView *tableView ;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation CameraViewController

- (NSArray *)contents {
    if (!_contents) {
        _contents = @[@[@[@"公众号", @"NanJing@qycam.com", @"HuaLi@qycam.com"]],
                      @[@[@"全部摄像机", @"Camera 1", @"Camera 2"]]];
    }
    
    return _contents;
}

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ;
    if (self) {
    }
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[_segment addTarget:self action:@selector(segmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.SKSTableViewDelegate = self ;
    self.tableView.tableFooterView = [[UIView alloc] init] ;//关键语句
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark -- Segment Action

//- (void)segmentChangedValue:(id)sender {
//    switch([(UISegmentedControl *)sender selectedSegmentIndex])
//    {
//        case 0:
//            [self.tableView removeFromSuperview];
//            [self.view addSubview:viewAllController_.view];
//            break;
//            
//        case 1:
//            [viewAllController_.view removeFromSuperview];
//            [self.view addSubview:self.tableView];
//            break;
//            
//        default:
//            break;
//    }
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.contents count] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath {
    return [self.contents[indexPath.section][indexPath.row] count] - 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    
    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 0)) || (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2)))
        cell.isExpandable = YES;
    else
        cell.isExpandable = NO;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
//    static NSString *PublicCellIdentifier = @"SKSTableViewCell";
//    
//    SKSTableViewCell *publicCell = [tableView dequeueReusableCellWithIdentifier:PublicCellIdentifier];
//    
//    if (!publicCell)
//        publicCell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PublicCellIdentifier];
    
    CameraSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CameraSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
#warning 数据源
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            publicCell.textLabel.text = self.contents[indexPath.section][indexPath.row][1];
//            return publicCell;
//        } else {
//            publicCell.textLabel.text = self.contents[indexPath.section][indexPath.row][2];
//            return publicCell;
//        }
        return cell;
    } else {
        NSLog(@"%@",indexPath) ;
        if (indexPath.row == 0) {
            cell.image = [UIImage imageNamed:@"相机分组-子图片1.png"];
            cell.locationText = @"门店1";
            return cell;
        } else {
            cell.image = [UIImage imageNamed:@"相机分组-子图片2.png"];
            cell.locationText = @"门店2";
            return cell;
        }
    }
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)actionToggleRightDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
}

#pragma mark - QY_QRCodeScanerDelegate

/**
 *  成功扫描二维码，普通字符串
 *
 *  @param resultStr 结果字符串
 */
- (void)QY_didScanQRCode:(NSString *)resultStr {
    QYDebugLog(@"扫描普通字符串 %@",resultStr) ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

/**
 *  取消扫描二维码
 */
- (void)QY_didCancelQRCodeScan {
    QYDebugLog(@"取消扫描") ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

/**
 *  扫描到了某种千衍的二维码结构
 *
 *  @param opetion 扫描到的类型
 *  @param info    各种参数
 */
- (void)QY_didScanOption:(QY_QRCodeType)option userInfo:(NSDictionary *)info {
    QYDebugLog(@"扫描千衍二维码！option = %ld info = %@",option,info) ;
    [self.navigationController popViewControllerAnimated:YES] ;
    if ( option == QY_QRCodeType_Binding_Camera ) {
        NSString *cameraId = info[QY_QRCODE_DATA_DIC_KEY][KEY_FOR_DATA_AT_INDEX(1)];
        [self bindingCameraWithCameraId:cameraId] ;
    } else
    if (option == QY_QRCodeType_User )  {
        NSString *friendId = info[QY_QRCODE_DATA_DIC_KEY][KEY_FOR_DATA_AT_INDEX(1)] ;
        [self addFriendWithFriendId:friendId] ;
    }
}

#pragma mark - private

/**
 *  绑定摄像机
 *
 *  @param cameraId
 */
- (void)bindingCameraWithCameraId:(NSString *)cameraId {
    QYDebugLog(@"绑定摄像机！") ;

    QYUser *user = [QYUser currentUser] ;

    if ( user.userId ) {
#warning !!
    } else {
        QYDebugLog(@"user为空") ;
    }
}

- (void)addFriendWithFriendId:(NSString *)friendId {
    QYDebugLog(@"添加好友！") ;
    QYUser *user = [QYUser currentUser] ;

    if ( user ) {
#warning !!
    } else {
        QYDebugLog(@"user为空") ;
    }
}

@end
