//
//  SCConnectDeviceViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/25.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCConnectDeviceViewController.h"
#import "SCConnectWiFiViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BluetoothMacManager.h"

static NSString *connectDeviceCellIdentify = @"ConnectDeviceCellIdentify";
@interface SCConnectDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *selectIndexPath;
}
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation SCConnectDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickConnectBtn:(id)sender
{
    NSDictionary *selectDic = [_peripheralDicList objectAtIndex:selectIndexPath.row];
    CBPeripheral *selectPeripheral = [selectDic objectForKey:@"peripheral"];
    if (selectPeripheral) {
        [[BluetoothMacManager defaultManager] connectToPeripheral:selectPeripheral callBack:^(BOOL completely, CallbackType backType, id obj, ConnectType connectType) {
            if (completely) {
                NSString *bindMacAddress = [selectDic objectForKey:@"mac"];
                [AppUtils localUserDefaultsValue:bindMacAddress forKey:KMY_DeviceMacAddress];
                SCConnectWiFiViewController *scConnectWifiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectWiFiViewIdentify"];
                [self.navigationController pushViewController:scConnectWifiVC animated:YES];
            }else{
                [AppUtils showInfo:@"连接失败,请重新连接"];
                SCConnectWiFiViewController *scConnectWifiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectWiFiViewIdentify"];
                [self.navigationController pushViewController:scConnectWifiVC animated:YES];
            }
        }];
    }
}

-(IBAction)clickSearchAgainBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchAgainOperation)]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate searchAgainOperation];
    }
}

#pragma -mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _peripheralDicList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"%@_%ld",connectDeviceCellIdentify,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:connectDeviceCellIdentify];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            //Data processing
            NSDictionary *dic = [_peripheralDicList objectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                //Update Interface
                NSString *macAddress = [dic objectForKey:@"mac"];
                CBPeripheral *peripheral = [dic objectForKey:@"peripheral"];
                NSString *deviceName = [NSString stringWithFormat:@"%@-%@",peripheral.name,macAddress];
                [cell.textLabel setText:deviceName];
            });
        }
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath != selectIndexPath) {
        if (selectIndexPath) {
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:selectIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectIndexPath = indexPath;
    }
}

@end
