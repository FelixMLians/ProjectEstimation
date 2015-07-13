//
//  DemandCollectionViewCell.m
//  ProjectEstimation
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "DemandCollectionViewCell.h"

@implementation DemandCollectionViewCell

#pragma mark - Accessors
- (UILabel *)displayLabel {
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _displayLabel.backgroundColor = [UIColor clearColor];
        _displayLabel.textColor = [UIColor whiteColor];
        _displayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _displayLabel;
}

- (void)setDisplayString:(NSString *)displayString {
    if (![_displayString isEqualToString:displayString]) {
        _displayString = [displayString copy];
        self.displayLabel.text = _displayString;
    }
}

#pragma mark - Life Cycle
- (void)dealloc {
    [_displayLabel removeFromSuperview];
    _displayLabel = nil;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Pick a cat at random.
        NSUInteger pickACat = arc4random_uniform(4) + 1;     // Vary from 1 to 4.
        NSString *catFilename = [NSString stringWithFormat:@"cat%lu.jpg", (unsigned long)pickACat];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:catFilename]];
        // Scale with fill for contents when we resize.
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        // Scale the imageview to fit inside the contentView with the image centered:
        CGRect imageViewFrame = CGRectMake(0.f, 0.f, CGRectGetMaxX(self.contentView.bounds), CGRectGetMaxY(self.contentView.bounds));
        imageView.frame = imageViewFrame;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        
        [self.contentView addSubview:self.displayLabel];
    }
    return self;
}

@end
