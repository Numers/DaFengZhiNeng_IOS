//
//  SCHomeCategoryViewModel.h
//  IntelligentMask
//
//  Created by baolicheng on 16/3/17.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHomeCategoryViewModel : NSObject
@property(nonatomic, strong) NSNumber *airIndex;


-(NSDictionary *)airQualityDictionary;
@end
