//
//  SCConfigHelper.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ConfigReadCompletelyNotify @"ConfigReadCompletelyNotify"
@interface SCConfigHelper : NSObject
{
    float pmReportDuration;
    float pmReadDuration;
    
    NSTimer *timer;
    BOOL isSuccess;
}
+(id)defaultHelper;

-(void)requestConfigInfo;

-(float)returnPMReportDuration;
-(float)returnPMReadDuration;
@end
