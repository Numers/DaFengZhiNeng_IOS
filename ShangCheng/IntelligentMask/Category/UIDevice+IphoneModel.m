//
//  UIDevice+IphoneModel.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/23.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "UIDevice+IphoneModel.h"

@implementation UIDevice (IphoneModel)
+(iPhoneModel)iPhonesModel
{
    //bounds method gets the points not the pixels!!!
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    //get current interface Orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //unknown
    if (UIInterfaceOrientationUnknown == orientation) {
         return UnKnown;
    }
    
    //    portrait   width * height
    //    iPhone4:320*480
    //    iPhone5:320*568
    //    iPhone6:375*667
    //    iPhone6Plus:414*736
    //portrait
    if (UIInterfaceOrientationPortrait == orientation) {
        if (width ==  320.0f) {
            if (height == 480.0f) {
                return iPhone4;
            } else {
                return iPhone5;
            }
        } else if (width == 375.0f) {
            return iPhone6;
        } else if (width == 414.0f) {
            return iPhone6Plus;
        }
    } else if (UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation) {//landscape
        if (height == 320.0) {
            if (width == 480.0f) {
                return iPhone4;
            } else {
               return iPhone5;
            }
        } else if (height == 375.0f) {
            return iPhone6;
        } else if (height == 414.0f) {
            return iPhone6Plus;
        }
    }
    return UnKnown;
}

+(CGFloat)adaptTextFontSizeWithIphone5FontSize:(CGFloat)size
{
    CGFloat returnSize = size;
    iPhoneModel model = [self iPhonesModel];
    switch (model) {
        case iPhone4:
        {
            
        }
            break;
        case iPhone5:
        {
            
        }
            break;
        case iPhone6:
        {
            
        }
            break;
        case iPhone6Plus:
        {
            returnSize = size * 1.5;
        }
            break;
        default:
        {
            
        }
            break;
    }
    return returnSize;
}

+(void)adaptUILabelTextFont:(UILabel *)label WithIphone5FontSize:(CGFloat)size
{
    iPhoneModel model = [self iPhonesModel];
    switch (model) {
        case iPhone4:
        {
            [label setFont:[UIFont systemFontOfSize:size]];
        }
        break;
        case iPhone5:
        {
            [label setFont:[UIFont systemFontOfSize:size]];
        }
        break;
        case iPhone6:
        {
            [label setFont:[UIFont systemFontOfSize:size]];
        }
        break;
        case iPhone6Plus:
        {
            [label setFont:[UIFont systemFontOfSize:size*1.5]];
        }
        break;
        default:
        {
            [label setFont:[UIFont systemFontOfSize:size]];
        }
        break;
    }
}

+(void)adaptUITextFieldTextFont:(UITextField *)textField WithIphone5FontSize:(CGFloat)size
{
    iPhoneModel model = [self iPhonesModel];
    switch (model) {
        case iPhone4:
        {
            [textField setFont:[UIFont systemFontOfSize:size]];
        }
        break;
        case iPhone5:
        {
            [textField setFont:[UIFont systemFontOfSize:size]];
        }
        break;
        case iPhone6:
        {
            [textField setFont:[UIFont systemFontOfSize:size]];
        }
        break;
        case iPhone6Plus:
        {
            [textField setFont:[UIFont systemFontOfSize:size*1.5]];
        }
        break;
        default:
        {
            [textField setFont:[UIFont systemFontOfSize:size]];
        }
        break;
    }

}

+(void)adaptUIBarButtonItemTextFont:(UIBarButtonItem *)item WithIphone5FontSize:(CGFloat)size
{
    iPhoneModel model = [self iPhonesModel];
    switch (model) {
        case iPhone4:
        {
            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateNormal];
        }
        break;
        case iPhone5:
        {
            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateNormal];
        }
        break;
        case iPhone6:
        {
            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateNormal];
        }
        break;
        case iPhone6Plus:
        {
            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size * 1.2]} forState:UIControlStateNormal];
        }
        break;
        default:
        {
            [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateNormal];
        }
        break;
    }
}
@end
