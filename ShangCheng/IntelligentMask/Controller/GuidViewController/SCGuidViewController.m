//
//  SCGuidViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCGuidViewController.h"
#import "PHMyGuidView.h"
#import "SCLoginScrollViewController.h"
@interface SCGuidViewController ()<PHMyGuidViewDelegate>

@end

@implementation SCGuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self buildIntro];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildIntro{
    //Add panels to an array
    UIImage *image1 = [UIImage imageNamed:@"FirstGuidPicture"];
    UIImage *image2 = [UIImage imageNamed:@"SecondGuidPicture"];
    UIImage *image3 = [UIImage imageNamed:@"ThirdGuidPicture"];
    NSArray *panels = [NSArray arrayWithObjects:image1,image2,image3, nil];
    PHMyGuidView *phMyGuidView = [[PHMyGuidView alloc] initWithFrame:self.view.frame];
    phMyGuidView.delegate = self;
    [phMyGuidView setPanelList:panels];
    [self.view addSubview:phMyGuidView];
}

#pragma mark - MYIntroduction Delegate
-(void)skipGuidView
{
    SCLoginScrollViewController *zxLoginScrollVC = [[SCLoginScrollViewController alloc] init];
    [self.navigationController pushViewController:zxLoginScrollVC animated:YES];
}

@end
