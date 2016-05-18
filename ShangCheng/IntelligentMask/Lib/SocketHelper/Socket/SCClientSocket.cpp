//
//  SCClientSocket.cpp
//  IntelligentMask
//
//  Created by baolicheng on 16/4/12.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#include "SCClientSocket.hpp"
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <strings.h>
#include <stdlib.h>
static void* ThreadProc(void * param);

int SCClientSocket::_connect(char *ip, int port)
{
    m_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (m_socket < 0) {
        return -2;
    }
    
    char *sip = NULL;
    struct hostent *ent = gethostbyname(ip);
    if (ent) {
        if (ent->h_length > 0) {
            sip = ent->h_addr_list[0];
        }
    }
    
    if (sip == NULL) {
        return -3;
    }
    
    struct sockaddr_in s_addr;
    memset(&s_addr, 0, sizeof(s_addr));
    s_addr.sin_family = AF_INET;
    s_addr.sin_len = sizeof(s_addr);
    s_addr.sin_port = htons(port);
    s_addr.sin_addr=*(struct in_addr *)sip;
    int ret = connect(m_socket, (const struct sockaddr *)&s_addr, sizeof(s_addr));
    bool success = (ret == 0);
    if (success) {
        pthread_create(&thread, NULL, ThreadProc, this);
    }
    return ret;
}

static void * ThreadProc(void * param)
{
    SCClientSocket *clientSocket = (SCClientSocket *)param;
    while (true) {
        if (clientSocket->_getSocket() > 0) {
            char *buffer = (char *)malloc(1024);
            memset(buffer, 0, 1024);
            int len = recv(clientSocket->_getSocket(), buffer, 1024, 0);
            if (len <= 0) {
                break;
            }
            clientSocket->_getClientSocketSink()->receiveData(buffer, len);
            free(buffer);
        }else{
            break;
        }
    }
    return 0;
}

int SCClientSocket::_writeCmd(void *data, int dataLen)
{
    int ret = -1;
    if (m_socket > 0) {
        ret = send(m_socket, data, dataLen, 0);
    }
//    free(data);
    return ret;
}