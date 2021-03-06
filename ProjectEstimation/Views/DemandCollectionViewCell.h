//
//  DemandCollectionViewCell.h
//  ProjectEstimation
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DemandCollectionCellDelegate <NSObject>

- (void)deleteDemandCellByIdentifier:(NSString *)identifier;

@end

@interface DemandCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *desString;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *demandIdString;
@property (nonatomic, weak) id<DemandCollectionCellDelegate> delegate;

@end
