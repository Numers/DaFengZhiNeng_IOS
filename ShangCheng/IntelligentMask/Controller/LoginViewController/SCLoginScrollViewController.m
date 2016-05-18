//
//  SCLoginScrollViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCLoginScrollViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UINavigationController+PHNavigationController.h"
#import "SCLoginViewController.h"
#import "SCRegisterScrollViewController.h"
#import "SCFindPasswordStepOneScrollViewController.h"
#import "ZXAppStartManager.h"
#import "RFGeneralManager.h"
@interface SCLoginScrollViewController ()<UIScrollViewDelegate,SCLoginViewProtocol>
{
    TPKeyboardAvoidingScrollView *scrollView;
    SCLoginViewController *scLoginVC;
    UIStoryboard *storyboard;
}
@end

@implementation SCLoginScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景效果
    UIImage * backgroundImg = [UIImage imageNamed:@"BackgroudImage"];
    self.view.layer.contents = (id) backgroundImg.CGImage;
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    scLoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewIdentify"];
    scLoginVC.delegate = self;
    [scrollView addSubview:scLoginVC.view];
    
    [scrollView setContentSize:scLoginVC.view.frame.size];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [scLoginVC startAnimate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark ZXLoginViewProtocol
-(void)loginSuccess
{
    [[RFGeneralManager defaultManager] sendClientIdSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [AppUtils localUserDefaultsValue:@"1" forKey:KMY_AutoLogin];
    [[ZXAppStartManager defaultManager] pushHomeViewWithSelectIndex:0];
}

-(void)goRegisterView
{
    SCRegisterScrollViewController *scRegisterScrollVC = [[SCRegisterScrollViewController alloc] init];
    [self.navigationController pushViewController:scRegisterScrollVC animated:YES];
}

-(void)goFindPasswordView
{
    SCFindPasswordStepOneScrollViewController *scStepOneVC = [[SCFindPasswordStepOneScrollViewController alloc] init];
    [self.navigationController pushViewController:scStepOneVC animated:YES];
}
@end
