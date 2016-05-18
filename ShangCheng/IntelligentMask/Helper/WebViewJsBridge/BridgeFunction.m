//
//  BridgeFunction.m
//  GuoZhongBao
//
//  Created by baolicheng on 15/7/2.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import "BridgeFunction.h"

@implementation BridgeFunction
-(void)shareSDK:(NSArray *)parameters
{
    if ([self.delegate respondsToSelector:@selector(clickShareFromJs:)]) {
        [self.delegate clickShareFromJs:parameters];
    }
}
@end
