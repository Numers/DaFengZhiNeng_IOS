//
//  CommonTools.h
//  renrenfenqi
//
//  Created by DY on 15/1/4.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppUtils.h"

@interface CommonTools : NSObject
// 压缩图片
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end
