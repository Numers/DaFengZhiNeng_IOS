//
//  SCRegisterManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@interface SCRegisterManager : NSObject
+(id)defaultManager;

-(void)registerWithMobile:(NSString *)phone WithPassword:(NSString *)password WithVerificationCode:(NSString *)code WithVerificationCodeTime:(NSNumber *)codeTime Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;

-(void)requestVerificationCodeWithPhone:(NSString *)phone Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
