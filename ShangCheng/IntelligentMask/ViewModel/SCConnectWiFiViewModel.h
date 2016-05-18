//
//  SCConnectWiFiViewModel.h
//  IntelligentMask
//
//  Created by baolicheng on 16/3/28.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCConnectWiFiViewModel : NSObject
- (id)fetchSSIDInfo;

-(NSString *)currentWifiSSID;
@end
