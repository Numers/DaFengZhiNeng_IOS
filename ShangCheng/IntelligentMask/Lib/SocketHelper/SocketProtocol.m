//
//  SocketProtocol.m
//  IntelligentMask
//
//  Created by baolicheng on 16/4/28.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SocketProtocol.h"

@implementation SocketProtocol
+(NSString *)commandSubcribeMessageQueue:(NSString *)macAddr
{
    NSString *command = [NSString stringWithFormat:@"init#%@",macAddr];
    return command;
}

+(NSString *)commandSendMessageToQueue:(NSString *)macAddr Status:(BOOL)isOn
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [formatter stringFromDate:now];
    
    NSString *status = isOn?@"on":@"off";
    NSString *command = [NSString stringWithFormat:@"set#%@#D=%@,S=%@",macAddr,dateStr,status];
    return command;
}

+(NSString *)commandGetMessageFromQueue:(NSString *)macAddr Message:(NSString *)message;
{
    NSString *command = [NSString stringWithFormat:@"get#%@#%@",macAddr,message];
    return command;
}

+(NSString *)commandExitQueue:(NSString *)macAddr
{
    NSString *command = [NSString stringWithFormat:@"exit#%@",macAddr];
    return command;
}
@end
