//
//  DemandEditController.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/27.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DemandMode) {
    DemandModeAdd,
    DemandModeEdit,
};

@interface DemandEditController : UIViewController

@property (nonatomic, copy) NSString *demandIdString;
@property (nonatomic, copy) NSString *projectIdString;
@property (nonatomic, assign) DemandMode currentMode;

@end
