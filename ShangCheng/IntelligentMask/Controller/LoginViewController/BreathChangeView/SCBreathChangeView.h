//
//  SCBreathChangeView.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCBreathView,SCTextChangeView;
@interface SCBreathChangeView : UIView
{
    SCBreathView *breathView;
    SCTextChangeView *textChangeView;
}

-(void)inilizeViewWithFont:(UIFont *)font;
-(void)startAnimate;
-(void)stopAnimate;
@end
