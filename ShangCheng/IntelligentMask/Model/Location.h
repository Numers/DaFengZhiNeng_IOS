//
//  Location.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/20.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
@interface Location : NSObject
@property(nonatomic) float lat;
@property(nonatomic) float lng;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *cityName;
@end
