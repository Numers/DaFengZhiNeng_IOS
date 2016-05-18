//
//  SCAlipayManager.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCAlipayManager.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GlobalVar.h"

static SCAlipayManager *scAlipayManager;
@implementation SCAlipayManager
+(id)defaultManager
{
    if (scAlipayManager == nil) {
        scAlipayManager = [[SCAlipayManager alloc] init];
    }
    return scAlipayManager;
}

-(void)alipay:(NSString *)tradeNo WithProductName:(NSString *)productName WithProductDesc:(NSString *)productDesc WithMoney:(NSString *)money WithNotifyUrl:(NSString *)notifyUrl CallBack:(AlipayCallBack)callBack
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = tradeNo; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDesc; //商品描述
    order.amount = money; //商品价格
    order.notifyURL = notifyUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = APP_SCHEME;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:callBack];
    }
}
@end
