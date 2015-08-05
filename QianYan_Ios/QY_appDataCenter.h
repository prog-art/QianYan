//
//  QY_appDataCenter.h
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QY_CoreDataModels.h"

@interface QY_appDataCenter : NSObject

+ (instancetype)shareInstance ;

+ (QY_user *)userWithId:(NSString *)userId ;

+ (NSManagedObjectContext *)managedObjectContext ;

+ (BOOL)saveObject:(NSManagedObject *)object error:(NSError **)error ;

//查唯一！
+ (NSManagedObject *)findObjectWithClassName:(NSString *)className predicate:(NSPredicate *)predicate ;

//查一群！
+ (NSArray *)findObjectsWithClassName:(NSString *)className predicate:(NSPredicate *)predicate ;
+ (NSArray *)findObjectsWithClassName:(NSString *)className predicate:(NSPredicate *)predicate error:(NSError **)error ;

+ (BOOL)deleteObjectsWithClassName:(NSString *)className predicate:(NSPredicate *)predicate ;

+ (BOOL)deleteobject:(NSManagedObject *)object ;

@end
