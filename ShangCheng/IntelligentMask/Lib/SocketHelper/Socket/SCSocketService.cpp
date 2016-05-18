//
//  SCSocketService.cpp
//  IntelligentMask
//
//  Created by baolicheng on 16/4/12.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#include "SCSocketService.hpp"
#include "SCClientSocket.hpp"
static FOnReceiveMessage *g_lpOnReceiveMessage = NULL;
SCClientSocket *scClientSocket = NULL;

static void _OnReceiveMessage(void *data, int len);
class MyClientSocketSink:public SCClientSocketSink {
public:
    void receiveData(void *data, int len)
    {
        _OnReceiveMessage(data, len);
    };
};

MyClientSocketSink *myClientSocketSink = NULL;

void init(FOnReceiveMessage *lpOnReceiveMessage)
{
    scClientSocket = new SCClientSocket();
    myClientSocketSink = new MyClientSocketSink();
    scClientSocket->_setClientSocketSink(myClientSocketSink);
    g_lpOnReceiveMessage = lpOnReceiveMessage;
}

int connect(char *ip, int port)
{
    return scClientSocket->_connect(ip, port);
}

int sendData(void *data, int dataLen)
{
    return scClientSocket->_writeCmd(data, dataLen);
}

static void _OnReceiveMessage(void *data, int len)
{
    if (g_lpOnReceiveMessage) {
        (*g_lpOnReceiveMessage)(data,len);
    }
}