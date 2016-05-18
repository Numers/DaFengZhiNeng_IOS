//
//  ZMDripView.m
//  WaterDropDemo
//
//  Created by 钱长存 on 9/7/15.
//  Copyright (c) 2015 com.zmodo. All rights reserved.
//

#import "ZMDripView.h"
#define DefaultFillColor  [UIColor colorWithRed:0.882 green:0.498 blue:0.562 alpha:0.700]
@interface ZMDripView ()

@end


@implementation ZMDripView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _fillColor = DefaultFillColor;
    }
    
    return self;
}

-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, self.bounds.size.width * 0.5f, self.bounds.size.height);
    
    
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(context, 1.0);
    
    CGContextAddCurveToPoint(context,
                             0,
                             0,
                             self.bounds.size.width,
                             0,
                             self.bounds.size.width * 0.5f,
                             self.bounds.size.height);
    
    CGContextSetFillColorWithColor(context,_fillColor.CGColor);
    CGContextFillPath(context);
    
    CGContextStrokePath(context);
    
}
@end
