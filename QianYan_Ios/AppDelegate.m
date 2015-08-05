//
//  AppDelegate.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/4/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"
#import "SettingsViewController.h"

#define RegisterAndLoginSBNibName @"Register&Login"
#define DrawersStoryBoardNibName @"Drawers"

#define LoginVCStoryBoardID @"LoginVCStoryBoardID"
#define RegisterVCStoryBoardID @"RegisterVCStoryBoardID"
#define QRCodeCardViewControllerStrorBoardID @"QRCodeCardViewControllerStrorBoardID"
#define SystemSettingsViewControllerStoryBoardID @"SystemSettingsViewControllerStoryBoardID"
#define SettingsViewControllerStoryBoardID @"SettingsViewControllerStoryBoardID"
#define ContactTableViewControllerStoryBoardID @"ContactTableViewControllerStoryBoardID"
#define MyPhotoGraphCollectionViewControllerStoryBoardID @"MyPhotoGraphCollectionViewControllerStoryBoardID"
#define WifiSettingViewControllerStoryBoardID @"WifiSettingViewControllerStoryBoardID"
#define AccountInfoViewControllerStoryBoardID @"AccountInfoViewControllerStoryBoardID"
#define CameraSettingCollectionViewControllerStoryBoardID @"CameraSettingCollectionViewControllerStoryBoardID"
#define RacentTableViewControllerStoryBoardID @"RacentTableViewControllerStoryBoardID"
#define PasswordManageViewControllerStoryBoardID @"PasswordManageViewControllerStoryBoardID"
#define ManageNicknameViewControllerStoryBoardID @"ManageNicknameViewControllerStoryBoardID"
#define PhoneNumberIdentifyViewControllerStoryBoardID @"PhoneNumberIdentifyViewControllerStoryBoardID"
#define ManageSignatureViewControllerStoryBoardID @"ManageSignatureViewControllerStoryBoardID"
#define FeedbackViewControllerStoryBoardID @"FeedbackViewControllerStoryBoardID"
#define TextShareViewControllerStoryBoardID @"TextShareViewControllerStoryBoardID"
#define WifiListViewControllerStoryBoardID @"WifiListViewControllerStoryBoardID"
#define SearchFriendTableViewControllerStoryBoardID @"SearchFriendTableViewControllerStoryBoardID"
#define QRCodeDetailViewControllerStoryBoardID @"QRCodeDetailViewControllerStoryBoardID"
#define SetRemarkNameViewControllerStoryBoardID @"SetRemarkNameViewControllerStoryBoardID"
#define CameraAllocationTableViewControllerStoryBoardID @"CameraAllocationTableViewControllerStoryBoardID"
#define InfoSettingViewControllerStoryBoardID @"InfoSettingViewControllerStoryBoardID"


//static NSString * const kJVDrawersStoryboardName = @"Drawers";

static NSString * const kJVLeftDrawerStoryboardID = @"JVLeftDrawerViewControllerStoryboardID";
static NSString * const kJVRightDrawerStoryboardID = @"JVRightDrawerViewControllerStoryboardID";

static NSString * const kJVGitHubProjectPageViewControllerStoryboardID = @"JVGitHubProjectPageViewControllerStoryboardID";
static NSString * const kJVDrawerSettingsViewControllerStoryboardID = @"JVDrawerSettingsViewControllerStoryboardID";

@interface AppDelegate ()

@property (nonatomic, strong, readonly) UIStoryboard *drawersStoryboard;

@end

@implementation AppDelegate

@synthesize drawersStoryboard = _drawersStoryboard;

#pragma mark - 跳转

- (void)toRegiste {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:RegisterAndLoginSBNibName bundle:nil] ;
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:RegisterVCStoryBoardID] ;
    self.window.rootViewController = vc ;
}

- (void)toLogin {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:RegisterAndLoginSBNibName bundle:nil] ;
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:LoginVCStoryBoardID] ;
    self.window.rootViewController = vc ;
}

- (void)toMain {
    self.window.rootViewController = self.drawerViewController ;
}

#pragma mark - Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:RegisterAndLoginSBNibName bundle:nil] ;
//    UIViewController *vc = [sb instantiateInitialViewController] ;
//    self.window.rootViewController = vc ;
    
    [self configureDrawerViewController]; // 配置JVFloatingDrawerViewController
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "QianYan.QianYan_Ios" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QianYan_Ios" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // 建议看Learning Core Data for iOS”，做数据升级和迁移
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:[NSNumber numberWithBool:YES],
                              NSInferMappingModelAutomaticallyOption:[NSNumber numberWithBool:YES]} ;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QianYan_Ios.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Drawer View Controllers

- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
        
        _drawerViewController.leftDrawerWidth = 240.0f ;
        _drawerViewController.rightDrawerWidth = 120.0f ;
    }
    
    return _drawerViewController;
}

#pragma mark Sides

- (UITableViewController *)leftDrawerViewController {
    if (!_leftDrawerViewController) {
        _leftDrawerViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:kJVLeftDrawerStoryboardID];
    }
    
    return _leftDrawerViewController;
}

- (UITableViewController *)rightDrawerViewController {
    if (!_rightDrawerViewController) {
        _rightDrawerViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:kJVRightDrawerStoryboardID];
    }
    
    return _rightDrawerViewController;
}

#pragma mark Center

- (UIViewController *)githubViewController {
    if (!_githubViewController) {
        _githubViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:kJVGitHubProjectPageViewControllerStoryboardID];
    }
    
    return _githubViewController;
}

- (UIViewController *)drawerSettingsViewController {
    if (!_drawerSettingsViewController) {
        _drawerSettingsViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:kJVDrawerSettingsViewControllerStoryboardID];
    }
    
    return _drawerSettingsViewController;
}

- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
        
        _drawerAnimator.animationDelay = 0.0 ;
        _drawerAnimator.animationDuration = 0.8 ;
        _drawerAnimator.initialSpringVelocity = 9.0 ;
        _drawerAnimator.springDamping = 2.0 ;
    }
    
    return _drawerAnimator;
}

- (UIStoryboard *)drawersStoryboard {
    if(!_drawersStoryboard) {
        _drawersStoryboard = [UIStoryboard storyboardWithName:DrawersStoryBoardNibName bundle:nil];
    }
    
    return _drawersStoryboard;
}

- (void)configureDrawerViewController {
    self.drawerViewController.leftViewController = self.leftDrawerViewController;
    self.drawerViewController.rightViewController = self.rightDrawerViewController;
    self.drawerViewController.centerViewController = self.githubViewController;
    
    self.drawerViewController.animator = self.drawerAnimator;
    
    self.drawerViewController.backgroundImage = [UIImage imageNamed:@"背景.png"];
}

#pragma mark - QRCodeCard View Controller

- (UIViewController *)QRCodeCardViewController {
    if (!_QRCodeCardViewController) {
        _QRCodeCardViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:QRCodeCardViewControllerStrorBoardID];
    }
    return _QRCodeCardViewController;
}

#pragma mark - Contact Table View Controller

- (UITableViewController *)ContactTableViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:ContactTableViewControllerStoryBoardID] ;    
//    if (!_ContactTableViewController) {
//        _ContactTableViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:ContactTableViewControllerStoryBoardID];
//    }
//    return _ContactTableViewController;
}

#pragma mark - System Settings View Controller

- (UITableViewController *)systemSettingsTableViewController {
    if (!_systemSettingsTableViewController) {
        _systemSettingsTableViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:SystemSettingsViewControllerStoryBoardID];
    }
    return _systemSettingsTableViewController;
}

#pragma mark - Settings View Controller

- (UIViewController *)settingsViewController {
    if (!_settingsViewController) {
        _settingsViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:SettingsViewControllerStoryBoardID];
    }
    return _settingsViewController;
}

#pragma mark - MyPhotoGraph View Controller

- (UICollectionViewController *)myPhotoGraphCollectionViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:MyPhotoGraphCollectionViewControllerStoryBoardID] ;
//    
//    if (!_myPhotoGraphCollectionViewController) {
//        _myPhotoGraphCollectionViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:MyPhotoGraphCollectionViewControllerStoryBoardID];
//    }
//    return _myPhotoGraphCollectionViewController;
}

#pragma mark - WifiSetting View Controller

- (UIViewController *)controllerWithId:(NSString *)VCSBID {
    if ( !VCSBID ) return nil ;
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:VCSBID] ;
}

- (UIViewController *)WifiSettingViewController {
    if (!_WifiSettingViewController) {
        _WifiSettingViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:WifiSettingViewControllerStoryBoardID];
    }
    return _WifiSettingViewController;
}

#pragma mark -- Account Info View Controller

- (UIViewController *)AccountInfoViewController {
    if (!_AccountInfoViewController) {
        _AccountInfoViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:AccountInfoViewControllerStoryBoardID];
    }
    return _AccountInfoViewController;
}

#pragma mark -- Camera Setting Collection View Controller

- (UICollectionViewController *)CameraSettingCollectionViewController {
    if (!_CameraSettingCollectionViewController) {
        _CameraSettingCollectionViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:CameraSettingCollectionViewControllerStoryBoardID];
    }
    return _CameraSettingCollectionViewController;
}

#pragma mark -- Racent Table View Controller

- (UITableViewController *)RacentTableViewController {
    if (!_RacentTableViewController) {
        _RacentTableViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:RacentTableViewControllerStoryBoardID];
    }
    return _RacentTableViewController;
}

#pragma mark -- Password Manage View Controller

- (UIViewController *)PasswordManageViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:PasswordManageViewControllerStoryBoardID] ;
}

#pragma mark -- Manage Nickname View Controller

- (UIViewController *)ManageNicknameViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:ManageNicknameViewControllerStoryBoardID] ;
}

#pragma mark -- Phone Number Identify View Controller

- (UIViewController *)PhoneNumberIdentifyViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:PhoneNumberIdentifyViewControllerStoryBoardID] ;
}

#pragma mark -- Manage Signature View Controller

- (UIViewController *)ManageSignatureViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:ManageSignatureViewControllerStoryBoardID] ;
}

#pragma mark -- Feedback View Controller

- (UIViewController *)FeedbackViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:FeedbackViewControllerStoryBoardID] ;
}

#pragma mark -- Text Share View Controller

- (UIViewController *)TextShareViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:TextShareViewControllerStoryBoardID] ;
}

#pragma mark -- Wifi List View Controller

- (UITableViewController *)WifiListViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:WifiListViewControllerStoryBoardID] ;
}

#pragma mark -- Search Friend View Controller

- (UITableViewController *)SearchFriendTableViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:SearchFriendTableViewControllerStoryBoardID] ;
}

#pragma mark -- QRCode Detail View Controller

- (UIViewController *)QRCodeDetailViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:QRCodeDetailViewControllerStoryBoardID] ;
}

#pragma mark -- Set Remark Name View Controller

- (UIViewController *)SetRemarkNameViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:SetRemarkNameViewControllerStoryBoardID] ;
}

#pragma mark -- Camera Allocation Table View Controller

- (UITableViewController *)CameraAllocationTableViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:CameraAllocationTableViewControllerStoryBoardID] ;
}

#pragma mark -- Info Setting View Controller

- (UIViewController *)InfoSettingViewController {
    return [self.drawersStoryboard instantiateViewControllerWithIdentifier:InfoSettingViewControllerStoryBoardID] ;
}

#pragma mark - Global Access Helper

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


/*
 *  控制弹回
 */
- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}

- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideRight animated:animated completion:nil];
}

@end
