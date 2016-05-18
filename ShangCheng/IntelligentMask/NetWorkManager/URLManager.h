//
//  URLManager.h
//  renrenfenqi
//
//  Created by baolicheng on 15/8/3.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface URLManager : NSObject
{
    NSString *BaseURL;
    NSString *ShopBaseURL;
}
+(id)defaultManager;
-(NSString *)returnBaseUrl;
-(NSString *)returnShopBaseUrl;
-(void)setUrlWithState:(BOOL)state;
@end
