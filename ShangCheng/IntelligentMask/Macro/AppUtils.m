//
//  AppUtils.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/11.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "AppUtils.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include "base64.h"

#import "MBProgressHUD.h"
#import "LZProgressView.h"
#import "URLManager.h"
#define MBTAG  1001
#define AMTAG  1111

@implementation AppUtils
+(void)setUrlWithState:(BOOL)state
{
    [[URLManager defaultManager] setUrlWithState:state];
}

+(NSString *)returnBaseUrl
{
    return [[URLManager defaultManager] returnBaseUrl];
}

+(NSString *)returnShopBaseUrl
{
    return [[URLManager defaultManager] returnShopBaseUrl];
}

+ (NSString*) appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNumString
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //    NSString *MOBILEString = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *MOBILEString = @"^1([3-9][0-9])\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    
    NSString *CMString = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    
    NSString * CUString = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    
    NSString * CTString = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    
    // NSString * PHSString = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILEString];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CMString];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CUString];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CTString];
    
    if (([regextestmobile evaluateWithObject:mobileNumString] == YES)
        || ([regextestcm evaluateWithObject:mobileNumString] == YES)
        || ([regextestct evaluateWithObject:mobileNumString] == YES)
        || ([regextestcu evaluateWithObject:mobileNumString] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 身份证验证
 */
+ (BOOL)isIDCardNumber:(NSString *)value {
    //检查 去掉两端的空格
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //检查长度
    int length = 0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    //检查省份代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

+ (BOOL)isEmailValid:(NSString *)email
{
    if (email == (id)[NSNull null] || email.length == 0) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return ([emailTest evaluateWithObject:email] == YES);
    
    
}

+ (BOOL)isNullStr:(NSString *)str
{
    if (str == nil || [str isEqual:[NSNull null]] || str.length == 0) {
        return  YES;
    }
    
    return NO;
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+(BOOL)isValidateNumericalValue:(NSString *)string
{
    if ([self isPureFloat:string]) {
        return YES;
    }
    
    if ([self isPureInt:string]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLogined:(NSString *)uid
{
    if (![self isNullStr:uid]) {
        if ([uid integerValue] > 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)showLoadInfo:(NSString *)text{
    UIWindow *appRootView = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = (MBProgressHUD *)[appRootView viewWithTag:MBTAG];
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:appRootView];
        HUD.tag = MBTAG;
        [appRootView addSubview:HUD];
        [HUD show:YES];
    }
    
    HUD.removeFromSuperViewOnHide = YES; // 设置YES ，MB 再消失的时候会从super 移除
    
    if ([self isNullStr:text]) {
        //        HUD.animationType = MBProgressHUDAnimationZoom;
        [HUD hide:YES];
    }else{
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = text;
        HUD.labelFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
        [HUD hide:YES afterDelay:1];
    }
}

+ (void)showInfo:(NSString*)str
{
    [self showLoadInfo:str];
}

+ (void)showProgressBarForView:(UIView *)view
{
    LZProgressView *HUD = (LZProgressView *)[view viewWithTag:AMTAG];
    if (HUD == nil) {
        CGRect frame = CGRectMake(0, 0, 26, 26);
        HUD = [[LZProgressView alloc] initWithFrame:frame andLineWidth:3.0f andLineColor:@[[UIColor orangeColor],[UIColor grayColor]]];
        HUD.tag = AMTAG;
        HUD.center = CGPointMake(view.center.x, view.center.y - 64);
        [view addSubview:HUD];
    }
    [HUD startAnimation];
}

+ (void)hideProgressBarForView:(UIView *)view
{
    LZProgressView *HUD = (LZProgressView *)[view viewWithTag:AMTAG];
    if (HUD != nil) {
        [HUD stopAnimation];
    }
}

+(id)localUserDefaultsForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:key];
    return token;
}

+(void)localUserDefaultsValue:(id)value forKey:(NSString *)key
{
    if ((value == nil) || ([value isKindOfClass:[NSNull class]])) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)getMd5_32Bit:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, str.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
//    base64_encode(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:result length:sizeof(result)];
    NSString *base64EncodedResult = [NSString stringWithUTF8String:[[theData base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed] bytes]];
    return base64EncodedResult;
}

+(NSString *)generateSignatureString:(NSDictionary *)parameters Method:(NSString *)method URI:(NSString *)uri Key:(NSString *)subKey
{
    NSMutableString *signatureString = nil;
    if (parameters) {
        NSArray *allKeys = [parameters allKeys];
        NSArray *sortKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        signatureString = [[NSMutableString alloc] initWithFormat:@"%@:%@:",method,uri];
        for (NSString *key in sortKeys) {
            NSString *paraString = nil;
            if ([key isEqualToString:[sortKeys lastObject]]) {
                paraString = [NSString stringWithFormat:@"%@=%@:",key,[parameters objectForKey:key]];
            }else{
                paraString = [NSString stringWithFormat:@"%@=%@&",key,[parameters objectForKey:key]];
            }
            [signatureString appendString:paraString];
        }
        
        [signatureString appendString:subKey];
    }
    return signatureString;
}

+(NSString*) sha1:(NSString *)text
{
    const char *cstr = [text cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:text.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
