//
//  DemandCollectionViewCell.m
//  ProjectEstimation
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "DemandCollectionViewCell.h"

@implementation DemandCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor purpleColor];
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.2];
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

@end
