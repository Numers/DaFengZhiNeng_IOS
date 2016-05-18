//
//  ShareManage.h
//  renrenfenqi
//
//  Created by DY on 15/1/12.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WeiboSDK.h"
#import "WXApi.h"

@interface ShareManage : NSObject<TencentSessionDelegate,WeiboSDKDelegate,WXApiDelegate>
@property (nonatomic, strong)TencentOAuth *oauth;

+ (ShareManage *) GetInstance;

/* 分享视频到微信平台
 scene     [in] 平台参数 WXSceneSession=0,聊天界面; WXSceneTimeline=1,朋友圈;WXSceneFavorite=2,收藏
 themeUrl  [in] 主题地址
 thumbnail [in] 分享缩略图
 title     [in] 标题
 descript  [in] 描述
 */
-(void)shareVideoToWeixinPlatform:(int)scene themeUrl:(NSString*)themeUrl thumbnail:(UIImage*)thumbnail title:(NSString*)title descript:(NSString*)descript;

/*
 shareUrl 分享的链接地址
 title    分享的标题
 desc     分享的内容
 preImageUrl 分享的显示图片链接地址
 */
-(void)shareToQQZoneWithShareURL:(NSString *)shareUrl WithTitle:(NSString *)title WithDescription:(NSString *)desc WithPreviewImageUrl:(NSString *)preImageUrl;

/**
 *  @author RenRenFenQi, 16-02-18 17:02:27
 *
 *  微信登录
 */
-(void)loginWithWXAccount;

/**
 *  @author RenRenFenQi, 16-02-19 10:02:15
 *
 *  QQ登录
 */
-(void)loginWithQQAccount;

/**
 *  @author RenRenFenQi, 16-02-19 12:02:56
 *
 *  微博登录
 */
-(void)loginWithWeiboAccount;
@end
