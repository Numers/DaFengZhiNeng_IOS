//
//  SCAliyunSyncStatusManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/31.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCAliyunSyncStatusManager.h"
#import "RFNetWorkHelper.h"

static SCAliyunSyncStatusManager *scAliyunSyncStatusManager;
@implementation SCAliyunSyncStatusManager
+(id)defaultManager
{
    if (scAliyunSyncStatusManager == nil) {
        scAliyunSyncStatusManager = [[SCAliyunSyncStatusManager alloc] init];
    }
    return scAliyunSyncStatusManager;
}

-(void)requestStatus
{
    NSString *accessKey = @"U8TlKbyCjyk6cuqOykeN4Me0tTw9o9";
    NSString *accessKeyId = @"rmTPB7UOpK7TuVZl";
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale *en_Locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    [formatter setLocale:en_Locale];
    
    [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    NSString *dateStr = [NSString stringWithFormat:@"%@ GMT",[formatter stringFromDate:now]];
    
    NSString *content = @"<?xml version=\"1.0\" encoding=\"UTF-8\"  ?><Queue xmlns=\"http://mns.aliyuncs.com/doc/v1/\"><VisibilityTimeout>60</VisibilityTimeout><MaximumMessageSize>65536</MaximumMessageSize><MessageRetentionPeriod>1209600</MessageRetentionPeriod><LoggingEnabled>True</LoggingEnabled></Queue>";
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *contentMD5 = [AppUtils md5:content];
    
    
    NSString *authorization = nil;
    
//    NSString *str = [NSString stringWithFormat:@"PUT\n%@\ntext/xml\n%@\nx-mns-version:2015-06-06\n/queues/Mac-2016-03-31",contentMD5,dateStr];
    NSString *str = [NSString stringWithFormat:@"PUT\n%@\ntext/xml\n%@\nx-mns-version:2015-06-06\n/queues/Mac-2017-03-31",contentMD5,dateStr];
    NSString *signature = [AppUtils hmacsha1:str key:accessKey];
    authorization = [NSString stringWithFormat:@"MNS %@:%@",accessKeyId,signature];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://1224684992681579.mns.cn-hangzhou.aliyuncs.com/queues/Mac-2017-03-31"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TimeOut];
    request.HTTPMethod = @"PUT";
    [request setValue:@"1224684992681579.mns.cn-hangzhou.aliyuncs.com" forHTTPHeaderField:@"Host"];
    [request setValue:dateStr forHTTPHeaderField:@"Date"];
    [request setValue:@"2015-06-06" forHTTPHeaderField:@"x-mns-version"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setValue:contentMD5 forHTTPHeaderField:@"Content-MD5"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:[NSString stringWithFormat:@"%ld",(long)contentData.length] forHTTPHeaderField:@"Content-Length"];
    NSLog(@"%@",request.allHTTPHeaderFields);
    
    [request setHTTPBody:contentData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responseStr);
    }];
}
@end
