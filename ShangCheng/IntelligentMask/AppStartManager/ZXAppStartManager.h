//
//  ZXAppStartManager.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"
@class SCHomeViewController;
@interface ZXAppStartManager : NSObject
{
    Member *host;
    SCHomeViewController *scHomeVC;
}

@property(nonatomic, strong) UINavigationController *navigationController;
@property(nonatomic, strong) UITabBarController *tabBarController;

+(id)defaultManager;
-(Member *)currentHost;
-(void)setHostMember:(Member *)member;
-(void)pushHomeViewWithSelectIndex:(NSInteger)index;
-(void)startApp;
-(void)loginOut;
@end
