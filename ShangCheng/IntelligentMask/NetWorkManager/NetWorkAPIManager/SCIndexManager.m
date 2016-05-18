//
//  SCIndexManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCIndexManager.h"
#import "Member.h"
#import "Location.h"
static SCIndexManager *scIndexManager;
@implementation SCIndexManager
+(id)defaultManager
{
    if (scIndexManager == nil) {
        scIndexManager = [[SCIndexManager alloc] init];
    }
    return scIndexManager;
}

-(void)reportPMAndFormaldehydeWithMember:(Member *)member WithLocation:(Location *)location WithPMValue:(float)pmValue WithFormaldehyde:(float)formaldehyde Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:member.token,@"token",location.cityName,@"city_name",[NSNumber numberWithFloat:location.lat],@"latitude",[NSNumber numberWithFloat:location.lng],@"longitude",[NSNumber numberWithFloat:pmValue],@"val_data",[NSNumber numberWithFloat:formaldehyde],@"formaldehyde", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_ReportData_API];
    [[RFNetWorkManager defaultManager] post:url parameters:parameters success:success error:error failed:failed];
}
@end
