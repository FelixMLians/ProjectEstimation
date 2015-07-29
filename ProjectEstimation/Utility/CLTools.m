//
//  CSTTools.m
//  CaiShiTong
//
//  Created by huifu on 14-7-31.
//  Copyright (c) 2014年 深圳市汇富天下网络科技有限公司. All rights reserved.
//

#import "CLTools.h"

@implementation CLTools

+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidateString:(NSString *)myString
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [myString rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound) {
        //CLog(@"包含特殊字符");
        return FALSE;
    }else{
        return TRUE;
    }
    
}

+(BOOL)isValidateNumberString:(NSString *)myString
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSRange userNameRange = [myString rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound) {
        //CLog(@"包含特殊字符");
        return FALSE;
    }else{
        return TRUE;
    }
    
}

+ (NSString *)isIDSFCard:(NSString *)idString
{
    NSString *errorInfo;
    NSArray *valCodeArr = @[@"1", @"0", @"x", @"9", @"8", @"7", @"6", @"5", @"4",
                            @"3", @"2" ];
    NSArray *wi = @[ @"7", @"9", @"10",@"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7",
                     @"9", @"10", @"5", @"8", @"4", @"2"];
    NSMutableString *ai = [[NSMutableString alloc] init];
    
    if (idString.length != 18) {
        errorInfo = @"身份证号码长度应该为18位。";
        return errorInfo;
    }
    else{
        [ai appendString:[idString substringToIndex:17]];
        if (![self isValidateNumberString:ai]) {
            errorInfo = @"身份证18位号码除最后一位外，都应为数字。";
            return errorInfo;
        }
    }
    // =======================(end)========================
    
    // ================ 出生年月是否有效 ================
    NSString *strYear = [ai substringWithRange:NSMakeRange(6, 4)];// 年份
    NSString *strMonth = [ai substringWithRange:NSMakeRange(10, 2)];// 月份
    NSString *strDay = [ai substringWithRange:NSMakeRange(12, 2)];// 日
    if (!([strYear integerValue] <= 2000 && [strYear integerValue] >= 1950 )) {
        errorInfo = @"身份证生日不在有效范围。";
        return errorInfo;
    }
    if (!([strMonth integerValue] >= 1 && [strMonth integerValue] <= 12)) {
        errorInfo = @"身份证月份无效";
        return errorInfo;
    }
    if (!([strDay integerValue] >=1 && [strDay integerValue] <= 31)) {
        errorInfo = @"身份证日期无效";
        return errorInfo;
    }
    // =====================(end)=====================
    
    // ================ 地区码时候有效 ================
    NSArray *areaCodeArr = [[self getAreaCode] allKeys];
    if (![areaCodeArr containsObject:[ai substringToIndex:2]]) {
        errorInfo = @"身份证地区编码错误。";
        return errorInfo;
    }
    // ==============================================
    
    // ================ 判断最后一位的值 ================
    int totalmulAiWi = 0;
    for (int i = 0; i < 17; i++) {
        totalmulAiWi += [[ai substringWithRange:NSMakeRange(i, 1)] intValue] * [wi[i] intValue];
    }
    int mod = totalmulAiWi % 11;
    NSString *strVerifyCode = [NSString stringWithFormat:@"%@",valCodeArr[mod]];
    [ai appendString:strVerifyCode];
    
    if (idString.length == 18) {
        if (![ai isEqualToString:idString]) {
            errorInfo = @"身份证无效，不是合法的身份证号码";
            return errorInfo;
        }
    } else {
        return @"1";
    }
    // =====================(end)=====================
    return @"1";
}

+ (NSMutableDictionary *)getAreaCode
{
    NSMutableDictionary *areaCodeDict = [[NSMutableDictionary alloc] init];
    [areaCodeDict setValue:@"北京" forKey:@"11"];
    [areaCodeDict setValue:@"天津" forKey:@"12"];
    [areaCodeDict setValue:@"河北" forKey:@"13"];
    [areaCodeDict setValue:@"山西" forKey:@"14"];
    [areaCodeDict setValue:@"内蒙古" forKey:@"15"];
    [areaCodeDict setValue:@"辽宁" forKey:@"21"];
    [areaCodeDict setValue:@"吉林" forKey:@"22"];
    [areaCodeDict setValue:@"黑龙江" forKey:@"23"];
    [areaCodeDict setValue:@"上海" forKey:@"31"];
    [areaCodeDict setValue:@"江苏" forKey:@"32"];
    [areaCodeDict setValue:@"浙江" forKey:@"33"];
    [areaCodeDict setValue:@"安徽" forKey:@"34"];
    [areaCodeDict setValue:@"福建" forKey:@"35"];
    [areaCodeDict setValue:@"江西" forKey:@"36"];
    [areaCodeDict setValue:@"山东" forKey:@"37"];
    [areaCodeDict setValue:@"河南" forKey:@"41"];
    [areaCodeDict setValue:@"湖北" forKey:@"42"];
    [areaCodeDict setValue:@"湖南" forKey:@"43"];
    [areaCodeDict setValue:@"广东" forKey:@"44"];
    [areaCodeDict setValue:@"广西" forKey:@"45"];
    [areaCodeDict setValue:@"海南" forKey:@"46"];
    [areaCodeDict setValue:@"重庆" forKey:@"50"];
    [areaCodeDict setValue:@"四川" forKey:@"51"];
    [areaCodeDict setValue:@"贵州" forKey:@"52"];
    [areaCodeDict setValue:@"云南" forKey:@"53"];
    [areaCodeDict setValue:@"西藏" forKey:@"54"];
    [areaCodeDict setValue:@"陕西" forKey:@"61"];
    [areaCodeDict setValue:@"甘肃" forKey:@"62"];
    [areaCodeDict setValue:@"青海" forKey:@"63"];
    [areaCodeDict setValue:@"宁夏" forKey:@"64"];
    [areaCodeDict setValue:@"新疆" forKey:@"65"];
    [areaCodeDict setValue:@"台湾" forKey:@"71"];
    [areaCodeDict setValue:@"香港" forKey:@"81"];
    [areaCodeDict setValue:@"澳门" forKey:@"82"];
    [areaCodeDict setValue:@"国外" forKey:@"91"];
    
    return areaCodeDict;
}

+ (BOOL)isValidatePhoneNumber:(NSString *)numberString
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:numberString];
    if (!isMatch) {
        return NO;
    }
    else
        return YES;
}

+ (NSMutableArray *)myCombinationAlgorithm:(NSMutableArray *)array chooseCount:(int)m
{
    int n = [array count];
    
    if (m > n)
    {
        return nil;
    }
    
    NSMutableArray *allChooseArray = [[NSMutableArray alloc] init];
    NSMutableArray *retArray = [array copy];
    
    // (1,1,1,0,0)
    for(int i=0;i < n;i++)
    {
        if (i < m)
        {
            [array replaceObjectAtIndex:i withObject:@"1"];
        }
        else
        {
            [array replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    
    NSMutableArray *firstArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<n; i++)
    {
        if ([[array objectAtIndex:i] intValue] == 1)
        {
            //            [firstArray addObject:[NSString stringWithFormat:@"%d",i+1]];
            [firstArray addObject:[retArray objectAtIndex:i]];
        }
    }
    
    [allChooseArray addObject:firstArray];
    //    [firstArray release];
    
    int count = 0;
    for(int i = 0; i < n-1; i++)
    {
        if ([[array objectAtIndex:i] intValue] == 1 && [[array objectAtIndex:(i + 1)] intValue] == 0)
        {
            [array replaceObjectAtIndex:i withObject:@"0"];
            [array replaceObjectAtIndex:(i + 1) withObject:@"1"];
            
            for (int k = 0; k < i; k++)
            {
                if ([[array objectAtIndex:k] intValue] == 1)
                {
                    count ++;
                }
            }
            if (count > 0)
            {
                for (int k = 0; k < i; k++)
                {
                    if (k < count)
                    {
                        [array replaceObjectAtIndex:k withObject:@"1"];
                    }
                    else
                    {
                        [array replaceObjectAtIndex:k withObject:@"0"];
                    }
                }
            }
            
            NSMutableArray *middleArray = [[NSMutableArray alloc] init];
            
            for (int k = 0; k < n; k++)
            {
                if ([[array objectAtIndex:k] intValue] == 1)
                {
                    //                    [middleArray addObject:[NSString stringWithFormat:@"%d",k + 1]];
                    [middleArray addObject:[retArray objectAtIndex:k]];
                }
            }
            
            [allChooseArray addObject:middleArray];
            //            [middleArray release];
            
            i = -1;
            count = 0;
        }
    }
    
    return allChooseArray;
}

@end

@implementation NSString (MyAdditions)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation NSData (MyAdditions)

- (NSString*)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, (int)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

@implementation UIImage (Resize)
#pragma mark 返回拉伸好的图片
+ (UIImage *)resizeImage:(NSString *)imgName
{
    return [[UIImage imageNamed:imgName] resizeImage];
}

- (UIImage *)resizeImage
{
    UIEdgeInsets edgeInsets={0.0f,0.0f,0.0f,0.0f};
    return [self resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)resizeImage:(NSString *)imgName withA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c D:(CGFloat)d
{
    
    UIEdgeInsets edgeInsets={a,b,c,d};
    return [[UIImage imageNamed:imgName] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
}

@end

