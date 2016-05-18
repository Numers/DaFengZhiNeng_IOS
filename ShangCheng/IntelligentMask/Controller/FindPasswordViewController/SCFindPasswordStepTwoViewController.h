//
//  SCFindPasswordStepTwoViewController.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCFindPasswordStepTwoProtocol <NSObject>
-(void)submitSuccess;
@end
@interface SCFindPasswordStepTwoViewController : UIViewController
@property(nonatomic, assign) id<SCFindPasswordStepTwoProtocol> delegate;
-(void)startAnimate;
-(void)setPhone:(NSString *)phone WithVerificationCode:(NSString *)code WithVerificationTime:(NSNumber *)time;
@end
