//
//  AppDelegate.h
//  ProjectEstimation
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//侧滑两个控制器
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

