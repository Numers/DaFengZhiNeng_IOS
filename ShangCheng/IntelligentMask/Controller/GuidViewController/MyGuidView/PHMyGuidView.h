//
//  PHMyGuidView.h
//  PocketHealth
//
//  Created by macmini on 15-2-9.
//  Copyright (c) 2015年 YiLiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHGuidViewPanel.h"
@protocol PHMyGuidViewDelegate<NSObject>
-(void)skipGuidView;
@end
@interface PHMyGuidView : UIView<UIScrollViewDelegate,PHGuidViewPanelDelegate>
{
    UIScrollView *myScrollView;
    UIPageControl *pageControl;
}
@property(nonatomic,weak) id<PHMyGuidViewDelegate> delegate;
@property(nonatomic, strong) NSArray *panelList;
@end
