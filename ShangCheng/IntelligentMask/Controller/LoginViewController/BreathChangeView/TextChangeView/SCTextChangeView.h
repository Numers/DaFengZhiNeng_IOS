//
//  SCTextChangeView.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXLabel;
@interface SCTextChangeView : UIView
{
    FXLabel *label;
    NSTimer *timer;
}
-(void)inilizeViewWithFont:(UIFont *)font;
-(void)startChangeColor;
-(void)stopChangeColor;
@end
