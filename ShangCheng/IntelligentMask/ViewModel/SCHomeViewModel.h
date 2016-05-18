//
//  SCHomeViewModel.h
//  IntelligentMask
//
//  Created by baolicheng on 16/3/17.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BluetoothMacManager.h"
#import "SCConfigHelper.h"
@interface SCHomeViewModel : NSObject
{
    RACDisposable *notifyConfigDisposable;
    RACDisposable *timeIntervalDisposable;
    RACDisposable *notifyBluetoothDataDisposable;
    RACDisposable *notifyBluetoothPowerOnDisposable;
    RACDisposable *notifyBluetoothPowerOffDisposable;
    RACDisposable *notifySocketDidConnectedDisposable;
    RACDisposable *notifySocketDidDisconnectedDisposable;
    RACDisposable *socketGetStatusTimeIntervalDisposable;
}
@property(nonatomic, strong) NSDictionary *airIndex;
-(void)startBluetoothManager;
-(void)removeAllSignal;

-(RACSignal *)storyPMValueSignal;
@end
