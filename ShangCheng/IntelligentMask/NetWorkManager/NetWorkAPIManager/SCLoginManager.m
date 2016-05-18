//
//  SCLoginManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCLoginManager.h"
static SCLoginManager *scLoginManager;
@implementation SCLoginManager
+(id)defaultManager
{
    if (scLoginManager == nil) {
        scLoginManager = [[SCLoginManager alloc] init];
    }
    return scLoginManager;
}

-(void)loginWithMobile:(NSString *)phone WithPassword:(NSString *)password Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",password,@"passwd", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_Login_API];
    [[SCNetWorkManager defaultManager] post:url parameters:parameters success:success error:error failed:failed isNotify:YES];
}
@end
