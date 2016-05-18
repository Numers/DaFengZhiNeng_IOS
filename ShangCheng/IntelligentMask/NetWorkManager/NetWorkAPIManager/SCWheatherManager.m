//
//  SCWheatherManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/20.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCWheatherManager.h"
#import "Location.h"
static SCWheatherManager *scWheatherManager;
@implementation SCWheatherManager
+(id)defaultManager
{
    if (scWheatherManager == nil) {
        scWheatherManager = [[SCWheatherManager alloc] init];
    }
    return scWheatherManager;
}

-(void)requestWheatherInfoWithLocation:(Location *)location Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:location.cityName,@"city",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_WheatherInfo_API];
    [[RFNetWorkManager defaultManager] get:url parameters:parameters success:success error:error failed:failed];
}
@end
