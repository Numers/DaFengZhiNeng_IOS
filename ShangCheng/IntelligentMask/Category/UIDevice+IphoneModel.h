//
//  UIDevice+IphoneModel.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/23.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(char, iPhoneModel){//0~3
    iPhone4,//320*480
    iPhone5,//320*568
    iPhone6,//375*667
    iPhone6Plus,//414*736
    UnKnown
};
@interface UIDevice (IphoneModel)
+(iPhoneModel)iPhonesModel;
+(CGFloat)adaptTextFontSizeWithIphone5FontSize:(CGFloat)size;
+(void)adaptUILabelTextFont:(UILabel *)label WithIphone5FontSize:(CGFloat)size;
+(void)adaptUITextFieldTextFont:(UITextField *)label WithIphone5FontSize:(CGFloat)size;
+(void)adaptUIBarButtonItemTextFont:(UIBarButtonItem *)item WithIphone5FontSize:(CGFloat)size;
@end
