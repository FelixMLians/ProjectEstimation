//
//  DemandModel.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/27.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectModel;

@interface DemandModel : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * demandIdString;
@property (nonatomic, retain) NSString * desString;
@property (nonatomic, retain) NSString * picPathString;
@property (nonatomic, retain) NSString * titleString;
@property (nonatomic, retain) NSString * projectIdString;
@property (nonatomic, retain) ProjectModel *toProject;

@end
