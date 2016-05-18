//
//  SCNewsManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCNewsManager.h"
#import "Member.h"
static SCNewsManager *scNewsManager;
@implementation SCNewsManager
+(id)defaultManager
{
    if (scNewsManager == nil) {
        scNewsManager = [[SCNewsManager alloc] init];
    }
    return scNewsManager;
}

-(void)requestNewsListWithPage:(NSInteger)page WithMember:(Member *)member Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:page],@"page",member.token,@"token",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_News_API];
    [[RFNetWorkManager defaultManager] get:url parameters:parameters success:success error:error failed:failed];
}
@end
