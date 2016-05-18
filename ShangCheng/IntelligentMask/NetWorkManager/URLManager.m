//
//  URLManager.m
//  renrenfenqi
//
//  Created by baolicheng on 15/8/3.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import "URLManager.h"
static URLManager *manager;
@implementation URLManager
+(id)defaultManager
{
    if (manager == nil) {
        manager = [[URLManager alloc] init];
    }
    return manager;
}

-(NSString *)returnBaseUrl
{
    return BaseURL;
}

-(NSString *)returnShopBaseUrl
{
    return ShopBaseURL;
}

-(void)setUrlWithState:(BOOL)state
{
    if (state) {
        BaseURL = @"http://api.dafeng.renrenfenqi.com";
        ShopBaseURL = @"http://www.jikejie.net";
    }else{
        BaseURL = @"http://api.dafeng.renrenfenqi.com";
        ShopBaseURL = @"http://test.shop.guozhongbao.com";
    }
}
@end
