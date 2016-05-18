//
//  RFGeneralManager.h
//  renrenfenqi
//
//  Created by baolicheng on 15/7/7.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@interface RFGeneralManager : NSObject
+(id)defaultManager;

-(void)sendClientIdSuccess:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;

-(void)getConfigInfoSuccess:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;

-(void)getGlovalVarWithVersion;
@end
