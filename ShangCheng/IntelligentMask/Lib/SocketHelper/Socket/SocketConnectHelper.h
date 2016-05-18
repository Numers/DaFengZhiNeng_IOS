//
//  SocketConnectHelper.h
//  IntelligentMask
//
//  Created by baolicheng on 16/4/12.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketConnectHelper : NSObject
+(void)initService;
+(NSInteger)connect:(NSString *)ip port:(int)port;
+(NSInteger)sendData:(NSString *)data;
@end
