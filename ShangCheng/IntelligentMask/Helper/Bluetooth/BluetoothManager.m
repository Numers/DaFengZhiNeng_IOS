//
//  BluetoothManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "BluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "DataAnalizer.h"

#define ConnectTimeOut 15
#define kServiceUUID @"FFF0" //服务的UUID
#define kMacServiceUUID @"180A"//获取Mac地址的UUID
#define kCharacteristicNotifyUUID @"FFF1" //通知特征的UUID
#define kCharacteristicWriteUUID @"FFF2" //写入数据特征的UUID
#define kCharacteristicMacReadUUID @"2A23" //读取Mac地址的特征UUID

static NSInteger connectTime = 0;
static BluetoothManager *bluetoothManager;
@interface BluetoothManager()<CBCentralManagerDelegate,CBPeripheralDelegate,DataAnalizerProtocol>
{
    DataAnalizer *dataAnalizer;
    BluetoothCallBak deviceCallBack;
    ConnectType connectType;
    NSTimer *timer;
    BOOL isConnected;
}
@property (assign,nonatomic) id<BluetoothManagerProtocol> delegate;
@property (strong,nonatomic) CBCentralManager *centralManager;//中心设备管理器
@property (strong,nonatomic) NSMutableArray *peripherals;//搜索到的外围设备

@property(strong,nonatomic) NSMutableArray *peripheralMacArray;

@property (strong,nonatomic) CBPeripheral *peripheral;//当前连接的外围设备
@end
@implementation BluetoothManager
+(id)defaultManager
{
    if (bluetoothManager == nil) {
        bluetoothManager = [[BluetoothManager alloc] init];
    }
    return bluetoothManager;
}

-(void)setBluetoothManagerDelegate:(id<BluetoothManagerProtocol>)viewController
{
    self.delegate = viewController;
}

-(void)callBackDevice:(BOOL)connectCompelete WithCallbackType:(CallbackType)type
{
    isConnected = connectCompelete;
    if (!connectCompelete) {
        [self stopBluetoothDevice];
    }
    if (connectType == ConnectForMacAddress && type == CallbackTimeout) {
        deviceCallBack(connectCompelete,type,self.peripheralMacArray);
    }else{
        deviceCallBack(connectCompelete,type,self.peripherals);
    }
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
    }
}

-(BOOL)isConnected
{
    return isConnected;
}

-(void)startBluetoothDevice:(ConnectType)type callBack:(BluetoothCallBak)callBack;
{
    isConnected = NO;
    connectTime = 0;
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
    }
    if(self.peripherals){
        [self.peripherals removeAllObjects];
    }else{
        self.peripherals = [NSMutableArray array];
    }
    
    if (self.peripheralMacArray) {
        [self.peripheralMacArray removeAllObjects];
    }else{
        self.peripheralMacArray = [NSMutableArray array];
    }

    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countConnectTime) userInfo:nil repeats:YES];
    deviceCallBack = callBack;
    connectType = type;
    //创建中心设备管理器并设置当前控制器视图为代理
    self.centralManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

-(void)countConnectTime
{
    connectTime ++;
    if (connectTime > ConnectTimeOut) {
        [self callBackDevice:NO WithCallbackType:CallbackTimeout];
    }
}

-(void)stopBluetoothDevice
{
    if (self.centralManager) {
        [self.centralManager stopScan];
        if (self.peripheral) {
            [self.centralManager cancelPeripheralConnection:self.peripheral];
            self.peripheral = nil;
            self.centralManager = nil;
            isConnected = NO;
        }
    }
}

-(void)writeCharacteristicWithCommand:(BluetoothCommand)command {
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    if (!self.peripheral) {
        return;
    }
    
    if (self.peripheral.services == nil || self.peripheral.services.count == 0) {
        isConnected = NO;
        [self callBackDevice:NO WithCallbackType:CallbackDisconnect];
        return;
    }
    
    for ( CBService *service in self.peripheral.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicWriteUUID]]) {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    Byte msgbyte[1] = {command};
                    [self.peripheral writeValue:[NSData dataWithBytes:&msgbyte length:1] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                }
            }
        }
    }
}

-(void)registerNotificationWithValue:(BOOL)isNotify
{
    if (!self.peripheral) {
        return;
    }
    for ( CBService *service in self.peripheral.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicNotifyUUID]]) {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    if (!characteristic.isNotifying) {
                        [self.peripheral setNotifyValue:isNotify forCharacteristic:characteristic];
                    }
                }
            }
        }
    }
}

-(void)connectToPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral && self.centralManager) {
        if (connectType != ConnectForMacAddress) {
            //停止扫描
            [self.centralManager stopScan];
        }
        self.peripheral = peripheral;
        NSLog(@"开始连接外围设备...");
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

-(RACSignal *)peripheralAddObjSignal
{
    return [self.peripherals rac_signalForSelector:@selector(addObject:)];
}


#pragma mark - CBCentralManager代理方法
//中心服务器状态更新后
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"BLE已打开.");
            //扫描外围设备
            //            [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            
            [central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            break;
            
        default:
            [self callBackDevice:NO WithCallbackType:CallbackBluetoothPowerOff];
            NSLog(@"此设备不支持BLE或未打开蓝牙功能，无法作为外围设备.");
            break;
    }
}
/**
 *  发现外围设备
 *
 *  @param central           中心设备
 *  @param peripheral        外围设备
 *  @param advertisementData 特征数据
 *  @param RSSI              信号质量（信号强度）
 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"发现外围设备...");
    //连接外围设备
    if (peripheral) {
        //找到口罩设备的蓝牙信号
        if(![peripheral.name hasPrefix:@"HJ-580"]){
            return;
        }
        
        //添加保存外围设备，注意如果这里不保存外围设备（或者说peripheral没有一个强引用，无法到达连接成功（或失败）的代理方法，因为在此方法调用完就会被销毁
        if(![self.peripherals containsObject:peripheral]){
            [self.peripherals addObject:peripheral];
        }
        
        if (connectType == ConnectToDevice || connectType == ConnectForMacAddress) {
            [self connectToPeripheral:peripheral];
        }
    }
    
}
//连接到外围设备
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接外围设备成功!");
    //设置外围设备的代理为当前视图控制器
    peripheral.delegate=self;
    //外围设备开始寻找服务
    if (connectType == ConnectForMacAddress) {
        [peripheral discoverServices:@[[CBUUID UUIDWithString:kMacServiceUUID]]];
    }else{
        [peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
    }
}
//连接外围设备失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接外围设备失败!");
    [self callBackDevice:NO WithCallbackType:CallbackDidFailToConnectPeriphera];
}

#pragma mark - CBPeripheral 代理方法
//外围设备寻找到服务后
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"已发现可用服务...");
    if(error){
        NSLog(@"外围设备寻找服务过程中发生错误，错误信息：%@",error.localizedDescription);
        [self callBackDevice:NO WithCallbackType:CallbackDidDiscoverServicesError];
        return;
    }
    
    if (connectType == ConnectForMacAddress) {
        CBUUID *characteristicReadUUID=[CBUUID UUIDWithString:kCharacteristicMacReadUUID];
        for (CBService *service in peripheral.services)
        {
            [peripheral discoverCharacteristics:@[characteristicReadUUID]  forService:service];
        }
    }else{
        //遍历服务搜索特征
        CBUUID *characteristicNotifyUUID=[CBUUID UUIDWithString:kCharacteristicNotifyUUID];
        CBUUID *characteristicWriteUUID=[CBUUID UUIDWithString:kCharacteristicWriteUUID];
        for (CBService *service in peripheral.services)
        {
            [peripheral discoverCharacteristics:@[characteristicNotifyUUID,characteristicWriteUUID]  forService:service];
        }
    }
}

//外围设备寻找到特征后
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"已发现可用特征...");
    if (error) {
        NSLog(@"外围设备寻找特征过程中发生错误，错误信息：%@",error.localizedDescription);
        [self callBackDevice:NO WithCallbackType:CallbackDidDiscoverCharacteristicsError];
        return;
    }
    if (connectType == ConnectForMacAddress) {
        if (service.characteristics.count > 0) {
            [peripheral readValueForCharacteristic:[service.characteristics objectAtIndex:0]];
        }
    }else{
        [self registerNotificationWithValue:YES];
    }
}

//特征值被更新后
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"收到特征更新通知...");
    if (error) {
        NSLog(@"更新通知状态时发生错误，错误信息：%@",error.localizedDescription);
        [self callBackDevice:NO WithCallbackType:CallbackDidUpdateNotificationStateError];
        return;
    }
    [self callBackDevice:YES WithCallbackType:CallbackSuccess];
}

//更新特征值后（调用readValueForCharacteristic:方法或者外围设备在订阅后更新特征值都会调用此代理方法）
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"更新特征值时发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    
    if (connectType == ConnectForMacAddress) {
        NSString *value = [NSString stringWithFormat:@"%@",characteristic.value];
        NSMutableString *macString = [[NSMutableString alloc] init];
        [macString appendString:[[value substringWithRange:NSMakeRange(16, 2)] uppercaseString]];
        [macString appendString:@":"];
        [macString appendString:[[value substringWithRange:NSMakeRange(14, 2)] uppercaseString]];
        [macString appendString:@":"];
        [macString appendString:[[value substringWithRange:NSMakeRange(12, 2)] uppercaseString]];
        [macString appendString:@":"];
        [macString appendString:[[value substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
        [macString appendString:@":"];
        [macString appendString:[[value substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
        [macString appendString:@":"];
        [macString appendString:[[value substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
        
        NSDictionary *dic = @{@"peripheral":peripheral,@"mac":macString};
        [self.peripheralMacArray addObject:dic];
        NSLog(@"macString:%@",macString);
        NSLog(@"%@",value);
    }else{
        if (characteristic.value) {
            if (dataAnalizer == nil) {
                dataAnalizer = [[DataAnalizer alloc] init];
                dataAnalizer.delegate = self;
            }
            [dataAnalizer inputData:characteristic.value];
        }else{
            NSLog(@"未发现特征值.");
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        isConnected = YES;
        NSLog(@"发送成功");
    }else{
        isConnected = NO;
        [self callBackDevice:NO WithCallbackType:CallbackDidWriteValueError];
    }
}

#pragma -mark DataAnalizerProtocol
-(void)outputDataString:(NSString *)data
{
    NSLog(@"输出数据:%@",data);
    [[NSNotificationCenter defaultCenter] postNotificationName:BluetoothDeliveryDataNotify object:data];
    if ([self.delegate respondsToSelector:@selector(deliveryData:)]) {
        [self.delegate deliveryData:data];
    }
}
@end
