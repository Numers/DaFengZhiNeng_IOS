//
//  BluetoothMacManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/3/24.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BluetoothDeliveryDataNotify @"BluetoothDeliverryDataNotify"
#define kBluetoothPowerOnNotify @"KBluetoothPowerOnNotify"
#define kBluetoothPowerOffNotify @"KBluetoothPowerOffNotify"
typedef enum{
    RequestWheatherInfo = 0x31,
    RequestSettingTimeOperation = 0x32
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
    ConnectForSearch
}ConnectType;
typedef void (^BluetoothCallBak)(BOOL completely,CallbackType backType, id obj, ConnectType connectType);
@protocol BluetoothManagerProtocol <NSObject>
-(void)deliveryData:(NSData *)data;
@end

@class CBPeripheral;
@interface BluetoothMacManager : NSObject
+(id)defaultManager;

-(void)setBluetoothManagerDelegate:(id<BluetoothManagerProtocol>)viewController;
/**
 *  @author RenRenFenQi, 16-01-19 14:01:35
 *
 *  启动蓝牙设备进行搜索
 */
-(void)startBluetoothDevice;

/**
 *  @author RenRenFenQi, 16-04-28 17:04:09
 *
 *  启动蓝牙设备进行搜索
 *
 *  @param type     连接类型，搜索或者直接搜索到就连接
 *  @param callBack 完成后回调
 */
-(void)startScanBluetoothDevice:(ConnectType)type callBack:(BluetoothCallBak)callBack;
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
-(void)connectToPeripheral:(CBPeripheral *)peripheral callBack:(BluetoothCallBak)callBack;

/**
 *  @author RenRenFenQi, 16-03-25 14:03:55
 *
 *  获取搜索到的所有智能设备
 *
 *  @return 智能设备字典 @{@"peripheral":peripheral,@"mac":macAdress}
 */
-(NSArray *)returnAllSearchedPeripheralsDictionary;

@end
