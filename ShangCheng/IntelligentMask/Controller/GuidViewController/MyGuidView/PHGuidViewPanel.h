//
//  PHGuidViewPanel.h
//  PocketHealth
//
//  Created by macmini on 15-2-9.
//  Copyright (c) 2015年 YiLiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PHGuidViewPanelDelegate<NSObject>
-(void)clickSkipBtn;
@end
@interface PHGuidViewPanel : UIView
{
    UIImageView *imageview;
    UIButton *btnSkip;
}
@property(nonatomic, weak) id<PHGuidViewPanelDelegate> delegate;
-(void)setImage:(UIImage *)image ShowSkipButton:(BOOL)show;
@end
