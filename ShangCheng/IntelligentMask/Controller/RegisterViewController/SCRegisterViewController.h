//
//  SCRegisterViewController.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/27.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCRegisterViewProtocol<NSObject>
-(void)goLoginView;
-(void)registerSuccess;
@end
@interface SCRegisterViewController : UIViewController
@property(nonatomic, assign) id<SCRegisterViewProtocol> delegate;
-(void)startAnimate;
@end
