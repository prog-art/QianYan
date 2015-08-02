//
//  QYViewController.h
//  
//
//  Created by 虎猫儿 on 15/7/12.
//
//

#import <UIKit/UIKit.h>
#import "QY_QRCode.h"

#import "QY_Block_Define.h"

/**
 *  基本ViewController,支持二维码回调
 */
@interface QYBaseViewController : UIViewController<QY_QRCodeScanerDelegate>

- (void)deleteFriendWithId:(NSString *)friendId complection:(QYResultBlock)complection ;

@end