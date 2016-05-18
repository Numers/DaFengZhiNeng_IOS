//
//  SCFindPasswordStepOneScrollViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCFindPasswordStepOneScrollViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UINavigationController+PHNavigationController.h"
#import "SCFindPasswordStepOneViewController.h"
#import "SCFindPasswordStepTwoScrollViewController.h"

@interface SCFindPasswordStepOneScrollViewController ()<UIScrollViewDelegate,SCFindPasswordStepOneProtocol>
{
    TPKeyboardAvoidingScrollView *scrollView;
    SCFindPasswordStepOneViewController *scStepOneVC;
    UIStoryboard *storyboard;
}
@end

@implementation SCFindPasswordStepOneScrollViewController

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
    scStepOneVC = [storyboard instantiateViewControllerWithIdentifier:@"FindPasswordStepOneViewIdentify"];
    scStepOneVC.delegate = self;
    [scrollView addSubview:scStepOneVC.view];
    
    [scrollView setContentSize:scStepOneVC.view.frame.size];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [scStepOneVC startAnimate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark SCFindPasswordStepOneProtocol
-(void)goNextStep:(NSString *)phone WithVerificationCode:(NSString *)code WithVerificationTime:(NSNumber *)time
{
    SCFindPasswordStepTwoScrollViewController *scStepTwoVC = [[SCFindPasswordStepTwoScrollViewController alloc] initWithPhone:phone WithVerificationCode:code WithVerificationTime:time];
    [self.navigationController pushViewController:scStepTwoVC animated:YES];
}
@end
