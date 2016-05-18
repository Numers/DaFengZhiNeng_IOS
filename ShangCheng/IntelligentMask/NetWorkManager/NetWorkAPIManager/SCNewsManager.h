//
//  SCNewsManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@class Member;
@interface SCNewsManager : NSObject
+(id)defaultManager;
-(void)requestNewsListWithPage:(NSInteger)page WithMember:(Member *)member Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
