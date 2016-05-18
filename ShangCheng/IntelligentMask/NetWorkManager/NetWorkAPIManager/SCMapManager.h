//
//  SCMapManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@class Member,Location;
@interface SCMapManager : NSObject
+(id)defaultManager;

-(void)requestRegionPMData:(Member *)member WithLocation:(Location *)location Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
