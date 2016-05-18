//
//  SCNetWorkManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/4/5.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkHelper.h"
#import "JSONKit.h"
@interface SCNetWorkManager : NSObject
+(id)defaultManager;

-(void)post:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)errors failed:(ApiFailedCallback)failed isNotify:(BOOL)isNotify;

-(void)get:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)errors failed:(ApiFailedCallback)failed isNotify:(BOOL)isNotify;
@end
