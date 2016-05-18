//
//  RFGeneralManager.m
//  renrenfenqi
//
//  Created by baolicheng on 15/7/7.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import "RFGeneralManager.h"
#import "RFNetWorkHelper.h"
#import "ZXAppStartManager.h"
#import "AppDelegate.h"
static AFHTTPRequestOperationManager *requestManager;
static RFGeneralManager *rfGeneralManager;
@implementation RFGeneralManager
+(id)defaultManager
{
    if (rfGeneralManager == nil) {
        rfGeneralManager = [[RFGeneralManager alloc] init];
        requestManager = [AFHTTPRequestOperationManager manager];
        [requestManager.requestSerializer setTimeoutInterval:TimeOut];
    }
    return rfGeneralManager;
}

-(void)sendClientIdSuccess:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
//    Member *host = [[ZXAppStartManager defaultManager] currentHost];
//    if (!host) {
//        return;
//    }
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (appDelegate.registerID == nil) {
//        return;
//    }
//    NSString *URL = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_Push_API];
//    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:appDelegate.registerID,@"tag",@"ios",@"platform",host.memberId,@"uid", nil];
//    [requestManager POST:URL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *resultDic = (NSDictionary *)responseObject;
//        if (resultDic) {
//            NSInteger code = [[resultDic objectForKey:@"status"] integerValue];
//            if (code == 200) {
//                success(operation, responseObject);
//            }else{
//                error(operation, responseObject);
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failed(operation, error);
//    }];
}

-(void)getConfigInfoSuccess:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (!host) {
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@",API_BASE,SC_Config_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:host.token,@"token", nil];
    [requestManager GET:URL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if (resultDic) {
            NSInteger code = [[resultDic objectForKey:@"code"] integerValue];
            if (code == 200) {
                success(operation, responseObject);
            }else{
                error(operation, responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(operation, error);
    }];

}

-(void)getGlovalVarWithVersion
{
    if (ISTEST) {
        [AppUtils setUrlWithState:NO];
        return;
    }
    [AppUtils setUrlWithState:NO];
//    NSNumber *isProductNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppIsProduct"];
//    if (isProductNum && [isProductNum integerValue] == 1) {
//        [AppUtils setUrlWithState:YES];
//        return;
//    }
//    NSString *appVersion = [AppUtils appVersion];
//    NSString *url = [NSString stringWithFormat:@"https://secure.renrenfenqi.com/pay/isProduction?version=%@",appVersion];
//    
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    [requestSerializer setTimeoutInterval:TimeOut];
//    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
//    
//    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [requestOperation setResponseSerializer:responseSerializer];
//    [requestOperation start];
//    [requestOperation waitUntilFinished];
//    NSDictionary *resultDic = (NSDictionary *)[requestOperation responseObject];
//    if (resultDic) {
//        NSInteger status = [[resultDic objectForKey:@"status"] integerValue];
//        if (status == 200) {
//            NSDictionary *dataDic = [resultDic objectForKey:@"data"];
//            if (dataDic) {
//                NSInteger isproduction = [[dataDic objectForKey:@"isProduction"] integerValue];
//                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:isproduction] forKey:@"AppIsProduct"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                if (isproduction == 1) {
//                    [AppUtils setUrlWithState:YES];
//                    return;
//                }else{
//                    [AppUtils setUrlWithState:NO];
//                    return;
//                }
//            }
//        }
//    }
//    [AppUtils setUrlWithState:YES];
}
@end
