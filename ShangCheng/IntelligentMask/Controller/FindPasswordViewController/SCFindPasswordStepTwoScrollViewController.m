//
//  SCFindPasswordStepTwoScrollViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/3.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCFindPasswordStepTwoScrollViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UINavigationController+PHNavigationController.h"
#import "SCFindPasswordStepTwoViewController.h"
#import "SCLoginScrollViewController.h"
@interface SCFindPasswordStepTwoScrollViewController ()<UIScrollViewDelegate,SCFindPasswordStepTwoProtocol>
{
    NSString *thePhone;
    NSString *verificationCode;
    NSNumber *verificaitonTime;
    
    TPKeyboardAvoidingScrollView *scrollView;
    SCFindPasswordStepTwoViewController *scStepTwoVC;
    UIStoryboard *storyboard;
}
@end

@implementation SCFindPasswordStepTwoScrollViewController
-(id)initWithPhone:(NSString *)phone WithVerificationCode:(NSString *)code WithVerificationTime:(NSNumber *)time
{
    self = [super init];
    if (self) {
        thePhone = phone;
        verificationCode = code;
        verificaitonTime = time;
    }
    return self;
}

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
    scStepTwoVC = [storyboard instantiateViewControllerWithIdentifier:@"FindPasswordStepTwoViewIdentify"];
    [scStepTwoVC setPhone:thePhone WithVerificationCode:verificationCode WithVerificationTime:verificaitonTime];
    scStepTwoVC.delegate = self;
    [scrollView addSubview:scStepTwoVC.view];
    
    [scrollView setContentSize:scStepTwoVC.view.frame.size];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setTranslucentView];
    [scStepTwoVC startAnimate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark SCFindPasswordStepTwoProtocol
-(void)submitSuccess
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SCLoginScrollViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
@end
