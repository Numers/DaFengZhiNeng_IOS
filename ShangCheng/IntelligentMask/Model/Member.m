//
//  Member.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "Member.h"

@implementation Member
-(Member *)initlizedWithDictionary:(NSDictionary *)dic
{
    Member *member = nil;
    if (dic) {
        member = [[Member alloc] init];
        member.token = [dic objectForKey:@"token"];
        member.mobilePhone = [dic objectForKey:@"mobilePhone"];
        member.time = [dic objectForKey:@"time"];
    }
    return member;
} 

-(NSDictionary *)dictionaryInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (_token) {
        [dic setObject:_token forKey:@"token"];
    }
    
    if (_time) {
        [dic setObject:_time forKey:@"time"];
    }
    
    if (_mobilePhone) {
        [dic setObject:_mobilePhone forKey:@"mobilePhone"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dic];
}
@end
