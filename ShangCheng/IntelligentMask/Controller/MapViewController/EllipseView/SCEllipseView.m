//
//  SCEllipseView.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/27.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCEllipseView.h"
#define DefaultStrokeColor [UIColor colorWithRed:0.882 green:0.498 blue:0.562 alpha:0.700]
#define LineWidth 2.0f
@implementation SCEllipseView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _strokeColor = DefaultStrokeColor;
    }
    return self;
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect aRect= CGRectMake(LineWidth, LineWidth, self.bounds.size.width - 2 * LineWidth, self.bounds.size.height - 2 * LineWidth);
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
    CGContextSetLineWidth(context, LineWidth);
    CGContextAddEllipseInRect(context, aRect); //椭圆
    CGContextDrawPath(context, kCGPathStroke);
}
@end
