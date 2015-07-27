//
//  ProjectManager.h
//  ProjectEstimation
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectModel.h"

@interface ProjectManager : NSObject

+ (void)addProjectWithName:(NSString *)name
               imageString:(NSString *)image
                createDate:(NSDate *)date;

+ (void)deleteProjectFromDataBaseByIdentifier:(NSString *)identifier;

+ (void)editProjectWithName:(NSString *)name
                imageString:(NSString *)image
               ByIdentifier:(NSString *)identifier;

+ (NSMutableArray *)fetchProjects;

+ (ProjectModel *)fetchModelByIdentifier:(NSString *)identifier;

@end
