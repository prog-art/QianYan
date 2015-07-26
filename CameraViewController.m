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

@interface CameraViewController () <SKSTableViewDelegate>

@property (nonatomic, strong) NSArray *contents;

@property (nonatomic, weak) IBOutlet QY_SKSTableView *tableView ;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;

@property (atomic) NSMutableDictionary *cameras ;

@property (weak) QY_JPROHttpService *jproService ;

@end

@implementation CameraViewController

- (NSArray *)publicArray {
    return @[@[@"公众号", @"NanJing@qycam.com", @"HuaLi@qycam.com"]] ;
} ;

- (NSArray *)contents {
    if (!_contents) {
        _contents = @[[self publicArray],
                      @[@[@"全部摄像机",@"testCamera1",@"testCamera2",@"testCamera3"]]];
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

- (void)refreshCameras {
    NSString *userId = [QYUser currentUser].userId ;
    NSString *path = [NSString stringWithFormat:@"user/%@/cameralist",userId] ;
    
    [self.jproService getDocumentListForPath:path Complection:^(NSArray *objects, NSError *error) {
        if ( !error ) {
            QYDebugLog(@"objects = %@",objects) ;
            
            //拿到列表后check ;
            NSMutableArray *noDataCameraFileNames = [NSMutableArray array] ;
            [objects enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
                NSString *tempFileName = [fileName stringByDeletingPathExtension] ;
                QY_camera *localCamera = [QY_camera findCameraById:tempFileName] ;
                if ( localCamera ) {
                    [self.cameras setObject:localCamera forKey:tempFileName] ;
                } else {
                    [noDataCameraFileNames addObject:fileName] ;
                }
            }] ;
            
            //没有数据的去服务器拿
            
            dispatch_group_t group = dispatch_group_create() ;
            [noDataCameraFileNames enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
                
                dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
                    NSString *path = [NSString stringWithFormat:@"user/%@/cameralist/%@",userId,fileName] ;
                    
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0) ;
                    
                    [self.jproService downloadFileFromPath:path complection:^(NSString *xmlStr, NSError *error) {
                        if ( xmlStr ) {
                            QYDebugLog(@"file = %@,content = %@",fileName,xmlStr) ;
                            QY_camera *camera = [QY_XMLService getCameraFromIdXML:xmlStr] ;
                            QYDebugLog(@"camera = %@",camera) ;
                            [self.cameras setObject:camera forKey:[fileName stringByDeletingPathExtension]] ;
                        } else {
                            QYDebugLog(@"error = %@",error) ;
                        }
                        dispatch_semaphore_signal(sema) ;
                    }] ;
                    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC) ;
                    dispatch_semaphore_wait(sema, timeout) ;
                    QYDebugLog(@"group %lu ok",(unsigned long)idx) ;
                }) ;
            }] ;
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                QYDebugLog(@"请求结束！") ;
                [self didReceiveCameraData] ;
            }) ;
            
        } else {
            QYDebugLog(@"error = %@",error);
        }
    }] ;
}

- (void)didReceiveCameraData {
    //处理tableView需要的数据格式
    NSMutableArray *tcontents = [NSMutableArray array] ;
    
    [tcontents addObject:[self publicArray]] ;
    
    NSMutableArray *tcameras = [NSMutableArray array] ;
    [tcameras addObject:@"全部摄像机"] ;
    
    [self.cameras enumerateKeysAndObjectsUsingBlock:^(NSString *key, QY_camera *camera, BOOL *stop) {
        [tcameras addObject:camera] ;
    }] ;
    
    [tcontents addObject:@[tcameras]] ;
    
    self.contents = tcontents ;
    [self.tableView reloadData] ;
    
    [self refreshCamerasState] ;
}


- (void)refreshCamerasState {
    QYDebugLog(@"请求相机状态") ;
    //通过notificaiton接受通知
    [[QY_JMSService shareInstance] getCamerasStateByIds:[NSSet setWithArray:self.cameras.allKeys]] ;
}

- (void)didReceiveCamerasState:(NSNotification *)notification {
    NSArray *stateArr = notification.object ;
    
    QYDebugLog(@"states = %@",stateArr) ;
    
    [stateArr enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
        NSString *cameraId = info[QY_key_jipnc_id] ;
        NSNumber *stateNum = info[QY_key_jipnc_status] ;
        
        QY_camera *camera = self.cameras[cameraId] ;
        camera.status = stateNum ;
    }] ;
    
    [QY_appDataCenter saveObject:nil error:NULL] ;
    
    [self.tableView reloadData] ;
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameReceiveCamerasState object:nil] ;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveCamerasState:) name:kNotificationNameReceiveCamerasState object:nil] ;
}

- (void)dealloc {
    [self removeObserver] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self removeObserver] ;
    [self addObserver] ;
    
    self.cameras = [NSMutableDictionary dictionary] ;
    self.jproService = [QY_JPROHttpService shareInstance] ;
    //[_segment addTarget:self action:@selector(segmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.SKSTableViewDelegate = self ;
    self.tableView.tableFooterView = [[UIView alloc] init] ;//关键语句
    
    [self refreshCameras] ;
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
        case 0: {
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
            
            QY_camera *camera = self.contents[indexPath.section][indexPath.row][indexPath.subRow] ;

            cell.image = [UIImage imageNamed:@"相机分组-子图片1.png"] ;
            cell.locationText = camera.cameraId ;
            cell.state = [camera.status boolValue] ;
            
//            if (indexPath.subRow == 1) {
//                cell.image = [UIImage imageNamed:@"相机分组-子图片1.png"];
//                cell.locationText = @"门店1";
//            }
//            else if (indexPath.subRow == 2) {
//                cell.image = [UIImage imageNamed:@"相机分组-子图片2.png"];
//                cell.locationText = @"门店2";
//            } else {
//                cell.image = [UIImage imageNamed:@"相机分组-子图片1.png"];
//                cell.locationText = [NSString stringWithFormat:@"门店%ld",(long)indexPath.subRow] ;
//            }
            
            return cell ;
            break ;
        }
            
            
        default:
            return nil ;
            break;
    }
}

#pragma mark - Actions

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)actionToggleRightDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
}

@end
