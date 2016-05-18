//
//  SCSearchBluetoothViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/22.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCSearchBluetoothViewController.h"
#import "BluetoothMacManager.h"
#import "SCConnectDeviceViewController.h"

@interface SCSearchBluetoothViewController ()<ConnectDeviceViewProtocol>
{
    RACDisposable *notifyBluetoothPowerOnDisposable;
}
@property(nonatomic, strong) IBOutlet UIButton *btnBind;
@end

@implementation SCSearchBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage * backgroundImg = [UIImage imageNamed:@"BindView_BackgroundImage"];
    self.view.layer.contents = (id) backgroundImg.CGImage;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (notifyBluetoothPowerOnDisposable) {
        if (![notifyBluetoothPowerOnDisposable isDisposed]) {
            [notifyBluetoothPowerOnDisposable dispose];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBindBtnStatus:(BOOL)isSearch
{
    if (isSearch) {
        [self.btnBind setImage:[UIImage imageNamed:@"BindView_SearchBtnImage"] forState:UIControlStateNormal];
        [self.btnBind setEnabled:NO];
    }else{
        [self.btnBind setImage:[UIImage imageNamed:@"BindView_BindBtnImage"] forState:UIControlStateNormal];
        [self.btnBind setEnabled:YES];
    }
}

-(void)searchBluetooth
{
    [self setBindBtnStatus:YES];
    if (notifyBluetoothPowerOnDisposable) {
        if (![notifyBluetoothPowerOnDisposable isDisposed]) {
            [notifyBluetoothPowerOnDisposable dispose];
        }
    }
    [[BluetoothMacManager defaultManager] startBluetoothDevice];
    notifyBluetoothPowerOnDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kBluetoothPowerOnNotify object:nil] subscribeNext:^(id x) {
        [[BluetoothMacManager defaultManager] startScanBluetoothDevice:ConnectForSearch callBack:^(BOOL completely, CallbackType backType, id obj, ConnectType connectType) {
            if (!completely) {
                if (connectType == ConnectForSearch) {
                    //判断是否有搜索到蓝牙信号，有就push到蓝牙选择页面
                    if ([obj isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)obj;
                        if (arr.count == 0) {
                            [self setBindBtnStatus:NO];
                        }else{
                            SCConnectDeviceViewController *scConnectDeviceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectDeviceViewIdentify"];
                            scConnectDeviceVC.delegate = self;
                            scConnectDeviceVC.peripheralDicList = arr;
                            [self.navigationController pushViewController:scConnectDeviceVC animated:YES];
                        }
                    }
                }
            }

        }];
    }];
    
}

-(IBAction)clickBindBtn:(id)sender
{
    [self searchBluetooth];
}

#pragma -mark ConnectDeviceViewProtocol
-(void)searchAgainOperation
{
    [self searchBluetooth];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
