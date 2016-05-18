//
//  SCPersonalHeadView.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/27.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCPersonalHeadViewProtocol <NSObject>
-(void)loginout;
@end
@class SCHeadCircleView;
@interface SCPersonalHeadView : UIView
{
    SCHeadCircleView *smallHeadCircleView;
    SCHeadCircleView *bigHeadCircleView;
    UILabel *lblName;
    UILabel *lblPhone;
    
    UIButton *btnLoginout;
}
@property(nonatomic, assign) id<SCPersonalHeadViewProtocol> delegate;
-(void)setName:(NSString *)name WithPhone:(NSString *)phone;
@end
