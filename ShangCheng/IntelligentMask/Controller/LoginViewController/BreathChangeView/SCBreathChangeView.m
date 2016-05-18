//
//  SCBreathChangeView.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCBreathChangeView.h"
#import "SCBreathView.h"
#import "SCTextChangeView.h"

#define BreathViewWidth (UIScreenMainFrame.size.width - 170.0f)
#define BreathViewHeight (UIScreenMainFrame.size.width - 170.0f)

@implementation SCBreathChangeView
-(void)inilizeViewWithFont:(UIFont *)font
{
    [self setBackgroundColor:[UIColor clearColor]];
    breathView = [[SCBreathView alloc] initWithFrame:CGRectMake(0, 0, BreathViewWidth, BreathViewHeight)];
    [breathView setLineWidth:4.0f];
    [breathView setIntervalWidth:1.0f];
    [breathView generateView];
    [self addSubview:breathView];
    
    float insideRadius = [breathView returnInsideCircleRadius];
    textChangeView = [[SCTextChangeView alloc] initWithFrame:CGRectMake(0, 0, insideRadius * 2, insideRadius * 2)];
    [textChangeView setCenter:CGPointMake(BreathViewWidth / 2, BreathViewHeight/2)];
    [textChangeView setBackgroundColor:[UIColor colorWithRed:0.494 green:0.827 blue:0.129 alpha:1.000]];
    [textChangeView.layer setCornerRadius:insideRadius];
    [textChangeView.layer setMasksToBounds:YES];
    [textChangeView inilizeViewWithFont:font];
    [self insertSubview:textChangeView aboveSubview:breathView];
}

-(void)startAnimate
{
    if (breathView) {
        [breathView beginAnimate];
    }
    
    if (textChangeView) {
        [textChangeView startChangeColor];
    }
}

-(void)stopAnimate
{
    if (breathView) {
        [breathView stopAnimate];
    }
    
    if (textChangeView) {
        [textChangeView stopChangeColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
