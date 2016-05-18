//
//  SCMyOrderViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCMyOrderViewController.h"
#import "ZXAppStartManager.h"
#import "GlobalVar.h"
#import "SCShopMailWebJsBridge.h"

@interface SCMyOrderViewController ()<UIWebViewDelegate,SCShopMailWebJsBridgeProtocol>
{
    Member *host;
    SCShopMailWebJsBridge *bridge;
}
@property(nonatomic, strong) IBOutlet UIWebView *webView;
@property(nonatomic, strong) IBOutlet UIButton *btnRefresh;
@end

@implementation SCMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    host = [[ZXAppStartManager defaultManager] currentHost];
    bridge = [SCShopMailWebJsBridge bridgeForWebView:_webView webViewDelegate:self];
    bridge.delegate = self;
    [self loadOrderPage];
}


-(void)loadOrderPage
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_SHOPBASE,SC_MyOrder_API]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0f];
    [_webView loadRequest:request];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"我的订单"];
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
        NSString *absoluteString = [[_webView.request URL] absoluteString];
        if ([_webView canGoBack]) {
            NSRange range1 = [absoluteString rangeOfString:@"order_list.html"];
            if (range1.length > 0){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [_webView goBack];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(IBAction)clickRefreshBtn:(id)sender
{
    [_webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            if (host) {
                NSString *jsStr = [NSString stringWithFormat:@"setTokenInfo('%@','%@')",host.mobilePhone,host.token];
                [webView stringByEvaluatingJavaScriptFromString:jsStr];
            }
        }
    }else{
        [self showBackItem];
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
    [self.navigationController popViewControllerAnimated:NO];
    [[[ZXAppStartManager defaultManager] tabBarController] setSelectedIndex:1];
}

-(void)goOrderPage
{
//    [[[ZXAppStartManager defaultManager] tabBarController] setSelectedIndex:2];
    [self loadOrderPage];
}

-(void)goLoginPage
{
    [[ZXAppStartManager defaultManager] loginOut];
}

-(void)isAlipay:(NSString *)payUrl WithCallBackUrl:(NSString *)callBackUrl
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payUrl]]];
}
@end
