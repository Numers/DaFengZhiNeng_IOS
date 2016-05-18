//
//  SCConnectWiFiViewModel.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/28.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCConnectWiFiViewModel.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation SCConnectWiFiViewModel
- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"ifs:%@",ifs);
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        NSLog(@"dici：%@",[info  allKeys]);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
            
        }
    }
    return ssid;
}
@end
