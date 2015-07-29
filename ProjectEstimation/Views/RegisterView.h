//
//  RegisterView.h
//  ProjectEstimation
//
//  Created by YuanRong on 15/7/28.
//  Copyright (c) 2015年 Felix M L. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  RegisterView;

@protocol RegisterViewDelegate <NSObject>

- (void)dismissRegisterView;
- (void)registerViewDidRegisterWithAccount:(NSString *)account password:(NSString *)password verifyCode:(NSString *)code;
- (void)registerViewDidSendVerifyCode;

@end

@interface RegisterView : UIView

@property (nonatomic, weak) id<RegisterViewDelegate> delegate;

@end
