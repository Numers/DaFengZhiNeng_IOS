//
//  PHMyGuidView.m
//  PocketHealth
//
//  Created by macmini on 15-2-9.
//  Copyright (c) 2015年 YiLiao. All rights reserved.
//

#import "PHMyGuidView.h"
#define PageContrlWidth 148.f
#define PageContrlHeight 37.f
#define PageContrlBottomMargin 19.f

@implementation PHMyGuidView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        myScrollView = [[UIScrollView alloc] initWithFrame:frame];
        myScrollView.pagingEnabled = YES;
        myScrollView.userInteractionEnabled = YES;
        myScrollView.delegate = self;
        myScrollView.showsHorizontalScrollIndicator = NO;
        myScrollView.showsVerticalScrollIndicator = NO;
        myScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [self addSubview:myScrollView];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((frame.size.width - PageContrlWidth)/2, frame.size.height - PageContrlBottomMargin - PageContrlHeight, PageContrlWidth, PageContrlHeight)];
        [pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:0.000 alpha:0.200]];
//        [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:1.000 green:0.816 blue:0.231 alpha:1.000]];
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPage = 0;
        [self setPageControlStatus:0];
        [self addSubview:pageControl];
    }
    return self;
}

-(void)setPanelList:(NSArray *)panelList
{
    if ((panelList != nil)) {
        [myScrollView setContentSize:CGSizeMake(self.frame.size.width * panelList.count, self.frame.size.height)];
        pageControl.numberOfPages = panelList.count;
        [self scrollContentSetting:panelList];
        _panelList = [NSArray arrayWithArray:panelList];
    }
}

-(void)scrollContentSetting:(NSArray *)panelList
{
    NSInteger i = 0;
    for (id m in panelList) {
        if ([m isKindOfClass:[UIImage class]]) {
            PHGuidViewPanel *panel = [[PHGuidViewPanel alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
            panel.delegate = self;
            [myScrollView addSubview:panel];
            i ++ ;
            if (i == panelList.count) {
                [panel setImage:m ShowSkipButton:YES];
            }else{
                [panel setImage:m ShowSkipButton:NO];
            }
        }
    }
}

-(void)skipIntroduction:(id)sender{
    
    //removing animation: Ripple Effect
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 2.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];;
    animation.type = @"rippleEffect";
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animation forKey:@"animation"];
}

-(void)setPageControlStatus:(int)page
{
    if ((page + 1) == _panelList.count) {
        [pageControl setHidden:YES];
    }else{
        [pageControl setHidden:NO];
        if (page == 0) {
            [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:1.000 green:0.816 blue:0.231 alpha:1.000]];
        }
        
        if (page == 1) {
            [pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.259 green:0.749 blue:1.000 alpha:1.000]];
        }
    }
}

#pragma UIScrollViewDelegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self setPageControlStatus:page];
}

#pragma -mark PHGuidViewPanelDelegate
-(void)clickSkipBtn
{
    if ([self.delegate respondsToSelector:@selector(skipGuidView)]) {
        [self.delegate skipGuidView];
    }
}
@end
