//
//  RFNetWorkManager.m
//  renrenfenqi
//
//  Created by baolicheng on 15/6/29.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import "RFNetWorkManager.h"
#import "ZXAppStartManager.h"
static AFHTTPRequestOperationManager *requestManager;
static RFNetWorkManager *rfNetWorkManager;
@implementation RFNetWorkManager
+(id)defaultManager
{
    if (rfNetWorkManager == nil) {
        rfNetWorkManager = [[RFNetWorkManager alloc] init];
        requestManager = [AFHTTPRequestOperationManager manager];
        [requestManager.requestSerializer setTimeoutInterval:TimeOut];
    }
    return rfNetWorkManager;
}
-(void)post:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed
{
    NSMutableDictionary *para = nil;
    if (parameters) {
        para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    [requestManager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonData = [operation.responseString objectFromJSONString];
        NSInteger status = [[jsonData objectForKey:@"code"] integerValue];
        if (status == 200) {
            success(operation,responseObject);
        }else if(status == 208){
            [AppUtils showInfo:[responseObject objectForKey:@"msg"]];
            error(operation,responseObject);
            [[ZXAppStartManager defaultManager] loginOut];
        }else{
            [AppUtils showInfo:[responseObject objectForKey:@"msg"]];
            error(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showInfo:NetWorkConnectFailedDescription];
        failed(operation, error);
    }];
   
}

-(void)postV3:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed
{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [requestManager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonData = [operation.responseString objectFromJSONString];
        NSInteger status = [[jsonData objectForKey:@"code"] integerValue];
        if (status == SUCCESSREQUEST) {
            success(operation,responseObject);
        }else{
            error(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(operation, error);
    }];
}


-(void)get:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed
{
    NSMutableDictionary *para = nil;
    if (parameters) {
        para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    [requestManager GET:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonData = [operation.responseString objectFromJSONString];
        NSInteger status = [[jsonData objectForKey:@"code"] integerValue];
        if (status == 200) {
            success(operation,responseObject);
        }else if(status == 208){
            [AppUtils showInfo:[responseObject objectForKey:@"msg"]];
            error(operation,responseObject);
            [[ZXAppStartManager defaultManager] loginOut];
        }else{
            [AppUtils showInfo:[responseObject objectForKey:@"msg"]];
            error(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showInfo:NetWorkConnectFailedDescription];
        failed(operation, error);
    }];

}

-(void)getV3:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed
{
    [requestManager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonData = [operation.responseString objectFromJSONString];
        NSInteger status = [[jsonData objectForKey:@"code"] integerValue];
        if (status == SUCCESSREQUEST) {
            success(operation,responseObject);
        }else{
            error(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(operation, error);
    }];
    
}
-(void)post:(NSString *)url imgData:(NSData*)imgData parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed
{
    NSMutableDictionary *para = nil;
    if (parameters) {
        para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }
    
    [requestManager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //name字段 对应网站上[upload.php中]处理文件的[字段"file"] 即约定的key值
        [formData appendPartWithFileData:imgData name:@"load" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary* jsonData = [operation.responseString objectFromJSONString];
                NSInteger status = [[jsonData objectForKey:@"code"] integerValue];
                if (status == 200) {
                    success(operation,responseObject);
                }else{
                    error(operation,responseObject);
                }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failed(operation, error);
    }];
}
@end
