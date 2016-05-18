//
//  SCAnnotationView.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCAnnotationView.h"
#define BackgroundViewWidth 30.0f

@implementation SCAnnotationView
-(void)inilizeView
{
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BackgroundViewWidth, BackgroundViewWidth)];
    [backgroundView setUserInteractionEnabled:NO];
    [backgroundView setBackgroundColor:[UIColor redColor]];
    [backgroundView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [backgroundView.layer setCornerRadius:BackgroundViewWidth / 2];
    [backgroundView.layer setMasksToBounds:YES];
    [self addSubview:backgroundView];
    
    lblPmValue = [[UILabel alloc] init];
    [lblPmValue setText:@""];
    [lblPmValue setTextColor:[UIColor whiteColor]];
    [lblPmValue setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
    [lblPmValue sizeToFit];
    [lblPmValue setCenter:CGPointMake(backgroundView.frame.size.width / 2, backgroundView.frame.size.height / 2)];
    [backgroundView addSubview:lblPmValue];
    
}

-(void)setupAnnotationView:(NSString *)pmValue WithBackgroundColor:(UIColor *)color
{
    float pmV = [pmValue floatValue];
    if (pmV > 500.0f) {
        [lblPmValue setText:@"500+"];
    }else{
        [lblPmValue setText:pmValue];
    }
    [lblPmValue sizeToFit];
    [lblPmValue setCenter:CGPointMake(backgroundView.frame.size.width / 2, backgroundView.frame.size.height / 2)];
    [backgroundView setBackgroundColor:color];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
