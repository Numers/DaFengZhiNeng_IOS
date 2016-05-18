//
//  SCAnnotation.h
//  IntelligentMask
//
//  Created by baolicheng on 16/2/1.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
@interface SCAnnotation : BMKPointAnnotation
@property(nonatomic, copy) NSString *pmValue;
@end
