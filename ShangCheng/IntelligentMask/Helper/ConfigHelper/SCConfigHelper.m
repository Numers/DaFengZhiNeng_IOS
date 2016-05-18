//
//  SCConfigHelper.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCConfigHelper.h"
#import "RFGeneralManager.h"

#define DefaultPMReportDuration 600.0f
#define DefaultPMReadDuration 10.0f
static SCConfigHelper *scConfigHelper;
@implementation SCConfigHelper
+(id)defaultHelper
{
    if (scConfigHelper == nil) {
        scConfigHelper = [[SCConfigHelper alloc] init];
    }
    return scConfigHelper;
}

-(void)requestConfigInfo
{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
    isSuccess = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scheduleConfigInfo) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)scheduleConfigInfo
{
    if (!isSuccess) {
        pmReportDuration = DefaultPMReportDuration;
        pmReadDuration = DefaultPMReadDuration;
        [[RFGeneralManager defaultManager] getConfigInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if (resultDic) {
                NSArray *dataArr = [resultDic objectForKey:@"data"];
                for (NSDictionary *dic in dataArr) {
                    NSString *code = [dic objectForKey:@"code"];
                    if ([code isEqualToString:@"_APP_REPORT_INTERVAL"]) {
                        pmReportDuration = [[dic objectForKey:@"value"] floatValue];
                    }
                    
                    if ([code isEqualToString:@"_APP_READ_INTERVAL"]) {
                        pmReadDuration = [[dic objectForKey:@"value"] floatValue];
                    }
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ConfigReadCompletelyNotify object:nil];
            isSuccess = YES;
            
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        if (timer) {
            if ([timer isValid]) {
                [timer invalidate];
                timer = nil;
            }
        }
    }
}

-(float)returnPMReportDuration
{
    return pmReportDuration;
}

-(float)returnPMReadDuration
{
    return pmReadDuration;
}
@end
