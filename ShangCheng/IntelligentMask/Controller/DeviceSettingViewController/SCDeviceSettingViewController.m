//
//  SCDeviceSettingViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/21.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCDeviceSettingViewController.h"
#import "SCDeviceSettingViewModel.h"

@interface SCDeviceSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
//{
//    BOOL switchDeviceOpen;
//    BOOL switchAutoSyncTime;
//    BOOL switchModeSelect;
//    BOOL switchHumiditySelect;
//    BOOL switchHumidificateAirChange;
//    BOOL switchClearAirChange;
//    BOOL switchReduceFormaldehydeChange;
//}
@property(nonatomic, strong) SCDeviceSettingViewModel *deviceSettingViewModel;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation SCDeviceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.deviceSettingViewModel = [[SCDeviceSettingViewModel alloc] init];
    [self.deviceSettingViewModel.currentModelStatusFromNetWork subscribeNext:^(id x) {
        [self.tableView reloadData];
    } error:^(NSError *error) {
        
    } completed:^{
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"设置"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
        case 1:
            row = 1;
            break;
        case 2:
            row = self.deviceSettingViewModel.switchHumiditySelect?3:1;
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceSettingCellIdentify"];
    UILabel *leftLabel = [cell viewWithTag:1];
    UILabel *leftSubLable = [cell viewWithTag:2];
    UISwitch *sw = [cell viewWithTag:3];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [leftLabel setText:@"设备开关"];
                    [leftSubLable setText:nil];
                    
                    sw.restorationIdentifier = @"DeviceOpenIdentifier";
                    [sw setOn:self.deviceSettingViewModel.switchDeviceOpen];
                    break;
                case 1:
                    [leftLabel setText:@"自动同步手机时间"];
                    [leftSubLable setText:nil];
                    
                    sw.restorationIdentifier = @"AutoSyncTimeIdentifier";
                    [sw setOn:self.deviceSettingViewModel.switchAutoSyncTime];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [leftLabel setText:@"模式选择"];
                    [leftSubLable setText:nil];
                    
                    sw.restorationIdentifier = @"ModeSelectIdentifier";
                    [sw setOn:self.deviceSettingViewModel.switchModeSelect];
                    break;
                default:
                    break;
            }
            break;
        case 2:
        {
            if (self.deviceSettingViewModel.switchHumiditySelect) {
                switch (indexPath.row) {
                    case 0:
                        [leftLabel setText:@"加湿空气"];
                        [leftSubLable setText:@"功率"];
                        
                        sw.restorationIdentifier = @"HumidificateAirChangeIdentifier";
                        [sw setOn:self.deviceSettingViewModel.switchHumidificateAirChange];
                        break;
                    case 1:
                        [leftLabel setText:@"净化空气"];
                        [leftSubLable setText:@"功率"];
                        
                        sw.restorationIdentifier = @"ClearAirChangeIdentifier";
                        [sw setOn:self.deviceSettingViewModel.switchClearAirChange];
                        break;
                    case 2:
                        [leftLabel setText:@"清除甲醛"];
                        [leftSubLable setText:@"功率"];
                        
                        sw.restorationIdentifier = @"ReduceFormaldehydeChangeIdentifier";
                        [sw setOn:self.deviceSettingViewModel.switchReduceFormaldehydeChange];
                        break;
                    default:
                        break;
                }

            }else{
                switch (indexPath.row) {
                    case 0:
                        [leftLabel setText:@"湿度选择"];
                        [leftSubLable setText:nil];
                        
                        sw.restorationIdentifier = @"HumiditySelectIdentifier";
                        [sw setOn:self.deviceSettingViewModel.switchHumiditySelect];
                        break;
                    default:
                        break;
                }
            }
        }
        break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma -mark IBAction
-(IBAction)clickSwitch:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    if ([sw.restorationIdentifier isEqualToString:@"DeviceOpenIdentifier"]) {
        [[[self.deviceSettingViewModel sendDeviceOpenStatus:sw.isOn] subscribeNext:^(id x) {
            [self.tableView reloadData];
        } error:^(NSError *error) {
            
        } completed:^{
            
        }] dispose];
    }
    
    if ([sw.restorationIdentifier isEqualToString:@"AutoSyncTimeIdentifier"]) {
        [[[self.deviceSettingViewModel sendAutoSyncTimeStatus:sw.isOn] subscribeNext:^(id x) {
            [self.tableView reloadData];
        } error:^(NSError *error) {
            
        } completed:^{
            
        }] dispose];
    }
    
    if ([sw.restorationIdentifier isEqualToString:@"ModeSelectIdentifier"]) {
        [[[self.deviceSettingViewModel sendModeSelectStatus:sw.isOn] subscribeNext:^(id x) {
            [self.tableView reloadData];
        } error:^(NSError *error) {
            
        } completed:^{
            
        }] dispose];
    }
    
    if ([sw.restorationIdentifier isEqualToString:@"HumidificateAirChangeIdentifier"]){
        [[[self.deviceSettingViewModel sendHumidificateAirChange:sw.isOn] subscribeNext:^(id x) {
            [self.tableView reloadData];
        } error:^(NSError *error) {
            
        } completed:^{
            
        }] dispose];
    }
    
    if ([sw.restorationIdentifier isEqualToString:@"ClearAirChangeIdentifier"]) {
        [[[self.deviceSettingViewModel sendClearAirChangeStatus:sw.isOn] subscribeNext:^(id x) {
            [self.tableView reloadData];
        } error:^(NSError *error) {
            
        } completed:^{
            
        }] dispose];
    }
    
    if ([sw.restorationIdentifier isEqualToString:@"ReduceFormaldehydeChangeIdentifier"]) {
        [[[self.deviceSettingViewModel sendReduceFormaldehydeChangeStatus:sw.isOn] subscribeNext:^(id x) {
            [self.tableView reloadData];
        } error:^(NSError *error) {
            
        } completed:^{
            
        }] dispose];
    }
    
    if ([sw.restorationIdentifier isEqualToString:@"HumiditySelectIdentifier"]) {
        [[[self.deviceSettingViewModel sendHumiditySelectStatus:sw.isOn] subscribeNext:^(id x) {
            [self.tableView reloadData];
        } error:^(NSError *error) {
            
        } completed:^{
            
        }] dispose];
    }
}
@end
