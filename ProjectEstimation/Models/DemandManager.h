//
//  DemandManager.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/27.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemandModel.h"

@interface DemandManager : NSObject

+ (void)addDemandWithTitle:(NSString *)title
             picPathString:(NSString *)path
                 desString:(NSString *)desString
                createDate:(NSDate *)date
                  parentId:(NSString *)parentId
                identifier:(NSString *)identifier;

+ (void)deleteDemandFromDataBaseByIdentifier:(NSString *)identifier;

+ (void)editDemandWithTitle:(NSString *)title
              picPathString:(NSString *)path
                  desString:(NSString *)desString
                 identifier:(NSString *)identifier;

+ (NSMutableArray *)fetchProjectsByParentId:(NSString *)parentId;

@end
