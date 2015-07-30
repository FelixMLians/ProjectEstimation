//
//  OfferWallTableViewCell.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/30.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OfferWallTableViewCellDelegate <NSObject>

- (void)OfferWallCellWillDownloadByItemId:(NSString *)identifier;

@end

@interface OfferWallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (copy, nonatomic) NSString *cellIdString;
@property (weak, nonatomic) id<OfferWallTableViewCellDelegate> delegate;

@end
