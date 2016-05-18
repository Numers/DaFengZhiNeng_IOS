//
//  SCFindPasswordStepOneViewController.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCFindPasswordStepOneProtocol <NSObject>
-(void)goNextStep:(NSString *)phone WithVerificationCode:(NSString *)code WithVerificationTime:(NSNumber *)time;
@end
@interface SCFindPasswordStepOneViewController : UIViewController
@property(nonatomic, assign) id<SCFindPasswordStepOneProtocol> delegate;
-(void)startAnimate;
@end
