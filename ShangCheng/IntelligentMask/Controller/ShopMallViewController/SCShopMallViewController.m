//
//  SCShopMallViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCShopMallViewController.h"
#import "UINavigationController+PHNavigationController.h"
#import "GlobalVar.h"
#import "SCShopMailWebJsBridge.h"
#import "ZXAppStartManager.h"
#import "SCAlipayManager.h"

#import "SCMyOrderViewController.h"

@interface SCShopMallViewController ()<UIWebViewDelegate,SCShopMailWebJsBridgeProtocol>
{
    Member *host;
    SCShopMailWebJsBridge *bridge;
}
@property(nonatomic, strong) IBOutlet UIWebView *webView;
@property(nonatomic, strong) IBOutlet UIButton *btnRefresh;
@end

@implementation SCShopMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:YES];
    host = [[ZXAppStartManager defaultManager] currentHost];
    bridge = [SCShopMailWebJsBridge bridgeForWebView:_webView webViewDelegate:self];
    bridge.delegate = self;
    [self loadHomePage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[SCAlipayManager defaultManager] alipay:@"11" WithProductName:@"22" WithProductDesc:@"22" WithMoney:@"0.01" WithNotifyUrl:[NSString stringWithFormat:@"%@/wap/tmpl/intelligentmask/failed.html",API_SHOPBASE] CallBack:^(NSDictionary *resultDic) {
//        
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadHomePage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",API_SHOPBASE,SC_ShopIndex_API,@"100010"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0f];
    [_webView loadRequest:request];
}

-(IBAction)clickRefreshBtn:(id)sender
{
    [_webView reload];
}

-(void)showBackItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackItemImage"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem]];
}

-(void)back
{
    if(_webView != nil){
        if ([_webView canGoBack]) {
            [_webView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma -mark  WebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *absoluteString = [[request URL] absoluteString];
    if ([absoluteString hasPrefix:@"tel:"]) {
        return YES;
    }
    if (![absoluteString hasPrefix:@"http"]) {
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.btnRefresh setHidden:YES];
    [AppUtils showProgressBarForView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *absoluteString = [[webView.request URL] absoluteString];
    NSRange range = [absoluteString rangeOfString:@"product_detail.html"];
    NSRange range2 = [absoluteString rangeOfString:@"call_back_url.php"];
    if (range.length > 0 || range2.length > 0) {
        [self.navigationItem setLeftBarButtonItems:nil];
        if (range.length > 0) {
//            [self.navigationController setNavigationBarHidden:YES];
            if (host) {
                NSString *jsStr = [NSString stringWithFormat:@"setTokenInfo('%@','%@')",host.mobilePhone,host.token];
                [webView stringByEvaluatingJavaScriptFromString:jsStr];
            }
        }else{
//            [self.navigationController setNavigationBarHidden:NO];
        }
    }else{
        [self showBackItem];
//        [self.navigationController setNavigationBarHidden:NO];
    }
    
    NSRange range1 = [absoluteString rangeOfString:@"order_list.html"];
    if (range1.length > 0) {
        if (host) {
            NSString *jsStr = [NSString stringWithFormat:@"setTokenInfo('%@','%@')",host.mobilePhone,host.token];
            [webView stringByEvaluatingJavaScriptFromString:jsStr];
        }
    }
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ((title != nil) && (title.length > 0)) {
        [self.navigationItem setTitle:title];
    }
    [AppUtils hideProgressBarForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.btnRefresh setHidden:NO];
    [AppUtils hideProgressBarForView:self.view];
    [AppUtils showInfo:@"加载失败"];
}

#pragma -mark SCShopMailWebJsBridgeProtocol
-(void)goBackHomePage
{
    [self loadHomePage];
}

-(void)goOrderPage
{
    [self loadHomePage];
    [[[ZXAppStartManager defaultManager] tabBarController] setSelectedIndex:2];
    SCMyOrderViewController *scMyOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrderViewIdentify"];
    scMyOrderVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[[[ZXAppStartManager defaultManager] tabBarController] viewControllers] objectAtIndex:2];
    [nav pushViewController:scMyOrderVC animated:YES];
}

-(void)goLoginPage
{
    [[ZXAppStartManager defaultManager] loginOut];
}

-(void)isAlipay:(NSString *)payUrl WithCallBackUrl:(NSString *)callBackUrl
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payUrl]]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payUrl]];
}
@end
