//
//  SCHeadCircleView.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHeadCircleView : UIView
{
    UIImageView *circleImageView;
    BOOL direction;
}

-(void)startRotationWithImage:(UIImage *)image WithDirection:(BOOL)isPositive;
@end
