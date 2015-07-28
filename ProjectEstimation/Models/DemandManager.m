//
//  DemandManager.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/27.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "DemandManager.h"
#import "AppDelegate.h"
#import "ProjectManager.h"

@implementation DemandManager

+ (void)addDemandWithTitle:(NSString *)title
             picPathString:(NSString *)path
                 desString:(NSString *)desString
                createDate:(NSDate *)date
                  parentId:(NSString *)parentId
                identifier:(NSString *)identifier
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    DemandModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"DemandModel" inManagedObjectContext:context];
    model.titleString = title;
    model.picPathString = path;
    model.createDate = date;
    model.desString = desString;
    model.demandIdString = identifier;
    model.projectIdString = parentId;
    
    ProjectModel *parentModel = [ProjectManager fetchModelByIdentifier:parentId];
    model.toProject = parentModel;
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"保存失败：%@",[error localizedDescription]);
    }
    
}

+ (void)deleteDemandFromDataBaseByIdentifier:(NSString *)identifier
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DemandModel" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (DemandModel *info in fetchedObjects) {
        if ([info.demandIdString isEqualToString:identifier]) {
            [context deleteObject:info];
        }
    }
    
    if(![context save:&error])
    {
        NSLog(@"保存失败：%@",[error localizedDescription]);
    }
}

+ (void)editDemandWithTitle:(NSString *)title
              picPathString:(NSString *)path
                  desString:(NSString *)desString
                 identifier:(NSString *)identifier
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DemandModel" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (DemandModel *model in fetchedObjects) {
        if ([model.demandIdString isEqualToString:identifier]) {
            if (title && ![title isEqualToString:@""]) {
                model.titleString = title;
            }
            if (path && ![path isEqualToString:@""]) {
                model.picPathString = path;
            }
            if (desString && ![desString isEqualToString:@""]) {
                model.desString = desString;
            }
        }
    }
    
    if(![context save:&error])
    {
        NSLog(@"保存失败：%@",[error localizedDescription]);
    }
}

+ (NSMutableArray *)fetchProjectsByParentId:(NSString *)parentId
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    fetchRequest.sortDescriptors = @[sort];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DemandModel"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count > 0) {
        for (DemandModel *model in fetchedObjects) {
            if (model && ![result containsObject:model]) {
                if ([model.projectIdString isEqualToString:parentId]) {
                    [result addObject:model];
                }
            }
        }
    }
    
    return result;
}

+ (DemandModel *)fetchModelByDemandId:(NSString *)demandId
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    fetchRequest.sortDescriptors = @[sort];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DemandModel"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count > 0) {
        for (DemandModel *model in fetchedObjects) {
            if (model && [model.demandIdString isEqualToString:demandId]) {
                return model;
            }
        }
    }
    
    return nil;
}

@end
