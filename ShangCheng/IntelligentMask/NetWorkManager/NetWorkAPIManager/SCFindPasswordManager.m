//
//  SCFindPasswordManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCFindPasswordManager.h"
static SCFindPasswordManager *scFindPasswordManager;
@implementation SCFindPasswordManager
+(id)defaultManager
{
    if (scFindPasswordManager == nil) {
        scFindPasswordManager = [[SCFindPasswordManager alloc] init];
    }
    return scFindPasswordManager;
}

-(void)requestFindPasswordVerificationCodeWithPhone:(NSString *)phone Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_FindPwdVerificationCode_API];
    [[RFNetWorkManager defaultManager] post:url parameters:parameters success:success error:error failed:failed];
}

-(void)submitPassword:(NSString *)phone WithPassword:(NSString *)password WithVerificationCode:(NSString *)code WithVerificationTime:(NSNumber *)time Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"mobile",password,@"passwd",code,@"verificationCode",time,@"verificationCodeTime", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_FindPwd_API];
    [[RFNetWorkManager defaultManager] post:url parameters:parameters success:success error:error failed:failed];
}
@end
