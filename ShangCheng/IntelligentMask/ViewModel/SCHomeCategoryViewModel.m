//
//  SCHomeCategoryViewModel.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/17.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCHomeCategoryViewModel.h"
@implementation SCHomeCategoryViewModel
-(NSDictionary *)airQualityDictionary
{
    NSDictionary *dic = nil;
    int index = [self.airIndex intValue];
    if (index > 0 && index < 60) {
        dic = @{@"color":[UIColor yellowColor],@"desc":@"轻度污染"};
    }else{
        dic = @{@"color":[UIColor redColor],@"desc":@"重度污染"};
    }
    return dic;
}
@end
