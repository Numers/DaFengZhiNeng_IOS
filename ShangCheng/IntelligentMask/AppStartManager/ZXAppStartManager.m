//
//  ZXAppStartManager.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXAppStartManager.h"
#import "RFGeneralManager.h"
#import "AppDelegate.h"
#import "AppUtils.h"
#import "SCGuidViewController.h"
#import "SCLoginScrollViewController.h"
#import "SCHomeViewController.h"
#import "SCPersonalViewController.h"
#import "SCDeviceSettingViewController.h"

#import "BluetoothMacManager.h"
#define HostProfilePlist @"PersonProfile.plist"
static ZXAppStartManager *manager;
@implementation ZXAppStartManager
+(id)defaultManager
{
    if (manager == nil) {
        manager = [[ZXAppStartManager alloc] init];
    }
    return manager;
}

-(Member *)currentHost
{
    if (host == nil) {
        host = [self getProfileFromPlist];
    }
    return host;
}

-(void)setHostMember:(Member *)member
{
    if (member) {
        host = member;
        [self saveProfileToPlist];
    }
}

-(void)removeLocalHostMemberData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    host = nil;
}

-(void)saveProfileToPlist
{
    NSDictionary *dic = [host dictionaryInfo];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    [dic writeToFile:selfInfoPath atomically:YES];
}

-(Member *)getProfileFromPlist
{
    Member *member = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:selfInfoPath];
        if (dic != nil) {
            member = [[Member alloc] initlizedWithDictionary:dic];
        }
    }
    return member;
}

-(void)startApp
{
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.722 green:0.914 blue:0.525 alpha:1.000]];
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.722 green:0.914 blue:0.525 alpha:1.000]];
//    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:0.722 green:0.914 blue:0.525 alpha:1.000]];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"BackItemImage"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"BackItemImage"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[RFGeneralManager defaultManager] getGlovalVarWithVersion];
    [self currentHost];
    if (host) {
        NSString *autoLogin = [AppUtils localUserDefaultsForKey:KMY_AutoLogin];
        if ([autoLogin isEqualToString:@"1"]) {
            [self setHomeView];
        }else{
            [self setLoginView];
        }
    }else{
//        [self setGuidView];
        [self setLoginView];
    }
}

-(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setHomeView
{
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController.tabBar setTranslucent:NO];
    [_tabBarController.navigationItem setHidesBackButton:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    scHomeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewIdentify"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:scHomeVC];
    SCDeviceSettingViewController *scDeviceSettingVC = [storyboard instantiateViewControllerWithIdentifier:@"DeviceSettingViewIdentify"];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:scDeviceSettingVC];
    SCPersonalViewController *scPersonalVC = [storyboard instantiateViewControllerWithIdentifier:@"PersonalViewIdentify"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:scPersonalVC];
    _tabBarController.viewControllers = @[nav1,nav2,nav3];
    UITabBar *tabBar = _tabBarController.tabBar;
//    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
//    [item1 setImage:[[UIImage imageNamed:@"HomeTabBarUnselectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item1 setSelectedImage:[[UIImage imageNamed:@"HomeTabBarSelectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
//    [item2 setImage:[[UIImage imageNamed:@"ShangChengTabBarUnselectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item2 setSelectedImage:[[UIImage imageNamed:@"ShangChengTabBarSelectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
//    [item3 setImage:[[UIImage imageNamed:@"PersonalTabBarUnselectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item3 setSelectedImage:[[UIImage imageNamed:@"PersonalTabBarSelectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    [item1 setImage:[UIImage imageNamed:@"HomeTabBarUnselectImage"]];
    [item1 setSelectedImage:[UIImage imageNamed:@"HomeTabBarSelectImage"]];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    [item2 setImage:[UIImage imageNamed:@"ShangChengTabBarUnselectImage"]];
    [item2 setSelectedImage:[UIImage imageNamed:@"ShangChengTabBarSelectImage"]];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    [item3 setImage:[UIImage imageNamed:@"PersonalTabBarUnselectImage"]];
    [item3 setSelectedImage:[UIImage imageNamed:@"PersonalTabBarSelectImage"]];
    item1.title = @"设备指数";
    item2.title = @"设备设置";
    item3.title = @"我的";
    [_tabBarController setSelectedIndex:0];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_tabBarController];
}

-(void)pushHomeViewWithSelectIndex:(NSInteger)index
{
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController.tabBar setTranslucent:NO];
    [_tabBarController.navigationItem setHidesBackButton:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    scHomeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewIdentify"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:scHomeVC];
    SCDeviceSettingViewController *scDeviceSettingVC = [storyboard instantiateViewControllerWithIdentifier:@"DeviceSettingViewIdentify"];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:scDeviceSettingVC];
    SCPersonalViewController *scPersonalVC = [storyboard instantiateViewControllerWithIdentifier:@"PersonalViewIdentify"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:scPersonalVC];
    _tabBarController.viewControllers = @[nav1,nav2,nav3];
    UITabBar *tabBar = _tabBarController.tabBar;
//    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
//    [item1 setImage:[[UIImage imageNamed:@"HomeTabBarUnselectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item1 setSelectedImage:[[UIImage imageNamed:@"HomeTabBarSelectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
//    [item2 setImage:[[UIImage imageNamed:@"ShangChengTabBarUnselectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item2 setSelectedImage:[[UIImage imageNamed:@"ShangChengTabBarSelectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
//    [item3 setImage:[[UIImage imageNamed:@"PersonalTabBarUnselectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item3 setSelectedImage:[[UIImage imageNamed:@"PersonalTabBarSelectImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    [item1 setImage:[UIImage imageNamed:@"HomeTabBarUnselectImage"]];
    [item1 setSelectedImage:[UIImage imageNamed:@"HomeTabBarSelectImage"]];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    [item2 setImage:[UIImage imageNamed:@"ShangChengTabBarUnselectImage"]];
    [item2 setSelectedImage:[UIImage imageNamed:@"ShangChengTabBarSelectImage"]];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    [item3 setImage:[UIImage imageNamed:@"PersonalTabBarUnselectImage"]];
    [item3 setSelectedImage:[UIImage imageNamed:@"PersonalTabBarSelectImage"]];
    item1.title = @"设备指数";
    item2.title = @"设备设置";
    item3.title = @"我的";
    [_tabBarController setSelectedIndex:index];
    [_navigationController pushViewController:_tabBarController animated:YES];
}



-(void)setGuidView
{
    SCGuidViewController *zxGuidVC = [[SCGuidViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:zxGuidVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
}

-(void)setLoginView
{
    SCLoginScrollViewController *zxLoginScrollVC = [[SCLoginScrollViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:zxLoginScrollVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
}

-(void)loginOut
{
    if (scHomeVC) {
        if (scHomeVC.homeViewModel) {
            [scHomeVC.homeViewModel removeAllSignal];
        }
    }
    [[BluetoothMacManager defaultManager] stopBluetoothDevice];
    [_navigationController popToRootViewControllerAnimated:NO];
    _navigationController = nil;
    [self setLoginView];
    [AppUtils localUserDefaultsValue:@"0" forKey:KMY_AutoLogin];
}
@end
