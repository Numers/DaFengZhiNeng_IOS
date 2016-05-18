//
//  BridgeFunction.h
//  GuoZhongBao
//
//  Created by baolicheng on 15/7/2.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import "WebViewJsBridge.h"
@protocol RedPacketDelegate <NSObject>
-(void)clickShareFromJs:(NSArray *)parameters;
@end
@interface BridgeFunction : WebViewJsBridge
@property(nonatomic,assign) id<RedPacketDelegate> delegate;
@end
