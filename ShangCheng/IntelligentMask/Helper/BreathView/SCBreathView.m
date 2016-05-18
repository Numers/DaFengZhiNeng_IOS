//
//  SCBreathView.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/21.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCBreathView.h"
#import "CircleShapeLayer.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define LineWidth 8.0f
#define StrokeColorRed 1.0f
#define StrokeColorGreen 1.0f
#define StrokeColorBlue 1.0f
#define IntervalWidth 4.0f
#define LineCount 5
#define AlphaDesc 0.19f

#define AnimateDelayTimeLessThanCount 0.3f
#define AnimateDelayTimeGreatThanCount 0.5f

@implementation SCBreathView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _lineWidth = LineWidth;
        _strokeColorRed = StrokeColorRed;
        _strokeColorGreen = StrokeColorGreen;
        _strokeColorBlue = StrokeColorBlue;
        _intervalWidth = IntervalWidth;
        _lineCount = LineCount;
        _alphaDesc = AlphaDesc;
        
        isStartAnimate = YES;
        indexCount = 1;
    }
    return self;
}

-(void)setLineWidth:(float)lineWidth
{
    _lineWidth = lineWidth;
}

-(void)setStrokeColor:(float)red green:(float)green blue:(float)blue
{
    _strokeColorRed = red;
    _strokeColorGreen = green;
    _strokeColorBlue = blue;
}

-(void)setIntervalWidth:(float)intervalWidth
{
    _intervalWidth = intervalWidth;
}

-(void)setLineCount:(NSInteger)count WithAlphaDesc:(float)alphaDesc
{
    _lineCount = count;
    _alphaDesc = alphaDesc;
}

-(float)returnInsideCircleRadius
{
    float viewRadius = MIN(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    float radius = viewRadius - _lineCount*_lineWidth - (_lineCount - 1)*_intervalWidth - 1;
    return radius;
}

-(void)addWhiteBoundLine
{
    float viewRadius = MIN(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2) radius:(viewRadius - _lineCount*_lineWidth - (_lineCount - 1)*_intervalWidth - 0.5) startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    
    CircleShapeLayer *circleLayer  = [CircleShapeLayer layer];
    circleLayer.path        = circlePath.CGPath;
    circleLayer.lineWidth   = 1.0f;
    circleLayer.strokeColor = [[UIColor colorWithWhite:1.0f alpha:0.7f] CGColor];
    circleLayer.lineCap     = kCALineCapRound;
    circleLayer.fillColor   = [UIColor clearColor].CGColor;
    circleLayer.zPosition   = -1;
    circleLayer.tag = 0;
    
    [self.layer addSublayer:circleLayer];
}

-(void)generateView
{
    [self addWhiteBoundLine];
    float lineAlpha = 25.0f;
    float viewRadius = MIN(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    float tempStartPoint = viewRadius - _lineCount*_lineWidth - (_lineCount - 1)*_intervalWidth - _lineWidth/2 - _intervalWidth;
    for(int i = 1; i <= _lineCount; i++){
        float tempRadius = tempStartPoint + (_lineWidth + _intervalWidth) * i;
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2) radius:tempRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
        
        CircleShapeLayer *circleLayer  = [CircleShapeLayer layer];
        circleLayer.path        = circlePath.CGPath;
        circleLayer.lineWidth   = _lineWidth;
        
        /***************自定义策略*******************/
        if (i < (_lineCount-1)) {
            _alphaDesc = 5.0f;
        }else if(i == _lineCount - 1){
            _alphaDesc = 4.0f;
        }else if (i == _lineCount){
            _alphaDesc = 3.0f;
        }
        lineAlpha = lineAlpha - _alphaDesc;
        /******************************************/
        circleLayer.strokeColor = [[UIColor colorWithRed:_strokeColorRed green:_strokeColorGreen blue:_strokeColorBlue alpha:lineAlpha / 100.0f] CGColor];
        circleLayer.lineCap     = kCALineCapRound;
        circleLayer.fillColor   = [UIColor clearColor].CGColor;
        circleLayer.zPosition   = -1;
        circleLayer.tag = i;
        
        [self.layer addSublayer:circleLayer];
    }
}

-(BOOL)isAnimateing
{
    return isStartAnimate;
}

-(void)beginAnimate
{
    isStartAnimate = YES;
    indexCount = 1;
    [self setNeedsDisplay];
}

-(void)timerStartUp
{
    if (indexCount < _lineCount) {
        if (greatThanCountTimer) {
            if ([greatThanCountTimer isValid]) {
                [greatThanCountTimer invalidate];
                greatThanCountTimer = nil;
            }
        }
        
        if (lessThanCountTimer) {
            if ([lessThanCountTimer isValid]) {
                [lessThanCountTimer invalidate];
                lessThanCountTimer = nil;
            }
        }
     
        lessThanCountTimer = [NSTimer scheduledTimerWithTimeInterval:AnimateDelayTimeLessThanCount target:self selector:@selector(loopAnimate) userInfo:nil repeats:YES];
    }else{
        if (lessThanCountTimer) {
            if ([lessThanCountTimer isValid]) {
                [lessThanCountTimer invalidate];
                lessThanCountTimer = nil;
            }
        }
        if (greatThanCountTimer) {
            if ([greatThanCountTimer isValid]) {
                [greatThanCountTimer invalidate];
                greatThanCountTimer = nil;
            }
        }
        greatThanCountTimer = [NSTimer scheduledTimerWithTimeInterval:AnimateDelayTimeGreatThanCount target:self selector:@selector(loopAnimate) userInfo:nil repeats:YES];
    }
}

-(void)loopAnimate
{
    indexCount ++;
    if (indexCount > (2*_lineCount + 1)) {
        indexCount = 1;
    }
    [self setNeedsDisplay];
}

-(void)stopAnimate
{
    if (lessThanCountTimer) {
        if ([lessThanCountTimer isValid]) {
            [lessThanCountTimer invalidate];
            lessThanCountTimer = nil;
        }
    }
    if (greatThanCountTimer) {
        if ([greatThanCountTimer isValid]) {
            [greatThanCountTimer invalidate];
            greatThanCountTimer = nil;
        }
    }

    isStartAnimate = NO;
    indexCount = 2 * _lineCount;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (indexCount <= _lineCount) {
        for (CircleShapeLayer *circleLayer in self.layer.sublayers) {
            if (circleLayer.tag <= indexCount) {
                [circleLayer setHidden:NO];
            }else{
                [circleLayer setHidden:YES];
            }
        }
    }else{
        for (CircleShapeLayer *circleLayer in self.layer.sublayers) {
            if (circleLayer.tag == 0) {
                [circleLayer setHidden:NO];
            }else{
                if ((circleLayer.tag + indexCount) >= (2 * _lineCount + 1)) {
                    [circleLayer setHidden:NO];
                }else{
                    [circleLayer setHidden:YES];
                }
            }
        }
    }
    
    if (indexCount == 1 || indexCount == _lineCount) {
        [self timerStartUp];
    }
}
@end
