//
//  SCHeadCircleView.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCHeadCircleView.h"
#define AnimateDuration 1.5f
@implementation SCHeadCircleView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:circleImageView];
    }
    return self;
}

-(void)startRotationWithImage:(UIImage *)image WithDirection:(BOOL)isPositive
{
    direction = isPositive;
    if (circleImageView) {
        [circleImageView setImage:image];
        [circleImageView sizeToFit];
        [self startRotation];
    }
}

-(void)startRotation
{
    if (circleImageView) {
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        if (direction) {
            //顺时针循转
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        }else{
            //逆时针循转
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * -1];
        }
        rotationAnimation.duration = AnimateDuration; //循转一次的时间长度
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 100.f; //循转次数
        rotationAnimation.delegate = self;
        [circleImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self startRotation];
}
@end
