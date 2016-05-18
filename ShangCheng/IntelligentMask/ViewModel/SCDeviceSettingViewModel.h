//
//  SCDeviceSettingViewModel.h
//  IntelligentMask
//
//  Created by baolicheng on 16/3/21.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDeviceSettingViewModel : NSObject
@property(nonatomic) BOOL switchDeviceOpen;
@property(nonatomic) BOOL switchAutoSyncTime;
@property(nonatomic) BOOL switchModeSelect;
@property(nonatomic) BOOL switchHumiditySelect;
@property(nonatomic) BOOL switchHumidificateAirChange;
@property(nonatomic) BOOL switchClearAirChange;
@property(nonatomic) BOOL switchReduceFormaldehydeChange;

-(RACSignal *)currentModelStatusFromNetWork;

-(RACSignal *)sendDeviceOpenStatus:(BOOL)isOn;
-(RACSignal *)sendAutoSyncTimeStatus:(BOOL)isOn;
-(RACSignal *)sendModeSelectStatus:(BOOL)isOn;
-(RACSignal *)sendHumiditySelectStatus:(BOOL)isOn;
-(RACSignal *)sendHumidificateAirChange:(BOOL)isOn;
-(RACSignal *)sendClearAirChangeStatus:(BOOL)isOn;
-(RACSignal *)sendReduceFormaldehydeChangeStatus:(BOOL)isOn;
@end
