//
//  PHGuidViewPanel.m
//  PocketHealth
//
//  Created by macmini on 15-2-9.
//  Copyright (c) 2015年 YiLiao. All rights reserved.
//

#import "PHGuidViewPanel.h"
#define SkipButtonWidth 170.f
#define SkipButtonHeight 40.f
#define SkipButtonBottomMargin 30.f

@implementation PHGuidViewPanel
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageview];
        btnSkip = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width - SkipButtonWidth)/2, frame.size.height - SkipButtonBottomMargin - SkipButtonHeight, SkipButtonWidth, SkipButtonHeight)];
        [btnSkip setBackgroundImage:[UIImage imageNamed:@"GuidButtonSkip.png"] forState:UIControlStateNormal];
        [btnSkip.layer setCornerRadius:5.f];
        [btnSkip.layer setMasksToBounds:YES];
        [btnSkip addTarget:self action:@selector(clickSkipButton) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"立即体验" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Palatino" size:18.0f],NSForegroundColorAttributeName:[UIColor colorWithRed:1.0f green:0.4f blue:0.0f alpha:1.0f]}];
        [btnSkip setAttributedTitle:attStr forState:UIControlStateNormal];
        [self addSubview:btnSkip];
    }
    return self;
}

-(void)clickSkipButton
{
    if ([self.delegate respondsToSelector:@selector(clickSkipBtn)]) {
        [self.delegate clickSkipBtn];
    }
}

-(void)setImage:(UIImage *)image ShowSkipButton:(BOOL)show
{
    [imageview setImage:image];
    [btnSkip setHidden:!show];
}
@end
