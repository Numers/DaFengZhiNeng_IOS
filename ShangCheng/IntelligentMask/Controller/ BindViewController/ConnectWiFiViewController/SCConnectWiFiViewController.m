//
//  SCConnectWiFiViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/28.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCConnectWiFiViewController.h"
#import "SCConnectWiFiViewModel.h"

@interface SCConnectWiFiViewController ()
@property(nonatomic, strong) SCConnectWiFiViewModel *scConnectWifiViewModel;

@property(nonatomic, strong) IBOutlet UILabel *lblSSID;
@end

@implementation SCConnectWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage * backgroundImg = [UIImage imageNamed:@"BindView_BlurBackgroundImage"];
    self.view.layer.contents = (id) backgroundImg.CGImage;
    _scConnectWifiViewModel = [[SCConnectWiFiViewModel alloc] init];
    [_lblSSID setText:_scConnectWifiViewModel.currentWifiSSID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickConnectBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
