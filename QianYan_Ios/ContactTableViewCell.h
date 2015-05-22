//
//  JVRightDrawerTableViewCell.h
//  JVFloatingDrawer
//
//  Created by WardenAllen on 15/5/18.
//  Copyright (c) 2015年 JVillella. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactTableViewCell ;

@protocol ContactTableViewCellDelegate <NSObject>

@optional

- (void)didClickedInviteBtn:(ContactTableViewCell *)cell atIndex:(NSInteger)index ;

- (void)didClickedAddBtn:(ContactTableViewCell *)cell atIndex:(NSInteger)index ;

@end

@interface ContactTableViewCell : UITableViewCell

@property (weak) id<ContactTableViewCellDelegate> delegate ;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *userId;

@end
