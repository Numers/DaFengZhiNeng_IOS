//
//  DataAnalizer.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "DataAnalizer.h"
@implementation DataAnalizer
-(id)init
{
    self = [super init];
    if (self) {
        dataIsCompletely = YES;
    }
    return self;
}

//校验返回数据是否正确
-(void)inputData:(NSData *)data
{
    if (!data || data.length == 0) {
        return;
    }
    
    if (dataIsCompletely) {
        dataIsCompletely = NO;
    }
    
    Byte* byte = (Byte *)[data bytes];
    Byte check = 0;
    for(int i=0; i < data.length - 1; i++){
        check += byte[i];
    }
    
    check &= 0x00FF;
    
    if (check == byte[data.length - 1]) {
        NSLog(@"%x,%x",check,byte[data.length - 1]);
        dataIsCompletely = YES;
    }
    
    if (dataIsCompletely) {
        if ([self.delegate respondsToSelector:@selector(outputData:)]) {
            [self.delegate outputData:data];
        }
    }
}
@end
