//
//  OfferWallTableViewCell.m
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/30.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "OfferWallTableViewCell.h"

@implementation OfferWallTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)download:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(OfferWallCellWillDownloadByItemId:)]) {
        [self.delegate OfferWallCellWillDownloadByItemId:self.cellIdString];
    }
}

@end
