//
//  SCDeviceSettingViewModel.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/21.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCDeviceSettingViewModel.h"

@implementation SCDeviceSettingViewModel
-(RACSignal *)currentModelStatusFromNetWork
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.switchDeviceOpen = NO;
        self.switchModeSelect = YES;
        self.switchAutoSyncTime = NO;
        self.switchClearAirChange = YES;
        self.switchHumiditySelect = YES;
        self.switchHumidificateAirChange = NO;
        self.switchReduceFormaldehydeChange = NO;
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

-(RACSignal *)sendDeviceOpenStatus:(BOOL)isOn
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.switchDeviceOpen = isOn;
        [subscriber sendNext:@(YES)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"DeviceOpenSignal 销毁");
        }];
    }];
}

-(RACSignal *)sendAutoSyncTimeStatus:(BOOL)isOn
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.switchAutoSyncTime = isOn;
        [subscriber sendNext:@(YES)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"AutoSyncTimeSignal 销毁");
        }];
    }];
}

-(RACSignal *)sendModeSelectStatus:(BOOL)isOn
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.switchModeSelect = isOn;
        [subscriber sendNext:@(YES)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"ModeSelectSignal 销毁");
        }];
    }];
}

-(RACSignal *)sendHumiditySelectStatus:(BOOL)isOn
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.switchHumiditySelect = isOn;
        if (!isOn) {
            self.switchHumidificateAirChange = NO;
            self.switchReduceFormaldehydeChange = NO;
            self.switchClearAirChange = NO;
        }else{
            self.switchHumidificateAirChange = YES;
            self.switchReduceFormaldehydeChange = YES;
            self.switchClearAirChange = YES;
        }
        [subscriber sendNext:@(YES)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"HumiditySelectSignal 销毁");
        }];
    }];
}

-(RACSignal *)sendHumidificateAirChange:(BOOL)isOn
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.switchHumidificateAirChange = isOn;
        RACSignal *signal = [RACSignal combineLatest:@[RACObserve(self, switchClearAirChange),RACObserve(self, switchReduceFormaldehydeChange)] reduce:^id{
            return @(!isOn && !self.switchClearAirChange && !self.switchReduceFormaldehydeChange);
        }];
        [[signal subscribeNext:^(id x) {
            self.switchHumiditySelect = ![x boolValue];
        }] dispose];
        [subscriber sendNext:@(YES)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"HumidificateAirChangeSignal 销毁");
        }];
    }];
}

-(RACSignal *)sendClearAirChangeStatus:(BOOL)isOn
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.switchClearAirChange = isOn;
        RACSignal *signal = [RACSignal combineLatest:@[RACObserve(self, switchHumidificateAirChange),RACObserve(self, switchReduceFormaldehydeChange)] reduce:^id{
            return @(!isOn && !self.switchHumidificateAirChange && !self.switchReduceFormaldehydeChange);
        }];
        [[signal subscribeNext:^(id x) {
            self.switchHumiditySelect = ![x boolValue];
        }] dispose];
        [subscriber sendNext:@(YES)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"ClearAirChangeSignal 销毁");
        }];
    }];
}

-(RACSignal *)sendReduceFormaldehydeChangeStatus:(BOOL)isOn
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.switchReduceFormaldehydeChange = isOn;
        RACSignal *signal = [RACSignal combineLatest:@[RACObserve(self, switchHumidificateAirChange),RACObserve(self, switchClearAirChange)] reduce:^id{
            return @(!isOn && !self.switchHumidificateAirChange && !self.switchClearAirChange);
        }];
        [[signal subscribeNext:^(id x) {
            self.switchHumiditySelect = ![x boolValue];
        }] dispose];
        [subscriber sendNext:@(YES)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"ReduceFormaldehydeChangeSignal 销毁");
        }];
    }];
}
@end
