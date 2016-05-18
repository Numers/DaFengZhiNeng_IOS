//
//  SCFindPasswordManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@interface SCFindPasswordManager : NSObject
+(id)defaultManager;

-(void)requestFindPasswordVerificationCodeWithPhone:(NSString *)phone Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;

-(void)submitPassword:(NSString *)phone WithPassword:(NSString *)password WithVerificationCode:(NSString *)code WithVerificationTime:(NSNumber *)time Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
