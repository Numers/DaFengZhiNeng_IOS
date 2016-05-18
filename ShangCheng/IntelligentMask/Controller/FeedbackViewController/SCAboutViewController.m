//
//  SCAboutViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/24.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCAboutViewController.h"

@interface SCAboutViewController ()

@end

@implementation SCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"问题反馈"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickFeedbackBtn:(id)sender
{
    
}

@end
