//
//  SCFeedbackManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/4/5.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCFeedbackManager.h"
static SCFeedbackManager *scFeedbackManager;
@implementation SCFeedbackManager
+(id)defaultManager
{
    if (scFeedbackManager == nil) {
        scFeedbackManager = [[SCFeedbackManager alloc] init];
    }
    return scFeedbackManager;
}

-(void)submitFeedback:(NSString *)mid WithFeedbackContent:(NSString *)content Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:mid,@"mid",content,@"feedback", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,SC_Feedback_API];
    [[SCNetWorkManager defaultManager] post:url parameters:parameters success:success error:error failed:failed isNotify:YES];
}
@end
