//
//  SCMapViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCMapViewController.h"
#import "UINavigationController+PHNavigationController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "SCAnnotation.h"
#import <BaiduMapAPI_Map/BMKPolygon.h>
#import "SCLocationHelper.h"
#import "Location.h"

#import "SCAnnotationView.h"
#import "SCUserLocationAnnotationView.h"

#import "SCMapManager.h"
#import "ZXAppStartManager.h"

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

static NSString *annotationReuseIdentify = @"AnnotationReuseIdentify";
static NSString *userLocationAnnotationReuseIdentify = @"UserLocationAnnotationReuseIdentify";
@interface SCMapViewController ()<BMKMapViewDelegate>
{
    NSMutableArray *annotationList;
    NSString *userLocaitonPmValue;
    Location *userLocation;
    SCAnnotation *userLocationAnnotation;
    
    BOOL isRefreshing;
}
@property(nonatomic, strong) BMKMapView *mapView;
@end

@implementation SCMapViewController
-(id)initWithDevicePMValue:(NSString *)pmValue
{
    self = [super init];
    if (self) {
        userLocaitonPmValue = pmValue;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    annotationList = [NSMutableArray array];
    _mapView = [[BMKMapView alloc] init];
    _mapView.delegate = self;
    [_mapView setShowsUserLocation:YES];
    self.view = _mapView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshRegionPM)];
    [UIDevice adaptUIBarButtonItemTextFont:rightItem WithIphone5FontSize:12.0f];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self refreshRegionPM];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationViewColor:[UIColor colorWithRed:0.000 green:0.722 blue:0.933 alpha:1.000]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocationInfo:) name:LocationUpdateNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pmValueChange:) name:UserLocationPMValueChangeNotify object:nil];
    [self setTitle:@"我的位置"];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LocationUpdateNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserLocationPMValueChangeNotify object:nil];
}

-(void)refreshRegionPM
{
    if (isRefreshing) {
        return;
    }
    
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (!host) {
        return;
    }
    
    Location *uLocation = [[SCLocationHelper defaultHelper] returnCurrentLocation];
    if (!uLocation) {
        return;
    }
    
    if (annotationList.count > 0) {
        [_mapView removeAnnotations:annotationList];
        [annotationList removeAllObjects];
    }
    
    isRefreshing = YES;
    userLocation = uLocation;
    SCAnnotation *uAnnotation = [[SCAnnotation alloc] init];
    [uAnnotation setCoordinate:uLocation.coordinate];
    uAnnotation.pmValue = userLocaitonPmValue;
    userLocationAnnotation = uAnnotation;
    [annotationList addObject:userLocationAnnotation];
    
    [[SCMapManager defaultManager] requestRegionPMData:host WithLocation:uLocation Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if (resultDic) {
            NSArray *dataArr = [resultDic objectForKey:@"data"];
            if (dataArr && dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    SCAnnotation *annotation = [[SCAnnotation alloc] init];
                    float lat = [[dic objectForKey:@"latitude"] floatValue];
                    float lng = [[dic objectForKey:@"longitude"] floatValue];
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
                    [annotation setCoordinate:coordinate];
                    annotation.pmValue = [dic objectForKey:@"pm_data"];
                    [annotationList addObject:annotation];
                }
            }
        }
        [_mapView addAnnotations:annotationList];
        [self zoomMapViewToFitAnnotations:_mapView animated:YES];
        isRefreshing = NO;
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_mapView addAnnotations:annotationList];
        [self zoomMapViewToFitAnnotations:_mapView animated:YES];
        isRefreshing = NO;
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_mapView addAnnotations:annotationList];
        [self zoomMapViewToFitAnnotations:_mapView animated:YES];
        isRefreshing = NO;
    }];
}

-(void)pmValueChange:(NSNotification *)notify
{
    NSString *pmvalue = [notify object];
    userLocaitonPmValue = pmvalue;
    if (userLocationAnnotation) {
        [_mapView removeAnnotation:userLocationAnnotation];
        userLocationAnnotation.pmValue = pmvalue;
        [_mapView addAnnotation:userLocationAnnotation];
    }
}

-(void)setUserLocationAnnotation:(Location *)location
{
    if (location) {
        if (userLocationAnnotation) {
            [_mapView removeAnnotation:userLocationAnnotation];
            if ([annotationList containsObject:userLocationAnnotation]) {
                [annotationList removeObject:userLocationAnnotation];
            }
        }
        userLocation = location;
        SCAnnotation *annotation = [[SCAnnotation alloc] init];
        [annotation setCoordinate:location.coordinate];
        annotation.pmValue = userLocaitonPmValue;
        userLocationAnnotation = annotation;
        [annotationList addObject:userLocationAnnotation];
        [_mapView addAnnotation:annotation];
        [_mapView setCenterCoordinate:location.coordinate animated:YES];
    }
}

-(void)updateLocationInfo:(NSNotification *)notify
{
    id obj = [notify object];
    if ([obj isKindOfClass:[Location class]]) {
        Location *currentLocation = (Location *)obj;
        [self performSelectorOnMainThread:@selector(setUserLocationAnnotation:) withObject:currentLocation waitUntilDone:NO];
    }
}

//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(BMKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    NSInteger count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    BMKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <BMKAnnotation>)[annotations objectAtIndex:i] coordinate];
        CGPoint point = [mapView convertCoordinate:coordinate toPointToView:mapView];
        BMKMapPoint mapPoint;
        mapPoint.x = point.x;
        mapPoint.y = point.y;
        points[i] = mapPoint;
    }
    //create MKMapRect from array of MKMapPoint
    BMKMapRect mapRect = [[BMKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    BMKCoordinateRegion region = [mapView convertRect:CGRectMake(mapRect.origin.x, mapRect.origin.y, mapRect.size.width, mapRect.size.height) toRegionFromView:mapView];
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(UIColor *)fillColorWithValue:(float)value WithAlpha:(float)alpha
//{
//    UIColor *color = [UIColor clearColor];
//    if (value < 0) {
//        return color;
//    }
//    
//    if (value >=0.0f && value < 35.0f) {
//        float red = 160 + value;
//        color = [UIColor colorWithRed:red/255.0f green:233/255.0f blue:255/255.0f alpha:alpha];
//        return color;
//    }
//    
//    if (value >= 35.0f && value < 75.0f) {
//        float red = 2 + value - 35.0f;
//        color = [UIColor colorWithRed:red/255.0f green:168/255.0f blue:253/255.0f alpha:alpha];
//        return color;
//    }
//    
//    if (value >= 75.0f && value < 115.0f) {
//        float red = 126 + value - 75.0f;
//        color = [UIColor colorWithRed:red/255.0f green:211/255.0f blue:33/255.0f alpha:alpha];
//        return color;
//    }
//    
//    if (value >= 115.0f && value < 150.0f) {
//        float red = 200 + value - 115.0f;
//        color = [UIColor colorWithRed:red/255.0f green:208/255.0f blue:51/255.0f alpha:alpha];
//        return color;
//    }
//    
//    if (value >= 150.0f && value < 250.0f) {
//        float red = 25 + value - 150.0f;
//        color = [UIColor colorWithRed:red/255.0f green:102/255.0f blue:0/255.0f alpha:alpha];
//        return color;
//    }
//    
//    if (value >= 250.0f && value < 500.0f) {
//        float blue = value - 250.0f;
//        [UIColor colorWithRed:0.969 green:0.118 blue:1.000 alpha:1.000];
//        color = [UIColor colorWithRed:247/255.0f green:30/255.0f blue:blue/255.0f alpha:alpha];
//        return color;
//    }
//    
//    if (value >= 500.0f) {
//        color = [UIColor colorWithRed:195/255.0f green:1/255.0f blue:151/255.0f alpha:alpha];
//        return color;
//    }
//    
//    return color;
//}

-(UIColor *)fillColorWithValue:(float)value WithAlpha:(float)alpha
{
    UIColor *color = [UIColor clearColor];
    if (value < 0) {
        return color;
    }
    
    if (value >=0.0f && value < 35.0f) {
        color = [UIColor colorWithRed:160/255.0f green:223/255.0f blue:255/255.0f alpha:alpha];
        return color;
    }
    
    if (value >= 35.0f && value < 75.0f) {
        color = [UIColor colorWithRed:2/255.0f green:168/255.0f blue:253/255.0f alpha:alpha];
        return color;
    }
    
    if (value >= 75.0f && value < 115.0f) {
        color = [UIColor colorWithRed:126/255.0f green:211/255.0f blue:33/255.0f alpha:alpha];
        return color;
    }
    
    if (value >= 115.0f && value < 150.0f) {
        color = [UIColor colorWithRed:253/255.0f green:208/255.0f blue:51/255.0f alpha:alpha];
        return color;
    }
    
    if (value >= 150.0f && value < 250.0f) {
        color = [UIColor colorWithRed:25/255.0f green:102/255.0f blue:0/255.0f alpha:alpha];
        return color;
    }
    
    if (value >= 250.0f && value < 500.0f) {
        color = [UIColor colorWithRed:247/255.0f green:30/255.0f blue:8/255.0f alpha:alpha];
        return color;
    }
    
    if (value >= 500.0f) {
        color = [UIColor colorWithRed:195/255.0f green:1/255.0f blue:151/255.0f alpha:alpha];
        return color;
    }
    
    return color;
}


#pragma -mark BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    SCAnnotation *scAnnotation = (SCAnnotation *)annotation;
    if ([scAnnotation isEqual:userLocationAnnotation]) {
        SCUserLocationAnnotationView *scUserLocationAnnotationView = (SCUserLocationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationAnnotationReuseIdentify];
        if (scUserLocationAnnotationView == nil) {
            scUserLocationAnnotationView = [[SCUserLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationAnnotationReuseIdentify];
            [scUserLocationAnnotationView inilizeView];
            [scUserLocationAnnotationView setCenterOffset:CGPointMake(0, 0)];
            scUserLocationAnnotationView.draggable = NO;
        }
        UIColor *fillColor = [self fillColorWithValue:[scAnnotation.pmValue floatValue] WithAlpha:1.0f];
        [scUserLocationAnnotationView setupAnnotationView:scAnnotation.pmValue WithFillColor:fillColor];
        return scUserLocationAnnotationView;
    }else{
        SCAnnotationView *annotationView = (SCAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationReuseIdentify];
        if (annotationView == nil) {
            annotationView = [[SCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationReuseIdentify];
            [annotationView inilizeView];
            annotationView.draggable = NO;
        }
        UIColor *fillColor = [self fillColorWithValue:[scAnnotation.pmValue floatValue] WithAlpha:1.0f];
        [annotationView setupAnnotationView:scAnnotation.pmValue WithBackgroundColor:fillColor];
        return annotationView;
    }
    return [BMKAnnotationView new];
}

//- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
//{
//    [self zoomMapViewToFitAnnotations:mapView animated:YES];
//}
@end
