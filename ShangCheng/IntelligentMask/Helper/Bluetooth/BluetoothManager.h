//
//  BluetoothManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BluetoothDeliveryDataNotify @"BluetoothDeliverryDataNotify"
typedef enum{
    RequestWheatherInfo = 0x31,
    RequestElectricPower = 0x32,
    RequestBindOperation = 0x33,
    RequestUnbindOperation = 0x34
} BluetoothCommand;

typedef enum{
    CallbackSuccess = 1,
    CallbackTimeout,
    CallbackDisconnect,
    CallbackBluetoothPowerOff,
    CallbackDidFailToConnectPeriphera,
    CallbackDidDiscoverCharacteristicsError,
    CallbackDidUpdateNotificationStateError,
    CallbackDidWriteValueError,
    CallbackDidDiscoverServicesError
}CallbackType;

typedef enum{
    ConnectToDevice = 1,
    ConnectForSearch,
    ConnectForMacAddress
}ConnectType;
typedef void (^BluetoothCallBak)(BOOL completely,CallbackType backType, id obj);
@protocol BluetoothManagerProtocol <NSObject>
-(void)deliveryData:(NSString *)data;
@end

@class CBPeripheral;
@interface BluetoothManager : NSObject
+(id)defaultManager;

-(void)setBluetoothManagerDelegate:(id<BluetoothManagerProtocol>)viewController;
/**
 *  @author RenRenFenQi, 16-01-19 14:01:35
 *
 *  启动蓝牙设备进行搜索
 */
-(void)startBluetoothDevice:(ConnectType)type callBack:(BluetoothCallBak)callBack;

/**
 *  @author RenRenFenQi, 16-01-19 15:01:05
 *
 *  取消或者订阅智能硬件设备蓝牙
 *
 *  @param isNotify YES/订阅  NO/取消订阅
 */
-(void)registerNotificationWithValue:(BOOL)isNotify;

/**
 *  @author RenRenFenQi, 16-01-19 15:01:09
 *
 *  给硬件设备发送指令
 *
 *  @param command 指令码
 */
-(void)writeCharacteristicWithCommand:(BluetoothCommand)command;

/**
 *  @author RenRenFenQi, 16-01-22 14:01:40
 *
 *  断开蓝牙连接
 */
-(void)stopBluetoothDevice;

/**
 *  @author RenRenFenQi, 16-01-28 15:01:26
 *
 *  蓝牙是否连接状态
 *
 *  @return YES/是 NO/否
 */
-(BOOL)isConnected;

/**
 *  @author RenRenFenQi, 16-03-22 17:03:10
 *
 *  连接设备
 *
 *  @param peripheral 蓝牙设备
 */
-(void)connectToPeripheral:(CBPeripheral *)peripheral;

/**
 *  @author RenRenFenQi, 16-03-22 17:03:19
 *
 *  搜索出的蓝牙队列信号
 *
 *  @return 蓝牙队列信号
 */
-(RACSignal *)peripheralAddObjSignal;
@end
