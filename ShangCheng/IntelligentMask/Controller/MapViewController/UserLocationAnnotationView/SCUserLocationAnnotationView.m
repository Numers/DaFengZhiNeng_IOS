//
//  SCUserLocationAnnotationView.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/27.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCUserLocationAnnotationView.h"
#import "ZMDripView.h"
#import "SCEllipseView.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
@implementation SCUserLocationAnnotationView
-(void)inilizeView
{
    CGFloat dripViewWidth = 100.0f;
    CGFloat dripViewHeight = 54.0f;
    backgroundView = [[ZMDripView alloc] initWithFrame:CGRectMake((self.bounds.size.width - dripViewWidth) * 0.5f,-dripViewHeight,dripViewWidth,dripViewHeight)];
    [backgroundView setUserInteractionEnabled:NO];
    [self addSubview:backgroundView];
    
    lblPmValue = [[UILabel alloc] init];
    [lblPmValue setText:@""];
    [lblPmValue setTextColor:[UIColor whiteColor]];
    [lblPmValue setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
    [lblPmValue sizeToFit];
    [lblPmValue setCenter:CGPointMake(backgroundView.frame.size.width / 2, backgroundView.frame.size.height / 2)];
    [backgroundView addSubview:lblPmValue];
    
    CGFloat ellipseViewWidth = 40.0f;
    CGFloat ellipseViewHeight = 16.0f;
    ellipseView = [[SCEllipseView alloc] initWithFrame:CGRectMake((self.bounds.size.width - ellipseViewWidth) * 0.5f,backgroundView.frame.origin.y + backgroundView.frame.size.height - 8,ellipseViewWidth,ellipseViewHeight)];
    [ellipseView setUserInteractionEnabled:NO];
    [self insertSubview:ellipseView belowSubview:backgroundView];
}


-(void)setupAnnotationView:(NSString *)pmValue WithFillColor:(UIColor *)color;
{
    float pmV = [pmValue floatValue];
    if (pmV > 500.0f) {
        [lblPmValue setText:@"500+"];
    }else{
        [lblPmValue setText:pmValue];
    }
    [lblPmValue sizeToFit];
    [lblPmValue setCenter:CGPointMake(backgroundView.frame.size.width / 2, backgroundView.frame.size.height / 2)];
    [backgroundView setFillColor:color];
    [ellipseView setStrokeColor:color];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

}

@end
