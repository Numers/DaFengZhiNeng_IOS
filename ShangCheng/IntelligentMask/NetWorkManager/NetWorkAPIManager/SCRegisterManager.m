//
//  SCRegisterManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCRegisterManager.h"
static SCRegisterManager *scRegisterManager;
@implementation SCRegisterManager
+(id)defaultManager
{
    if (scRegisterManager == nil) {
        scRegisterManager = [[SCRegisterManager alloc] init];
    }
    return scRegisterManager;
}

-(void)registerWithMobile:(NSString *)phone WithPassword:(NSString *)password WithVerificationCode:(NSString *)code WithVerificationCodeTime:(NSNumber *)codeTime Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"mobile",password,@"passwd",code,@"verificationCode",codeTime,@"verificationCodeTime", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_Register_API];
    [[RFNetWorkManager defaultManager] post:url parameters:parameters success:success error:error failed:failed];
}

-(void)requestVerificationCodeWithPhone:(NSString *)phone Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_VerificationCode_API];
    [[RFNetWorkManager defaultManager] post:url parameters:parameters success:success error:error failed:failed];
}
@end
