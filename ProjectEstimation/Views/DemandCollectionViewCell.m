//
//  DemandCollectionViewCell.m
//  ProjectEstimation
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "DemandCollectionViewCell.h"
#import "Macro.h"

#define kProjectViewFont [UIFont systemFontOfSize:12.0]
#define kCollectionCellWidth ((SCREEN_WIDTH - 45)/2)

@interface DemandCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *desView;
@property (nonatomic, strong) UILabel *desLabel;

@end

@implementation DemandCollectionViewCell

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.layer.cornerRadius = 6.0;
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOffset:CGSizeMake(0, 6)];
        [self.layer setShadowOpacity:0.5];
        [self.layer setShadowRadius:10.0];
        
        [self addImageView];
        [self addDesView];
    }
    return self;
}

- (void)addImageView {
    
    if (!self.image) {
    // Pick a cat at random.
    NSUInteger pickACat = arc4random()%5 + 1;     // Vary from 1 to 4.
    NSString *imageName = [NSString stringWithFormat:@"background%zd", pickACat];
    self.image = [UIImage imageNamed:imageName];
    }
    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    CGRect imageViewFrame = CGRectMake(0.f, 0.f, CGRectGetMaxX(self.contentView.bounds), CGRectGetMaxY(self.contentView.bounds));
    self.imageView.frame = imageViewFrame;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 6.0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    [self.contentView sendSubviewToBack:self.imageView];
    
}

- (void)addDesView
{
    // 添加项目视图
    self.desView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20, kCollectionCellWidth, 20)];
    self.desView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.imageView addSubview:self.desView];
    
    self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kCollectionCellWidth - 20, 20)];
    self.desLabel.backgroundColor = [UIColor clearColor];
    self.desLabel.textAlignment = NSTextAlignmentCenter;
    self.desLabel.textColor = [UIColor whiteColor];
    self.desLabel.numberOfLines = 1;
    self.desLabel.font = kProjectViewFont;
    //    self.projectView.layer.shadowColor = [UIColor groupTableViewBackgroundColor].CGColor;
    //    self.projectView.layer.shadowOpacity = 0.5;
    //    self.projectView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    //    self.projectView.layer.shadowRadius = 3.0;
    [self.desView addSubview:self.desLabel];
}


#pragma mark - setter methods

- (void)setDesString:(NSString *)desString {
    _desString = desString;
    
    self.desLabel.text = desString;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    if (image) {
    [self.imageView setImage:image];
    }
}

@end
