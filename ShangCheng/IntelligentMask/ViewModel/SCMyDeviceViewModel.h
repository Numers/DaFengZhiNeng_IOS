//
//  SCMyDeviceViewModel.h
//  IntelligentMask
//
//  Created by baolicheng on 16/3/23.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCMyDeviceViewModel : NSObject
-(RACSignal *)requestMyDeviceSignal;
@end
