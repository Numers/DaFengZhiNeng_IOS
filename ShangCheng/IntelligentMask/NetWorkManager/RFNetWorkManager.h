//
//  RFNetWorkManager.h
//  renrenfenqi
//
//  Created by baolicheng on 15/6/29.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkHelper.h"
#import "JSONKit.h"
@interface RFNetWorkManager : NSObject
+(id)defaultManager;
-(void)post:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed;
-(void)postV3:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed;
-(void)get:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed;
-(void)getV3:(NSString *)url parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed;
-(void)post:(NSString *)url imgData:(NSData*)imgData parameters:(id)parameters success:(ApiSuccessCallback)success error:(ApiErrorCallback)error failed:(ApiFailedCallback)failed;

@end
