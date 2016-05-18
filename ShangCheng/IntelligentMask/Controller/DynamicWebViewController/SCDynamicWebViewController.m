//
//  SCDynamicWebViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCDynamicWebViewController.h"

@interface SCDynamicWebViewController ()<UIWebViewDelegate>
{
    NSString *theTitle;
    NSString *theUrl;
}
@property(nonatomic, strong)  UIWebView *webView;
@end

@implementation SCDynamicWebViewController
-(id)initWithTitle:(NSString *)title WithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        theTitle = title;
        theUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:theTitle];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, UIScreenMainFrame.size.width, UIScreenMainFrame.size.height - 64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0f];
    [_webView loadRequest:request];
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
    [AppUtils showProgressBarForView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [AppUtils hideProgressBarForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [AppUtils hideProgressBarForView:self.view];
    [AppUtils showInfo:@"加载失败"];
}


@end
