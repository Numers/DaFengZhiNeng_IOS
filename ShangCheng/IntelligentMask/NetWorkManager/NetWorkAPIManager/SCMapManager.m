//
//  SCMapManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCMapManager.h"
#import "Member.h"
#import "Location.h"

static SCMapManager *scMapManager;
@implementation SCMapManager
+(id)defaultManager
{
    if (scMapManager == nil) {
        scMapManager = [[SCMapManager alloc] init];
    }
    return scMapManager;
}

-(void)requestRegionPMData:(Member *)member WithLocation:(Location *)location Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:member.token,@"token",location.cityName,@"city_name",[NSNumber numberWithFloat:location.lat],@"latitude",[NSNumber numberWithFloat:location.lng],@"longitude", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_RegionPM_API];
    [[RFNetWorkManager defaultManager] post:url parameters:parameters success:success error:error failed:failed];
}
@end
