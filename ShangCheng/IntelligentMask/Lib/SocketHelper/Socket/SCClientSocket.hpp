//
//  SCClientSocket.hpp
//  IntelligentMask
//
//  Created by baolicheng on 16/4/12.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#ifndef SCClientSocket_hpp
#define SCClientSocket_hpp

#include <stdio.h>
#include <pthread/pthread.h>
class SCClientSocketSink{
public:
    virtual void receiveData(void *data, int len) = 0;
};


class SCClientSocket
{
private:
    int m_socket;
    pthread_t thread;
    SCClientSocketSink *m_pSCClientSocketSink;
public:
    void _setClientSocketSink(SCClientSocketSink *pSCClientSocketSink){m_pSCClientSocketSink = pSCClientSocketSink;};
    int _getSocket(){return m_socket;};
    SCClientSocketSink *_getClientSocketSink(){return m_pSCClientSocketSink;};
    int _connect(char *ip, int port);
    int _writeCmd(void *data, int dataLen);
};
#endif /* SCClientSocket_hpp */
