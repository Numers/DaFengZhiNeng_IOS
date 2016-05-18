//
//  SCLoginViewController.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCLoginViewProtocol <NSObject>
-(void)loginSuccess;
-(void)goRegisterView;
-(void)goFindPasswordView;
@end
@interface SCLoginViewController : UIViewController
@property(nonatomic, assign) id<SCLoginViewProtocol> delegate;
-(void)startAnimate;
@end
