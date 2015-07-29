//
//  CSTTools.h
//  CaiShiTong
//
//  Created by huifu on 14-7-31.
//  Copyright (c) 2014年 深圳市汇富天下网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface CLTools : NSObject

//判断邮箱合法性
+ (BOOL)validateEmail:(NSString*)email;

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email;

//判断账户字符串是否合法
+ (BOOL)isValidateString:(NSString *)myString;

//验证身份证
+ (NSString *)isIDSFCard:(NSString *)idString;

//验证是否全数字
+ (BOOL)isValidateNumberString:(NSString *)myString;

//验证电话号码是否合法
+ (BOOL)isValidatePhoneNumber:(NSString *)numberString;

//获取省份编号
+ (NSMutableDictionary *)getAreaCode;


@end

#pragma mark - category
@interface NSString (MD5)

- (NSString *)md5;

@end

@interface NSData (MD5)

- (NSString*)md5;

@end

@interface UIImage (Resize)

+ (UIImage *)resizeImage:(NSString *)imgName;

- (UIImage *)resizeImage;

+ (UIImage *)resizeImage:(NSString *)imgName withA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c D:(CGFloat)d;
@end

