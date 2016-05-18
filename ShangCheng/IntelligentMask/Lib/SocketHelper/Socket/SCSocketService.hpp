//
//  SCSocketService.hpp
//  IntelligentMask
//
//  Created by baolicheng on 16/4/12.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#ifndef SCSocketService_hpp
#define SCSocketService_hpp

#include <stdio.h>
typedef void FOnReceiveMessage(void *data, int len);
void init(FOnReceiveMessage *lpOnReceiveMessage);
int connect(char *ip, int port);
int sendData(void *data, int dataLen);
#endif /* SCSocketService_hpp */
