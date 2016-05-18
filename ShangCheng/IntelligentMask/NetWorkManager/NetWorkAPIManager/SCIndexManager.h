//
//  SCIndexManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@class Member,Location;
@interface SCIndexManager : NSObject
+(id)defaultManager;

-(void)reportPMAndFormaldehydeWithMember:(Member *)member WithLocation:(Location *)location WithPMValue:(float)pmValue WithFormaldehyde:(float)formaldehyde Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
