//
//  SCLocationHelper.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/20.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCLocationHelper.h"
#import "SCWheatherManager.h"
#import "Location.h"
#import "Whether.h"
#import "Member.h"
#import "ZXAppStartManager.h"

#define TimeInterval 60.0f
static SCLocationHelper *scLocationHelper;
@implementation SCLocationHelper
+(id)defaultHelper
{
    if (scLocationHelper == nil) {
        scLocationHelper = [[SCLocationHelper alloc] init];
    }
    return scLocationHelper;
}

-(void)startLocationService
{
    if (currentLocation == nil) {
        currentLocation = [[Location alloc] init];
    }
    
    if (currentWhether == nil) {
        currentWhether = [[Whether alloc] init];
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未开启定位服务!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"App定位权限关闭,若允许，请到设置->隐私->定位服务中开启定位权限" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    //初始化BMKLocationService
    if (locationManager == nil) {
        locationManager = [[BMKLocationService alloc]init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [locationManager setDistanceFilter:1000.0f];
        locationManager.delegate = self;
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(startUpdateLocation) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)startUpdateLocation
{
    if (!locationManager) {
        locationManager = [[BMKLocationService alloc]init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [locationManager setDistanceFilter:1000.0f];
        locationManager.delegate = self;
    }
    [locationManager startUserLocationService];
}

-(Location *)returnCurrentLocation
{
    return currentLocation;
}
-(Whether *)returnCurrentWhether
{
    return currentWhether;
}

-(void)requestWhetherInfo
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (!host) {
        return;
    }
    [[SCWheatherManager defaultManager] requestWheatherInfoWithLocation:currentLocation Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if (resultDic) {
            NSDictionary *dataDic = [resultDic objectForKey:@"data"];
            if (dataDic) {
                currentWhether.indexCO = [dataDic objectForKey:@"CO"];
                currentWhether.indexO3 = [dataDic objectForKey:@"O3"];
                currentWhether.indexAQI = [dataDic objectForKey:@"AQI"];
                currentWhether.indexNO2 = [dataDic objectForKey:@"NO2"];
                currentWhether.indexSO2 = [dataDic objectForKey:@"SO2"];
                currentWhether.indexPM10 = [dataDic objectForKey:@"PM10"];
                currentWhether.location = currentLocation;
                [[NSNotificationCenter defaultCenter] postNotificationName:WhetherInfoUpdateNotify object:currentWhether];
            }
        }
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma -mark CLLocaitonManagerDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"%.2f,%.2f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    currentLocation.lat = userLocation.location.coordinate.latitude;
    currentLocation.lng = userLocation.location.coordinate.longitude;
    currentLocation.coordinate = userLocation.location.coordinate;
    [locationManager stopUserLocationService];
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateNotify object:currentLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *locality = placemark.locality;
            if (!locality) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                locality = placemark.administrativeArea;
            }
            NSString *currentCity = [locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
            //                        NSString *state = placemark.administrativeArea;
            //                        NSString *area = placemark.subLocality;
            currentLocation.cityName = currentCity;
            [self requestWhetherInfo];
        }
    }];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
    [locationManager stopUserLocationService];
}

@end
