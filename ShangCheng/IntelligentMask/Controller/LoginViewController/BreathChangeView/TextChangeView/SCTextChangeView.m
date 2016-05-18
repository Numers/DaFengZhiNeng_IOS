//
//  SCTextChangeView.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCTextChangeView.h"
#import "FXLabel.h"
#define WhiteColor [UIColor whiteColor]
#define LittleLightBlue [UIColor colorWithRed:0.702 green:0.871 blue:0.957 alpha:1.000]
#define LightBlue [UIColor colorWithRed:0.000 green:0.455 blue:0.757 alpha:1.000]
#define DeepBlue [UIColor colorWithRed:0.008 green:0.408 blue:0.639 alpha:1.000]
static NSInteger count = 0;
@implementation SCTextChangeView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)inilizeViewWithFont:(UIFont *)font
{
    label = [[FXLabel alloc] init];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:font];
    [label setText:@"breathing"];
    [label sizeToFit];
    label.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    label.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    label.gradientColors = [NSArray arrayWithObjects:
                             [UIColor redColor],
                             [UIColor yellowColor],
                             [UIColor greenColor],
                             [UIColor cyanColor],
                             [UIColor blueColor],
                             [UIColor purpleColor],
                             [UIColor redColor],
                             nil];
    label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:label];
}

-(void)startChangeColor
{
    [self stopChangeColor];
    count = 0;
    // 利用定时器，快速的切换渐变颜色，就有文字颜色变化效果
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(textColorChange) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)stopChangeColor
{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
    }
}

// 随机颜色方法
-(UIColor *)randomColor{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

// 定时器触发方法
-(void)textColorChange {
    if (label) {
        if (count % 9 == 0) {
            label.gradientColors = @[LittleLightBlue,LightBlue,DeepBlue,LightBlue,LittleLightBlue,WhiteColor,WhiteColor,WhiteColor,WhiteColor];
        }else if(count % 9 == 1){
            label.gradientColors = @[WhiteColor,LittleLightBlue,LightBlue,DeepBlue,LightBlue,LittleLightBlue,WhiteColor,WhiteColor,WhiteColor];
        }else if (count % 9 == 2){
            label.gradientColors = @[WhiteColor,WhiteColor,LittleLightBlue,LightBlue,DeepBlue,LightBlue,LittleLightBlue,WhiteColor,WhiteColor];
        }else if (count % 9 == 3){
            label.gradientColors = @[WhiteColor,WhiteColor,WhiteColor,LittleLightBlue,LightBlue,DeepBlue,LightBlue,LittleLightBlue,WhiteColor];
        }else if (count % 9 == 4){
            label.gradientColors = @[WhiteColor,WhiteColor,WhiteColor,WhiteColor,LittleLightBlue,LightBlue,DeepBlue,LightBlue,LittleLightBlue];
        }else if (count % 9 == 5){
            label.gradientColors = @[LittleLightBlue,WhiteColor,WhiteColor,WhiteColor,WhiteColor,LittleLightBlue,LightBlue,DeepBlue,LightBlue];
        }else if (count % 9 == 6){
            label.gradientColors = @[LightBlue,LittleLightBlue,WhiteColor,WhiteColor,WhiteColor,WhiteColor,LittleLightBlue,LightBlue,DeepBlue];
        }else if (count % 9 == 7){
            label.gradientColors = @[DeepBlue,LightBlue,LittleLightBlue,WhiteColor,WhiteColor,WhiteColor,WhiteColor,LittleLightBlue,LightBlue];
        }else if (count % 9 == 8){
            label.gradientColors = @[LightBlue,DeepBlue,LightBlue,LittleLightBlue,WhiteColor,WhiteColor,WhiteColor,WhiteColor,LittleLightBlue];
        }
        count ++;
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
