//
//  SCAliyunSyncStatusManager.h
//  IntelligentMask
//
//  Created by baolicheng on 16/3/31.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAliyunSyncStatusManager : NSObject
+(id)defaultManager;

-(void)requestStatus;
@end
