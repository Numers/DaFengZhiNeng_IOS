//
//  SocketHelper.m
//  IntelligentMask
//
//  Created by baolicheng on 16/4/11.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SocketHelper.h"
#import "AsyncSocket.h"
#import "SocketProtocol.h"
static SocketHelper *socketHelper;
@interface SocketHelper()<AsyncSocketDelegate>
{
    NSTimer *testTimer;
    
    NSString *connectIP;
    UInt16 connectPort;
}
@property(nonatomic, strong) AsyncSocket *socket;
@end
@implementation SocketHelper
+(id)defaultHelper
{
    if (socketHelper == nil) {
        socketHelper = [[SocketHelper alloc] init];
    }
    return socketHelper;
}

/**
 *  @author RenRenFenQi, 16-04-29 16:04:33
 *
 *  连接服务器
 *
 *  @param ip   服务器ip地址
 *  @param port 服务器端口
 */
-(void)connectToIP:(NSString *)ip WithPort:(UInt16)port
{
    NSString *macAddress = [AppUtils localUserDefaultsForKey:KMY_DeviceMacAddress];
    if (!macAddress) {
        return;
    }
    
    if (self.socket == nil) {
        self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    NSError *error = nil;
    connectIP = ip;
    connectPort = port;
    [self.socket connectToHost:ip onPort:port withTimeout:3 error:&error];
}

/**
 *  @author RenRenFenQi, 16-04-29 16:04:01
 *
 *  发送订阅、断开连接、获取消息指令
 *
 *  @param command 指令类型
 */
-(void)sendMessage:(CommandQueue)command
{
    NSString *macAddress = [AppUtils localUserDefaultsForKey:KMY_DeviceMacAddress];
    if (macAddress) {
        switch (command) {
            case CommandSubcribe:
            {
                if ([self.socket isConnected]) {
                    NSString *msg = [SocketProtocol commandSubcribeMessageQueue:macAddress];
                    [self.socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:1 tag:1];
                }
            }
                break;
            case CommandDisconnect:
            {
                if ([self.socket isConnected]) {
                    NSString *msg = [SocketProtocol commandExitQueue:macAddress];
                    [self.socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:1 tag:1];
                }
            }
                break;
            case CommandGetMessage:
            {
                if ([self.socket isConnected]) {
                    NSString *msg = [SocketProtocol commandGetMessageFromQueue:macAddress Message:@"DeviceInfo"];
                    [self.socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:1 tag:1];
                }
            }
                break;
            case CommandSendMessage:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}

/**
 *  @author RenRenFenQi, 16-04-29 16:04:33
 *
 *  发送开关指令
 *
 *  @param ison    YES/NO 打开/关闭
 *  @param command 特指CommandSendMessage指令类型
 */
-(void)sendStatusMessage:(BOOL)ison Command:(CommandQueue)command
{
    if (command != CommandSendMessage) {
        return;
    }
    NSString *macAddress = [AppUtils localUserDefaultsForKey:KMY_DeviceMacAddress];
    if (macAddress) {
        [SocketProtocol commandSendMessageToQueue:macAddress Status:ison];
    }
}

/**
 *  @author RenRenFenQi, 16-04-29 16:04:02
 *
 *  断开连接
 */
-(void)disconnect
{
    if ([self.socket isConnected]) {
        [self.socket setUserData:SelfDisconnected];
        [self.socket disconnect];
    }
}

/**
 *  @author RenRenFenQi, 16-04-29 16:04:15
 *
 *  判断socket是否连接
 *
 *  @return socket连接状态
 */
-(BOOL)isConnected
{
    return [self.socket isConnected];
}

/**
 *  @author RenRenFenQi, 16-04-29 16:04:59
 *
 *  心跳连接
 */
-(void)longConnectToSocket{
    if ([self.socket isConnected]) {
        // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
        
        NSString *longConnect = @"longConnect";
        
        NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
        
        [self.socket writeData:dataStream withTimeout:1 tag:1];
    }else{
        if (testTimer) {
            if ([testTimer isValid]) {
                [testTimer invalidate];
                testTimer = nil;
            }
        }
    }
}

#pragma -mark AsyncSocketDelegate
/**
 * In the event of an error, the socket is closed.
 * You may call "unreadData" during this call-back to get the last bit of data off the socket.
 * When connecting, this delegate method may be called
 * before"onSocket:didAcceptNewSocket:" or "onSocket:didConnectToHost:".
 **/
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
}

/**
 * Called when a socket disconnects with or without error.  If you want to release a socket after it disconnects,
 * do so here. It is not safe to do that during "onSocket:willDisconnectWithError:".
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifySocketDidDisconnected object:nil];
    NSLog(@"Socket did disconnected");
    if (sock.userData == SelfDisconnected) {
        return;
    }else{
        [self connectToIP:connectIP WithPort:connectPort];
    }
}

/**
 * Called when a socket accepts a connection.  Another socket is spawned to handle it. The new socket will have
 * the same delegate and will call "onSocket:didConnectToHost:port:".
 **/
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    
}


/**
 * Called when a socket is about to connect. This method should return YES to continue, or NO to abort.
 * If aborted, will result in AsyncSocketCanceledError.
 *
 * If the connectToHost:onPort:error: method was called, the delegate will be able to access and configure the
 * CFReadStream and CFWriteStream as desired prior to connection.
 *
 * If the connectToAddress:error: method was called, the delegate will be able to access and configure the
 * CFSocket and CFSocketNativeHandle (BSD socket) as desired prior to connection. You will be able to access and
 * configure the CFReadStream and CFWriteStream in the onSocket:didConnectToHost:port: method.
 **/
- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
{
    return YES;
}

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifySocketDidConnected object:nil];
    NSLog(@"Connect To Host:%@  port:%d",host,port);
    connectIP = host;
    connectPort = port;
    
    #pragma 心跳包
//    testTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
//    [testTimer fire];
    
    [sock readDataWithTimeout:30 tag:0];
    [self sendMessage:CommandSubcribe];
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *revStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"receive:%@",revStr);
    
    [sock readDataWithTimeout:30 tag:0];
}

/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

/**
 * Called if a read operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been read so far for the read operation.
 *
 * Note that this method may be called multiple times for a single read if you return positive numbers.
 **/
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{
    return 15.0f;
}

/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 *
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 *
 * Note that this method may be called multiple times for a single write if you return positive numbers.
 **/
- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{
    return 15.0f;
}

/**
 * Called after the socket has successfully completed SSL/TLS negotiation.
 * This method is not called unless you use the provided startTLS method.
 *
 * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
 * and the onSocket:willDisconnectWithError: delegate method will be called with the specific SSL error code.
 **/
- (void)onSocketDidSecure:(AsyncSocket *)sock
{
    
}
@end
