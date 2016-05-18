//
//  SocketProtocol.h
//  IntelligentMask
//
//  Created by baolicheng on 16/4/28.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketProtocol : NSObject
+(NSString *)commandSubcribeMessageQueue:(NSString *)macAddr;
+(NSString *)commandSendMessageToQueue:(NSString *)macAddr Status:(BOOL)isOn;
+(NSString *)commandGetMessageFromQueue:(NSString *)macAddr Message:(NSString *)message;
+(NSString *)commandExitQueue:(NSString *)macAddr;
@end
