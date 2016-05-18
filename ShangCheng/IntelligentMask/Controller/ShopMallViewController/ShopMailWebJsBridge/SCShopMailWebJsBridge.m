//
//  SCShopMailWebJsBridge.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCShopMailWebJsBridge.h"

@implementation SCShopMailWebJsBridge
-(void)backHome
{
    if ([self.delegate respondsToSelector:@selector(goBackHomePage)]) {
        [self.delegate goBackHomePage];
    }
}

-(void)myOrder
{
    if ([self.delegate respondsToSelector:@selector(goOrderPage)]) {
        [self.delegate goOrderPage];
    }
}

-(void)login
{
    if ([self.delegate respondsToSelector:@selector(goLoginPage)]) {
        [self.delegate goLoginPage];
    }
}

-(void)isalipay:(NSArray *)parameters
{
    if (parameters && parameters.count >= 2) {
        NSString *payUrl = [parameters objectAtIndex:0];
        NSString *callBackUrl = [parameters objectAtIndex:1];
        if ([self.delegate respondsToSelector:@selector(isAlipay:WithCallBackUrl:)]) {
            [self.delegate isAlipay:payUrl WithCallBackUrl:callBackUrl];
        }
    }
}
@end
