//
//  SCWheatherManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/20.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@class Location;
@interface SCWheatherManager : NSObject
+(id)defaultManager;

-(void)requestWheatherInfoWithLocation:(Location *)location Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
