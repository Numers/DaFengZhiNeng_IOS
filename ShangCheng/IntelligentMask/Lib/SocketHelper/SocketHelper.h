//
//  SocketHelper.h
//  IntelligentMask
//
//  Created by baolicheng on 16/4/11.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NotifySocketDidConnected @"NotifySocketDidConnected"
#define NotifySocketDidDisconnected @"NotifySocketDidDisconnected"
#define NotifySocketReceiveMessage @"NotifySocketReceiveMessage"
typedef enum{
    CommandSubcribe,  //订阅
    CommandSendMessage, //发送消息指令
    CommandGetMessage, //发送读取指令
    CommandDisconnect //断开连接指令
}CommandQueue;

typedef enum{
    ServiceDisConnected = 1, //服务器断开
    NetworkDisConnected, //网络异常断开
    SelfDisconnected //客户端主动断开
}DisconnectType; //网络断开原因
@interface SocketHelper : NSObject
+(id)defaultHelper;

/**
 *  @author RenRenFenQi, 16-04-29 16:04:33
 *
 *  连接服务器
 *
 *  @param ip   服务器ip地址
 *  @param port 服务器端口
 */
-(void)connectToIP:(NSString *)ip WithPort:(UInt16)port;

/**
 *  @author RenRenFenQi, 16-04-29 16:04:01
 *
 *  发送订阅、断开连接、获取消息指令
 *
 *  @param command 指令类型
 */
-(void)sendMessage:(CommandQueue)command;

/**
 *  @author RenRenFenQi, 16-04-29 16:04:33
 *
 *  发送开关指令
 *
 *  @param ison    YES/NO 打开/关闭
 *  @param command 特指CommandSendMessage指令类型
 */
-(void)sendStatusMessage:(BOOL)ison Command:(CommandQueue)command;

/**
 *  @author RenRenFenQi, 16-04-29 16:04:02
 *
 *  断开连接
 */
-(void)disconnect;

/**
 *  @author RenRenFenQi, 16-04-29 16:04:15
 *
 *  判断socket是否连接
 *
 *  @return socket连接状态
 */
-(BOOL)isConnected;
@end
