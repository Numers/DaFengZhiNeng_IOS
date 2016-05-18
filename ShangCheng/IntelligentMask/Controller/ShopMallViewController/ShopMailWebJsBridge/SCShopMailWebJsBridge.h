//
//  SCShopMailWebJsBridge.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "WebViewJsBridge.h"
@protocol SCShopMailWebJsBridgeProtocol <NSObject>
-(void)goBackHomePage;
-(void)goOrderPage;
-(void)goLoginPage;
-(void)isAlipay:(NSString *)payUrl WithCallBackUrl:(NSString *)callBackUrl;
@end
@interface SCShopMailWebJsBridge : WebViewJsBridge
@property(nonatomic, assign) id<SCShopMailWebJsBridgeProtocol> delegate;
@end
