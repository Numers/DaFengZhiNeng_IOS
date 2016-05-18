//
//  SCAlipayManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AlipayCallBack)(NSDictionary *resultDic);
@interface SCAlipayManager : NSObject
+(id)defaultManager;
-(void)alipay:(NSString *)tradeNo WithProductName:(NSString *)productName WithProductDesc:(NSString *)productDesc WithMoney:(NSString *)money WithNotifyUrl:(NSString *)norifyUrl CallBack:(AlipayCallBack)callBack;
@end
