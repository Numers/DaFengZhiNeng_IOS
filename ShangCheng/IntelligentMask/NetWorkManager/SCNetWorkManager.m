//
//  SCNetWorkManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/4/5.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCNetWorkManager.h"
static AFHTTPRequestOperationManager *requestManager;
static SCNetWorkManager *scNetWorkManager;
@implementation SCNetWorkManager
+(id)defaultManager
{
    if (scNetWorkManager == nil) {
        scNetWorkManager = [[SCNetWorkManager alloc] init];
        requestManager = [AFHTTPRequestOperationManager manager];
        [requestManager.requestSerializer setTimeoutInterval:TimeOut];
    }
    return scNetWorkManager;
}

-(void)post:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)errors failed:(ApiFailedCallback)failed isNotify:(BOOL)isNotify
{
    NSMutableDictionary *para = nil;
    if (parameters) {
        para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",nowTime];
    [para setObject:timeStamp forKey:@"timestamp"];
    NSString *signatureString = [AppUtils generateSignatureString:parameters Method:@"POST" URI:SC_Feedback_API Key:SignatureAPPKey];
    NSString *signature = [AppUtils sha1:signatureString];
    [para setObject:signature forKey:@"sign"];
    
    [requestManager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *responseObject = operation.responseObject;
        
        if (isNotify) {
            if (responseObject == nil) {
                [AppUtils showInfo:NetWorkConnectFailedDescription];
                failed(operation, error);
            }else{
                [AppUtils showInfo:[responseObject objectForKey:@"msg"]];
                errors(operation, error);
            }
        }
    }];
}

-(void)get:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)errors failed:(ApiFailedCallback)failed isNotify:(BOOL)isNotify
{
    NSMutableDictionary *para = nil;
    if (parameters) {
        para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",nowTime];
    [para setObject:timeStamp forKey:@"timestamp"];
    NSString *signatureString = [AppUtils generateSignatureString:parameters Method:@"POST" URI:SC_Feedback_API Key:SignatureAPPKey];
    NSString *signature = [AppUtils sha1:signatureString];
    [para setObject:signature forKey:@"sign"];
    
    [requestManager GET:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *responseObject = operation.responseObject;
        
        if (isNotify) {
            if (responseObject == nil) {
                [AppUtils showInfo:NetWorkConnectFailedDescription];
                failed(operation, error);
            }else{
                [AppUtils showInfo:[responseObject objectForKey:@"msg"]];
                errors(operation, error);
            }
        }
        
    }];
}
@end
