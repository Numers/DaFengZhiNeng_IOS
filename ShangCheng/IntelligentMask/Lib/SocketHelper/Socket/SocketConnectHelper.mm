//
//  SocketConnectHelper.m
//  IntelligentMask
//
//  Created by baolicheng on 16/4/12.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SocketConnectHelper.h"
#import "SCSocketService.hpp"

void onReceiveMessage(void *data, int len)
{
    NSString *revStr = [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
    NSLog(@"received:%@",revStr);
}

@implementation SocketConnectHelper
+(void)initService
{
    FOnReceiveMessage *fOnReceiveMessage = onReceiveMessage;
    init(fOnReceiveMessage);
}

+(NSInteger)connect:(NSString *)ip port:(int)port
{
    return connect((char *)[ip UTF8String], port);
}

+(NSInteger)sendData:(NSString *)data
{
    return sendData((char *)[data UTF8String], data.length);
}
@end
