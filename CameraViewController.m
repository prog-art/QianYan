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
#import "QY_JPROHttpService.h"
#import "QY_XMLService.h"
#import "QY_JMSService.h"
#import "QY_appDataCenter.h"

#import "KxMovieViewController.h"

@interface CameraViewController () <SKSTableViewDelegate>

@property (nonatomic, weak) IBOutlet QY_SKSTableView *tableView ;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong,nonatomic) UIRefreshControl *refreshControl ;

@property (weak) QY_JPROHttpService *jproService ;

//data
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic) NSMutableDictionary *cameraSettings ;

@end

@implementation CameraViewController

#pragma mark - getter && setter

- (NSArray *)publicArray {
    return @[@[@"公众号", @"NanJing@qycam.com", @"HuaLi@qycam.com"]] ;
} ;

- (NSArray *)contents {
    if (!_contents) {
        _contents = @[[self publicArray],
                      @[@[@"全部摄像机"]]];
    }
    return _contents;
}

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
    }
    return _refreshControl ;
}

- (NSMutableDictionary *)cameraSettings {
    if ( !_cameraSettings ) {
        _cameraSettings = [NSMutableDictionary dictionary] ;
    }
    return _cameraSettings ;
}

#pragma mark - refresh


- (void)refresh:(UIRefreshControl *)refreshControl {
    if ( refreshControl ) {
        [refreshControl beginRefreshing] ;
    }

    self.cameraSettings = nil ;
    
    [[QYUser currentUser].coreUser fetchCamerasSettingsComplection:^(NSArray *settings, NSError *error) {
        if ( settings ) {
            QYDebugLog(@"objects = %@",settings) ;
            self.cameraSettings = nil ;
            [settings enumerateObjectsUsingBlock:^(QY_cameraSetting *setting, NSUInteger idx, BOOL *stop) {
                [self.cameraSettings setObject:setting forKey:setting.toCamera.cameraId] ;
            }] ;
            
            QYDebugLog(@"请求相机状态") ;
            //通过notificaiton接受通知
            
            NSSet *cameraIds = [NSSet setWithArray:self.cameraSettings.allKeys] ;
            if ( cameraIds && cameraIds.count != 0 ) {
                QYDebugLog(@"cameraIds = %@",cameraIds) ;
                
                [[QY_JMSService shareInstance] getCamerasStateByIds:cameraIds complection:^(NSArray *stateArr, NSError *error) {
                    [self.refreshControl endRefreshing] ;
                    
                    if ( stateArr ) {
                        [stateArr enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
                            NSString *cameraId = info[QY_key_jipnc_id] ;
                            NSNumber *stateNum = info[QY_key_jipnc_status] ;
                            
                            QY_cameraSetting *setting = self.cameraSettings[cameraId] ;
                            QY_camera *camera = setting.toCamera ;
                            camera.status = stateNum ;
                        }] ;
                        
                        [self beforeReloadData] ;
                    } else {
                        QYDebugLog(@"获取相机状态出错,error = %@",error) ;
                        [QYUtils alertError:error] ;
                    }
                }] ;
            } else {
                QYDebugLog(@"cameraIds = %@",cameraIds) ;
                [self.refreshControl endRefreshing] ;
            }
            
            
            
        } else {
            [self.refreshControl endRefreshing] ;
            QYDebugLog(@"error = %@",error) ;
        }
    }] ;
    
}

- (void)beforeReloadData {
    //处理tableView需要的数据格式
    NSMutableArray *tcontents = [NSMutableArray array] ;
    
    [tcontents addObject:[self publicArray]] ;
    
    NSMutableArray *tCameraSettings = [NSMutableArray array] ;
    [tCameraSettings addObject:@"全部摄像机"] ;

    [self.cameraSettings enumerateKeysAndObjectsUsingBlock:^(NSString *key, QY_cameraSetting *setting, BOOL *stop) {
        [tCameraSettings addObject:setting] ;
    }] ;
    
    [tcontents addObject:@[tCameraSettings]] ;
    
    self.contents = tcontents ;
    [self.tableView reloadData] ;
}

#pragma mark - Life Cycle

- (void)userDidLogout {
    self.cameraSettings = nil ;
    [self beforeReloadData] ;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;

    self.jproService = [QY_JPROHttpService shareInstance] ;
    
    self.tableView.SKSTableViewDelegate = self ;
    self.tableView.tableFooterView = [[UIView alloc] init] ;//关键语句
    [self.tableView addSubview:self.refreshControl] ;

    self.cameraSettings = nil ;
    {    //处理tableView需要的数据格式
        [[[QYUser currentUser].coreUser cameraSettings] enumerateObjectsUsingBlock:^(QY_cameraSetting *setting, BOOL *stop) {
            [self.cameraSettings setObject:setting forKey:setting.toCamera.cameraId] ;
        }] ;
        
        NSMutableArray *tcontents = [NSMutableArray array] ;
        
        [tcontents addObject:[self publicArray]] ;
        
        NSMutableArray *tCameraSettings = [NSMutableArray array] ;
        [tCameraSettings addObject:@"全部摄像机"] ;
        
        [self.cameraSettings enumerateKeysAndObjectsUsingBlock:^(NSString *key, QY_cameraSetting *setting, BOOL *stop) {
            setting.toCamera.status = @0 ;
            [tCameraSettings addObject:setting] ;
        }] ;
        
        [tcontents addObject:@[tCameraSettings]] ;
        
        self.contents = tcontents ;
    }
    
    [[QY_Notify shareInstance] addLogoutObserver:self selector:@selector(userDidLogout)] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

- (void)dealloc {
    [[QY_Notify shareInstance] removeLogoutObserver:self] ;
}

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
    
    NSInteger num = [self tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:indexPath] ;
    if ( num > 0 ) {
        cell.isExpandable = YES ;
    } else {
        cell.isExpandable = NO ;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0 : {
            static NSString *PublicCellIdentifier = @"SKSTableViewCell";
        
            SKSTableViewCell *publicCell = [tableView dequeueReusableCellWithIdentifier:PublicCellIdentifier];
        
            if (!publicCell)
                publicCell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PublicCellIdentifier];
            
            
            publicCell.textLabel.text = self.contents[indexPath.section][indexPath.row][indexPath.subRow] ;
            
            return publicCell ;
            
            break;
        }
            
        case 1 : {
            static NSString *CellIdentifier = @"Cell";
            
            CameraSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[CameraSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            QY_cameraSetting *setting = self.contents[indexPath.section][indexPath.row][indexPath.subRow] ;
            QY_camera *camera = setting.toCamera ;


            cell.image = [UIImage imageNamed:@"相机分组-子图片1.png"] ;
            cell.locationText = camera.cameraId ;
            cell.state = [camera.status boolValue] ;
            
#warning bug! 每次都会去获取！！                       
            if ( cell.state ) {
                [camera displayCameraThumbnailAtImageView:cell.imageView useCache:NO] ;
            } else {
                [camera displayCameraThumbnailAtImageView:cell.imageView useCache:YES] ;
            }
            
            return cell ;
            break ;
        }
            
        default:
            return nil ;
            break;
    }
}

/**
 *  看直播d(^_^o)
 *
 *  @param camera
 */
- (void)watchLive:(QY_camera *)camera {
    //不检查了
    
    if ( [camera.status boolValue] == FALSE ) {
        [QYUtils alert:@"相机不在线(・Д・)ノ"] ;
        return ;
    }
    
    NSString *path = [NSString stringWithFormat:@"rtsp://%@:%@@%@:%@/%@",camera.jssId,camera.jssPassword,camera.jssIp,camera.jssPort,camera.cameraId] ;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path parameters:parameters] ;
    
    [self.navigationController pushViewController:vc animated:NO] ;
}

/**
 *  拉取相机jss信息
 *
 *  @param camera
 */
- (void)fetchCameraJssInfo:(QY_camera *)camera {
    QYDebugLog(@"fecth jss info") ;
    [[QY_SocketAgent shareInstance] getCameraJSSInfoByCameraId:camera.cameraId Complection:^(NSDictionary *info, NSError *error) {
        if ( info ) {
            QYDebugLog(@"成功~") ;
            camera.cameraPassword = info[ParameterKey_jipncPassword] ;
            camera.jssId = info[ParameterKey_jssId] ;
            camera.jssPassword = info[ParameterKey_jssPassword] ;
            camera.jssIp = info[ParameterKey_jssIp] ;
            camera.jssPort = info[ParameterKey_jssPort] ;
            
            [QY_appDataCenter saveObject:nil error:NULL] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self watchLive:camera] ;
            }) ;
            
        } else {
            [QYUtils alertError:error] ;
        }
    }] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.section == 1 &&  indexPath.row > 0 ) {
        QY_cameraSetting *setting = self.contents[indexPath.section][0][indexPath.row] ;
        QY_camera *camera = setting.toCamera ;
        
        if ( !camera.jssId ) {
            [self fetchCameraJssInfo:camera] ;
        } else {
            [self watchLive:camera] ;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)actionToggleRightDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
}

@end
