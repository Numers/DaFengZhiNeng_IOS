//
//  SCLocationHelper.h
//  IntelligentMask
//
//  Created by baolicheng on 16/1/20.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

#define LocationUpdateNotify @"LocationUpdateNotify"
#define WhetherInfoUpdateNotify @"WhetherInfoUpdateNotify"
@class Location,Whether;
@interface SCLocationHelper : NSObject<BMKLocationServiceDelegate>
{
    BMKLocationService *locationManager;
    Location *currentLocation;
    Whether *currentWhether;
    
    NSTimer *timer;
}
+(id)defaultHelper;
-(void)startLocationService;
-(Location *)returnCurrentLocation;
-(Whether *)returnCurrentWhether;
-(void)requestWhetherInfo;
@end
