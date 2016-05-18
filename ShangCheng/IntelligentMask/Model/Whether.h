//
//  Whether.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/20.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;
@interface Whether : NSObject
@property(nonatomic,copy) NSString *indexAQI;
@property(nonatomic,copy) NSString *indexPM10;
@property(nonatomic,copy) NSString *indexCO;
@property(nonatomic,copy) NSString *indexSO2;
@property(nonatomic,copy) NSString *indexNO2;
@property(nonatomic,copy) NSString *indexO3;
@property(nonatomic, strong) Location *location;
@end
