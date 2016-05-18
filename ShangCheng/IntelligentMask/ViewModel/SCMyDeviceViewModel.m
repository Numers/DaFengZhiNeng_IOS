//
//  SCMyDeviceViewModel.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/23.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCMyDeviceViewModel.h"

@implementation SCMyDeviceViewModel
-(RACSignal *)requestMyDeviceSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"获取我的设备signal销毁");
        }];
    }];
}
@end
