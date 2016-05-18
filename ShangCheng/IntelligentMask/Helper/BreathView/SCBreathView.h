//
//  SCBreathView.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/21.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCBreathView : UIView
{
    float _lineWidth;
    float _strokeColorRed;
    float _strokeColorGreen;
    float _strokeColorBlue;
    float _intervalWidth;
    
    NSInteger _lineCount;
    float _alphaDesc;
    
    NSTimer *lessThanCountTimer;
    NSTimer *greatThanCountTimer;
    
    BOOL isStartAnimate;
    NSInteger indexCount;
}
-(void)setLineWidth:(float)lineWidth;
-(void)setStrokeColor:(float)red green:(float)green blue:(float)blue;
-(void)setIntervalWidth:(float)intervalWidth;
-(void)setLineCount:(NSInteger)count WithAlphaDesc:(float)alphaDesc;
-(void)generateView;
-(BOOL)isAnimateing;
-(void)beginAnimate;
-(void)stopAnimate;

-(float)returnInsideCircleRadius;
@end
