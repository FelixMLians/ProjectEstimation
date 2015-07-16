//
//  PopProjectView.h
//  ProjectEstimation
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopProjectViewDelegate <NSObject>

- (void)cancelPopProjectView;
- (void)confirmPopProjectViewWithTitle:(NSString *)title index:(NSUInteger)index isEdit:(BOOL)isEdit;

@end

@interface PopProjectView : UIView<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bgColorButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vertialLineImageView;

@property (nonatomic, weak) id<PopProjectViewDelegate> delegate;
@property (nonatomic, strong) NSMutableString *titleString;
@property (nonatomic, assign) NSUInteger imageIndex;
@property (nonatomic, assign) BOOL isEdit;

- (void)setupBackgroundImage;
@end
