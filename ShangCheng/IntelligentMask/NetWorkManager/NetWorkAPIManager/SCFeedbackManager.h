//
//  SCFeedbackManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/4/5.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetWorkManager.h"
@interface SCFeedbackManager : NSObject
+(id)defaultManager;

-(void)submitFeedback:(NSString *)mid WithFeedbackContent:(NSString *)content Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
