//
//  SCRegisterScrollViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/27.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCRegisterScrollViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UINavigationController+PHNavigationController.h"
#import "SCRegisterViewController.h"

@interface SCRegisterScrollViewController ()<UIScrollViewDelegate,SCRegisterViewProtocol>
{
    TPKeyboardAvoidingScrollView *scrollView;
    SCRegisterViewController *scRegisterVC;
    UIStoryboard *storyboard;
}
@end

@implementation SCRegisterScrollViewController

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
    scRegisterVC = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewIdentify"];
    scRegisterVC.delegate = self;
    [scrollView addSubview:scRegisterVC.view];
    
    [scrollView setContentSize:scRegisterVC.view.frame.size];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [scRegisterVC startAnimate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark SCRegisterViewProtocol
-(void)goLoginView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)registerSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
