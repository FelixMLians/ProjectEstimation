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
                isSelected:(BOOL)selected
                createDate:(NSDate *)date;
+ (void)deleteProjectFromDataBaseByIdentifier:(NSString *)identifier;
+ (void)editProjectFromDataBase;
+ (NSMutableArray *)fetchProjects;

@end
