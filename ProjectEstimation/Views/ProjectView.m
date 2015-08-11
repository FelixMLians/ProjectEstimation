//
//  ProjectView.m
//  ProjectEstimation
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import "ProjectView.h"

@implementation ProjectView
{
    UILabel *nameLabel;
    UIImageView *bgImgView;
    UIImageView *leftImgView;
}

@synthesize nameString = _nameString;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
//    self.layer.cornerRadius = 6.0;
    
    bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"book_cover_%d", 4]]];
    bgImgView.frame = self.bounds;
    [self addSubview:bgImgView];
    
    leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 15, self.frame.size.height - 20)];
    leftImgView.image = [UIImage imageNamed:@"menu_accounts_bg_special"];
    [self addSubview:leftImgView];

    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImgView.frame.size.width + 8, 30, self.frame.size.width - leftImgView.frame.size.width - 20, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"项目 X计划";
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:nameLabel];
}

#pragma mark - getter setter method

- (void)setNameString:(NSString *)nameString {
    _nameString = nameString;
    
    [self setNeedsDisplay];
    
    nameLabel.text = nameString;
    CGRect rect = [nameString boundingRectWithSize:CGSizeMake(nameLabel.frame.size.width, self.frame.size.height - 20 - 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0], NSFontAttributeName, nil] context:nil];
    [nameLabel setFrame:CGRectMake(leftImgView.frame.size.width + 8, 30, self.frame.size.width - leftImgView.frame.size.width - 20, rect.size.height)];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    [self setNeedsDisplay];
    
    if (self.isSelected && self.imageIndex > 0) {
        UIImageView *selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftImgView.frame.size.width + 8, 0, 15, 25)];
        selectImgView.image = [UIImage imageNamed:@"menu_selected_icon"];
        [self addSubview:selectImgView];
    }
}

- (NSString *)nameString {
    return _nameString;
}

- (void)setImageIndex:(NSUInteger)imageIndex {
    _imageIndex = imageIndex;
    [bgImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"book_cover_%zd", imageIndex]]];
}

@end
