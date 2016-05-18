//
//  Member.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *mobilePhone;
@property(nonatomic, copy) NSString *time;

-(Member *)initlizedWithDictionary:(NSDictionary *)dic;
-(NSDictionary *)dictionaryInfo;
@end
