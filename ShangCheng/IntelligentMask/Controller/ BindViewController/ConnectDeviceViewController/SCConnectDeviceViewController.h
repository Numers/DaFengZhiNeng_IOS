//
//  SCConnectDeviceViewController.h
//  IntelligentMask
//
//  Created by baolicheng on 16/3/25.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ConnectDeviceViewProtocol <NSObject>
-(void)searchAgainOperation;
@end
@interface SCConnectDeviceViewController : UIViewController
@property(nonatomic, assign) id<ConnectDeviceViewProtocol> delegate;
@property(nonatomic, strong) NSArray *peripheralDicList;
@end
