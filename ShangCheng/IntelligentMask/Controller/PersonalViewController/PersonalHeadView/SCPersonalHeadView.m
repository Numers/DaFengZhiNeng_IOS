//
//  SCPersonalHeadView.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/27.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCPersonalHeadView.h"
#import "SCHeadCircleView.h"
#define PhoneLabelToBottomMargin 20.0f
#define NameLabelToPhoneLabelMargin 20.0f
#define headImageViewToNameLabelMargin 65.0f
@implementation SCPersonalHeadView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.000 green:0.722 blue:0.933 alpha:1.000]];
        lblPhone = [[UILabel alloc] init];
        [lblPhone setFont:[UIFont systemFontOfSize:12.0f]];
        [lblPhone setText:@""];
        [lblPhone sizeToFit];
        [lblPhone setTextColor:[UIColor whiteColor]];
        [lblPhone setCenter:CGPointMake(frame.size.width / 2, frame.size.height - PhoneLabelToBottomMargin)];
        [self addSubview:lblPhone];
        
        lblName = [[UILabel alloc] init];
        [lblName setFont:[UIFont systemFontOfSize:12.0f]];
        [lblName setText:@""];
        [lblName sizeToFit];
        [lblName setTextColor:[UIColor whiteColor]];
        [lblName setCenter:CGPointMake(frame.size.width / 2, lblPhone.center.y - NameLabelToPhoneLabelMargin)];
        [self addSubview:lblName];
        
        bigHeadCircleView = [[SCHeadCircleView alloc] initWithFrame:CGRectMake(0, 0, 83, 83)];
        [bigHeadCircleView setCenter:CGPointMake(frame.size.width / 2, lblName.center.y - headImageViewToNameLabelMargin)];
        [self addSubview:bigHeadCircleView];
        
        smallHeadCircleView = [[SCHeadCircleView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        [smallHeadCircleView setCenter:CGPointMake(frame.size.width / 2, lblName.center.y - headImageViewToNameLabelMargin)];
        [self insertSubview:smallHeadCircleView aboveSubview:bigHeadCircleView];
        
        btnLoginout = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        [btnLoginout setBackgroundColor:[UIColor colorWithRed:1.000 green:0.736 blue:0.000 alpha:1.000]];
        [btnLoginout setCenter:CGPointMake(frame.size.width - 45, frame.size.height - PhoneLabelToBottomMargin)];
        [btnLoginout.layer setCornerRadius:3.0f];
        [btnLoginout.layer setMasksToBounds:YES];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"退出登录" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0]}];;
        [btnLoginout setAttributedTitle:title forState:UIControlStateNormal];
        [btnLoginout addTarget:self action:@selector(clickLoginoutBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnLoginout];
    }
    return self;
}

-(void)startRotation
{
    if (bigHeadCircleView) {
        [bigHeadCircleView startRotationWithImage:[UIImage imageNamed:@"Personal_HeadOutsideCircle_Image"] WithDirection:YES];
    }
    
    if (smallHeadCircleView) {
        [smallHeadCircleView startRotationWithImage:[UIImage imageNamed:@"Personal_HeadInsideCircle_Image"] WithDirection:YES];
    }
}

-(void)clickLoginoutBtn
{
    if ([self.delegate respondsToSelector:@selector(loginout)]) {
        [self.delegate loginout];
    }
}

-(void)setName:(NSString *)name WithPhone:(NSString *)phone
{
    if (lblName) {
        [lblName setText:name];
        [lblName sizeToFit];
    }
    
    if (lblPhone) {
        [lblPhone setText:phone];
        [lblPhone sizeToFit];
    }
    
    [self startRotation];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [lblPhone setCenter:CGPointMake(rect.size.width / 2, rect.size.height - PhoneLabelToBottomMargin)];
    [lblName setCenter:CGPointMake(rect.size.width / 2, lblPhone.center.y - NameLabelToPhoneLabelMargin)];
    [bigHeadCircleView setCenter:CGPointMake(rect.size.width / 2, lblName.center.y - headImageViewToNameLabelMargin)];
    [smallHeadCircleView setCenter:CGPointMake(rect.size.width / 2, lblName.center.y - headImageViewToNameLabelMargin)];
    [btnLoginout setCenter:CGPointMake(rect.size.width - 45, rect.size.height - PhoneLabelToBottomMargin)];
}


@end
