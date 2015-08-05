//
//  QY_appDataCenter.m
//  QianYan_Ios
//
//  Created by 虎猫儿 on 15/7/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "QY_appDataCenter.h"

#import "QY_Common.h"
#import "AppDelegate.h"

@implementation QY_appDataCenter

+ (NSManagedObjectContext *)managedObjectContext {
    return [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext] ;
}

+ (instancetype)shareInstance {
    static QY_appDataCenter *sharedInstance = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QY_appDataCenter alloc] init] ;
    }) ;
    return sharedInstance ;
}

+ (QY_user *)userWithId:(NSString *)userId {
    //先查
    QY_user *user = [self findUserById:userId] ;
    
    if ( user != nil ) {
        return user ;
    } else {
        //没有就插入一个
        return [self insertUserById:userId] ;
    }
}

+ (QY_user *)insertUserById:(NSString *)userId {
    assert(userId) ;
    
    NSString *className = NSStringFromClass([QY_user class]) ;
    QY_user *user = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[self managedObjectContext]] ;
    if ( user != nil ) {
        user.userId = userId ;
        return user ;
//        NSError *savingError = nil ;
//        if ( [[self managedObjectContext] save:&savingError] ) {
//            QYDebugLog(@"success saved user = %@",user) ;
//            return user ;
//        } else {
//            QYDebugLog(@"failed to save the user , error = %@",savingError) ;
//            return nil ;
//        }
    } else {
        QYDebugLog(@"failed to create new user") ;
        return nil ;
    }
}

+ (QY_user *)findUserById:(NSString *)userId {
    assert(userId) ;
    NSString *className = NSStringFromClass([QY_user class]) ;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@",userId] ;
    return (QY_user *)[self findObjectWithClassName:className predicate:predicate] ;
}

+ (BOOL)saveObject:(NSManagedObject *)object error:(NSError **)error {
#warning 加锁
    
    if ( [[self managedObjectContext] save:error] ) {
        return YES ;
    } else {
        return NO ;
    }    
}

#pragma mark - Core Data 删

+ (BOOL)deleteObjectsWithClassName:(NSString *)className predicate:(NSPredicate *)predicate {
    assert(className) ;
    NSArray *objects = [self findObjectsWithClassName:className predicate:predicate] ;
    
    NSManagedObjectContext *context = [self managedObjectContext] ;
    
    [objects enumerateObjectsUsingBlock:^(NSManagedObject *obj, NSUInteger idx, BOOL *stop) {
        [context deleteObject:obj] ;
    }] ;
    
    NSError *savingError = nil ;
    
    BOOL result = [self saveObject:nil error:&savingError] ;
    
    if ( result ) {
        QYDebugLog(@"删除成功") ;
    } else {
        QYDebugLog(@"删除失败 error = %@",savingError) ;
    }
    
    return result ;
}

+ (BOOL)deleteobject:(NSManagedObject *)object {
    if ( !object ) return FALSE ;
    
    [[self managedObjectContext] deleteObject:object] ;
    
    [self saveObject:nil error:NULL] ;
    
    return TRUE ;    
}

#pragma mark - Core Data 查

+ (NSManagedObject *)findObjectWithClassName:(NSString *)className predicate:(NSPredicate *)predicate {
    assert(className) ;
    NSArray *objects = [self findObjectsWithClassName:className predicate:predicate] ;
    
    NSUInteger count = [objects count] ;
    
    if ( count == 0) {
        return nil ;
    }
    else {
        if ( count > 1 ) {
            QYDebugLog(@"count = %lu,objects = %@,请检查输入！",(unsigned long)count,objects) ;
        }
        return [objects lastObject] ;
    }    
}

+ (NSArray *)findObjectsWithClassName:(NSString *)className predicate:(NSPredicate *)predicate {
    assert(className) ;
    NSError *requestError = nil ;
    NSArray *objects = [self findObjectsWithClassName:className predicate:predicate error:&requestError] ;
    return objects ;
}

+ (NSArray *)findObjectsWithClassName:(NSString *)className predicate:(NSPredicate *)predicate error:(NSError **)error {
    assert(className) ;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *Entity = [NSEntityDescription entityForName:className inManagedObjectContext:[self managedObjectContext]] ;
    [fetchRequest setEntity:Entity] ;
    [fetchRequest setPredicate:predicate] ;
    
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:error] ;
    return objects ;
}

@end
