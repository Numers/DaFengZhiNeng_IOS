//
//  SCUserLocationAnnotationView.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/27.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>
@class ZMDripView,SCEllipseView;
@interface SCUserLocationAnnotationView : BMKAnnotationView
{
    UILabel *lblPmValue;
    ZMDripView *backgroundView;
    SCEllipseView *ellipseView;
}
@property(nonatomic) CAShapeLayer *circleLayer;
-(void)inilizeView;
-(void)setupAnnotationView:(NSString *)pmValue WithFillColor:(UIColor *)color;
@end
