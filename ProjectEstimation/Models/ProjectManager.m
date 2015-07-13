//
//  ProjectManager.m
//  ProjectEstimation
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "ProjectManager.h"
#import "AppDelegate.h"

@implementation ProjectManager

+ (void)addProjectWithName:(NSString *)name
               imageString:(NSString *)image
                isSelected:(BOOL)selected
                createDate:(NSDate *)date
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    ProjectModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectModel" inManagedObjectContext:context];
    model.nameString = name;
    model.bgColorString = image;
    model.isSelected = [NSNumber numberWithBool:selected];
    model.createDate = date;
    model.projectIdString = [NSUUID UUID].UUIDString;
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"保存失败：%@",[error localizedDescription]);
    }
}

+ (void)deleteProjectFromDataBaseByIdentifier:(NSString *)identifier
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProjectModel" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (ProjectModel *info in fetchedObjects) {
        if ([info.projectIdString isEqualToString:identifier]) {
            [context deleteObject:info];
        }
    }
    
    if(![context save:&error])
    {
        NSLog(@"保存失败：%@",[error localizedDescription]);
    }
}

+ (void)editProjectFromDataBase
{
    
}

+ (NSMutableArray *)fetchProjects
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProjectModel" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count > 0) {
        for (ProjectModel *model in fetchedObjects) {
            if (model && ![result containsObject:model]) {
                [result addObject:model];
            }
        }
    }
    
    return result;
}

@end
