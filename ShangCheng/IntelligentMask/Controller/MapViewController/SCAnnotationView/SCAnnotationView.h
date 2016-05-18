//
//  SCAnnotationView.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>

@interface SCAnnotationView : BMKAnnotationView
{
    UILabel *lblPmValue;
    UIView *backgroundView;
}

-(void)inilizeView;
-(void)setupAnnotationView:(NSString *)pmValue WithBackgroundColor:(UIColor *)color;
@end
