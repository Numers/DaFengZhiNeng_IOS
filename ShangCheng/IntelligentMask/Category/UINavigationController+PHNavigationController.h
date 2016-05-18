//
//  UINavigationController+PHNavigationController.h
//  PocketHealth
//
//  Created by macmini on 15-1-24.
//  Copyright (c) 2015年 YiLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PHNavigationController)
-(void)setNavigationViewColor:(UIColor *)color;
-(void)setTitleTextColor:(UIColor *)color WithFont:(UIFont *)font;
-(void)setStatusBarStyle:(UIStatusBarStyle)style;
-(void)setTranslucentView;
@end
