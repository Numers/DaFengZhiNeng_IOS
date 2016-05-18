//
//  SCHomeViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/14.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCHomeViewController.h"
#import "SCHomeCategoryTableViewController.h"
#import "SCAliyunSyncStatusManager.h"
#import "SCFeedbackManager.h"

#define ScrollViewBottomMargin 48.0f

@interface SCHomeViewController ()<UIScrollViewDelegate>
{
    NSMutableArray *viewControllerArray;
}
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property(nonatomic, strong) SCHomeCategoryTableViewController *scHomePMCategoryTableVC;
@property(nonatomic, strong) SCHomeCategoryTableViewController *scHomeTemperatureCategoryTableVC;
@property(nonatomic, strong) SCHomeCategoryTableViewController *scHomeHumidityCategoryTableVC;
@end

@implementation SCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage * backgroundImg = [UIImage imageNamed:@"Home_BackgroundImage"];
    self.view.layer.contents = (id) backgroundImg.CGImage;
    [[SCAliyunSyncStatusManager defaultManager] requestStatus];
    self.homeViewModel = [[SCHomeViewModel alloc] init];
    [self.homeViewModel startBluetoothManager];
    [[SCConfigHelper defaultHelper] requestConfigInfo];
    
    self.scHomePMCategoryTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeCategoryViewIdentify"];
    self.scHomeTemperatureCategoryTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeCategoryViewIdentify"];
    self.scHomeHumidityCategoryTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeCategoryViewIdentify"];
    
    viewControllerArray = [NSMutableArray array];
    [viewControllerArray addObject:self.scHomePMCategoryTableVC];
    [viewControllerArray addObject:self.scHomeTemperatureCategoryTableVC];
    [viewControllerArray addObject:self.scHomeHumidityCategoryTableVC];
    
    [self setScrollViewContents];
    
    [RACObserve(self.homeViewModel, airIndex) subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)x;
            NSNumber *pmValue = [data objectForKey:@"Pm"];
            [self.scHomePMCategoryTableVC setAirIndex:pmValue];
            NSNumber *tmValue = [data objectForKey:@"Te"];
            [self.scHomeTemperatureCategoryTableVC setAirIndex:tmValue];
            NSNumber *hmValue = [data objectForKey:@"Hm"];
            [self.scHomeHumidityCategoryTableVC setAirIndex:hmValue];
        }
        
    }];
    
    [[self.homeViewModel.storyPMValueSignal subscribeNext:^(id x) {
        [self.scHomePMCategoryTableVC setXLabelValues:[x objectForKey:@"x"] WithYLabelValues:[x objectForKey:@"y"]];
    } error:^(NSError *error) {
        
    } completed:^{
        
    }] dispose];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[SCFeedbackManager defaultManager] submitFeedback:@"1" WithFeedbackContent:@"hahfha" Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)setScrollViewContents
{
    if (viewControllerArray.count == 0) {
        return;
    }
    NSLog(@"%lf,%lf",UIScreenMainFrame.size.width,UIScreenMainFrame.size.height);
    NSInteger i = 0;
    for (UIViewController *vc in viewControllerArray) {
        vc.view.frame = CGRectMake(UIScreenMainFrame.size.width * i, -20, UIScreenMainFrame.size.width, UIScreenMainFrame.size.height - ScrollViewBottomMargin);
        NSLog(@"%lf,%lf",vc.view.frame.size.width,vc.view.frame.size.height);
        [self.scrollView addSubview:vc.view];
        i++;
    }
    [self.scrollView setContentSize:CGSizeMake(UIScreenMainFrame.size.width * viewControllerArray.count, 0)];
    [self.pageControl setNumberOfPages:viewControllerArray.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIScrollViewDelegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
@end
