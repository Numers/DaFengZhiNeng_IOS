//
//  SCHomeViewModel.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/17.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCHomeViewModel.h"
#import "SocketHelper.h"

@implementation SCHomeViewModel
-(void)startBluetoothManager
{
    [[BluetoothMacManager defaultManager] startBluetoothDevice];
    notifyBluetoothPowerOnDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kBluetoothPowerOnNotify object:nil] subscribeNext:^(id x) {
        [[BluetoothMacManager defaultManager] startScanBluetoothDevice:ConnectForSearch callBack:^(BOOL completely, CallbackType backType, id obj, ConnectType connectType) {
            if (completely) {
                if ([[BluetoothMacManager defaultManager] isConnected]) {
                    [[BluetoothMacManager defaultManager] writeCharacteristicWithCommand:RequestWheatherInfo];
                    [self disconnectService];
                }else{
                    [self connectService];
                }
            }else{
                if (connectType == ConnectForSearch && backType == CallbackTimeout) {
                    //判断是否有搜索到蓝牙信号，有就push到蓝牙选择页面
                    if ([obj isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)obj;
                        if (arr.count == 0) {
                            [AppUtils showInfo:@"您周边无任何大風智能设备"];
                        }else{
                            NSString *macAddress = [AppUtils localUserDefaultsForKey:KMY_DeviceMacAddress];
                            if (macAddress) {
                                id peripheral = [self searchPeripheralWithMacAdress:macAddress inArray:arr];
                                if (peripheral) {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [[BluetoothMacManager defaultManager] connectToPeripheral:peripheral callBack:^(BOOL completely, CallbackType backType, id obj, ConnectType connectType) {
                                            if (completely) {
                                                if ([[BluetoothMacManager defaultManager] isConnected]) {
                                                    [self beginRequestWheatherInfoTimer];
                                                    [self disconnectService];
                                                }else{
                                                    [self connectService];
                                                }
                                            }
                                        }];
                                    });
                                    
                                }
                            }
                        }
                    }
                }
            }
        }];
    }];
    notifyBluetoothPowerOffDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kBluetoothPowerOffNotify object:nil] subscribeNext:^(id x) {
        [self connectService];
        if (timeIntervalDisposable) {
            if (![timeIntervalDisposable isDisposed]) {
                [timeIntervalDisposable dispose];
            }
        }
    }];
        
    notifyBluetoothDataDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:BluetoothDeliveryDataNotify object:nil] subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSNotification class]]) {
            NSNotification *notify = (NSNotification *)x;
            NSData *data = notify.object;
            [self deliveryData:data];
        }
    }];
    
    notifySocketDidConnectedDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NotifySocketDidConnected object:nil] subscribeNext:^(id x) {
        [self beginRequestWheatherInfoFromSocket];
    }];
    
    notifySocketDidDisconnectedDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NotifySocketDidDisconnected object:nil] subscribeNext:^(id x) {
        if (notifySocketDidConnectedDisposable) {
            if (![notifySocketDidConnectedDisposable isDisposed]) {
                [notifySocketDidConnectedDisposable dispose];
            }
        }
    }];
}

-(void)beginRequestWheatherInfoTimer
{
    RACSignal *siganl = [RACSignal interval:3.0f onScheduler:[RACScheduler mainThreadScheduler]];
    timeIntervalDisposable = [siganl subscribeNext:^(id x) {
        if ([[BluetoothMacManager defaultManager] isConnected]) {
            [[BluetoothMacManager defaultManager] writeCharacteristicWithCommand:RequestWheatherInfo];
        }
    }];
    
    //    notifyConfigDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:ConfigReadCompletelyNotify object:nil] subscribeNext:^(id x) {
    //        RACSignal *siganl = [RACSignal interval:[[SCConfigHelper defaultHelper] returnPMReadDuration] onScheduler:[RACScheduler mainThreadScheduler]];
    //        timeIntervalDisposable = [siganl subscribeNext:^(id x) {
    //            if ([[BluetoothMacManager defaultManager] isConnected]) {
    //                [[BluetoothMacManager defaultManager] writeCharacteristicWithCommand:RequestWheatherInfo];
    //            }
    //        }];
    //    }];
}

-(void)beginRequestWheatherInfoFromSocket
{
    RACSignal *siganl = [RACSignal interval:3.0f onScheduler:[RACScheduler mainThreadScheduler]];
    socketGetStatusTimeIntervalDisposable = [siganl subscribeNext:^(id x) {
        if ([[SocketHelper defaultHelper] isConnected]) {
            [[SocketHelper defaultHelper] sendMessage:CommandGetMessage];
        }
    }];

}

-(void)connectService
{
    if (![[SocketHelper defaultHelper] isConnected]) {
        [[SocketHelper defaultHelper] connectToIP:@"192.168.5.18" WithPort:3088];
    }
}

-(void)disconnectService
{
    if ([[SocketHelper defaultHelper] isConnected]) {
        [[SocketHelper defaultHelper] disconnect];
    }
}

-(id)searchPeripheralWithMacAdress:(NSString *)address inArray:(NSArray *)array
{
    id peripheral = nil;
    if (array) {
        for (id dic in array) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSString *macAddress = [dic objectForKey:@"mac"];
                if ([macAddress isEqualToString:address]) {
                    peripheral = [dic objectForKey:@"peripheral"];
                }
            }
        }
    }
    return peripheral;
}

-(void)removeAllSignal
{
    if (notifyConfigDisposable) {
        if (![notifyConfigDisposable isDisposed]) {
            [notifyConfigDisposable dispose];
        }
    }
    
    if (timeIntervalDisposable) {
        if (![timeIntervalDisposable isDisposed]) {
            [timeIntervalDisposable dispose];
        }
    }
    
    if (notifyBluetoothDataDisposable) {
        if (![notifyBluetoothDataDisposable isDisposed]) {
            [notifyBluetoothDataDisposable dispose];
        }
    }
    
    if (notifyBluetoothPowerOnDisposable) {
        if (![notifyBluetoothPowerOnDisposable isDisposed]) {
            [notifyBluetoothPowerOnDisposable dispose];
        }
    }
    
    if (notifyBluetoothPowerOffDisposable) {
        if (![notifyBluetoothPowerOffDisposable isDisposed]) {
            [notifyBluetoothPowerOffDisposable dispose];
        }
    }
    
    if (notifySocketDidConnectedDisposable) {
        if (![notifySocketDidConnectedDisposable isDisposed]) {
            [notifySocketDidConnectedDisposable dispose];
        }
    }
    
    if (notifySocketDidDisconnectedDisposable) {
        if (![notifySocketDidDisconnectedDisposable isDisposed]) {
            [notifySocketDidDisconnectedDisposable dispose];
        }
    }
}

-(RACSignal *)storyPMValueSignal
{
    return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@{@"x":@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"],@"y":@[@20.1, @180.1, @26.4, @202.2, @126.2]}];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"获取历史PM记录signal销毁");
        }];
    }];
}

#pragma -mark BluetoothManagerProtocol
-(void)deliveryData:(NSData *)data
{
    if (!data || data.length == 0) {
        
        return;
    }
    
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i< data.length; i++) {
        NSLog(@"%d",byte[i]);
    }
    if (data.length > 2) {
        int code = (int)byte[1];
        BluetoothCommand command = (BluetoothCommand)code;
        switch (command) {
            case RequestWheatherInfo:
            {
                int pmValue = (int)byte[2]*256 + (int)byte[3];
                int tmValue = (int)byte[4]*256 + (int)byte[5];
                int hmValue = (int)byte[6]*256 + (int)byte[7];
                self.airIndex = @{@"Pm":[NSNumber numberWithInt:pmValue],@"Te":[NSNumber numberWithInt:tmValue],@"Hm":[NSNumber numberWithInt:hmValue]};
            }
                break;
            case RequestSettingTimeOperation:
            {
                
            }
                break;
            default:
                break;
        }
    }
}

@end
