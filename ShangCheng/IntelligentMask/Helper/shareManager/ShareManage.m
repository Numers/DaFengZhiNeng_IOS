//
//  ShareManage.m
//  renrenfenqi
//
//  Created by DY on 15/1/12.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#import "ShareManage.h"
#import "ThirdPartToolsMacros.h"
#import "sdkDef.h"
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "CommonTools.h"

@implementation ShareManage

+ (ShareManage *) GetInstance {
    
    static ShareManage *instance = nil;
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [[ShareManage alloc] init];
        }
    }
    return instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.oauth = [[TencentOAuth alloc] initWithAppId:kQQAPP_ID andDelegate:self];
    }
    return self;
}

-(void)shareVideoToWeixinPlatform:(int)scene themeUrl:(NSString*)themeUrl thumbnail:(UIImage*)thumbnail title:(NSString*)title descript:(NSString*)descrip {
    
    NSData *thumbData = UIImageJPEGRepresentation(thumbnail,1);
    if ( [thumbData length]>=32*1024) {
        NSLog(@"分享缩略图大于32k");
        thumbnail = [CommonTools scaleToSize:thumbnail size:CGSizeMake(150, 150)];
    }
    
    if (![WXApi isWXAppInstalled]) {
        [AppUtils showInfo:@"你的iPhone 上还没有安装微信，无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。"];
        return;
    }
    
    if (![WXApi isWXAppSupportApi]) {
        [AppUtils showInfo:@"你当前的微信版本过低，无法支持此功能，请更新微信至最新版本"];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    if (scene == 0) {
        message.title = [NSString stringWithFormat:@"%@",title];
    }
    
    if (scene == 1) {
        message.title = [NSString stringWithFormat:@"%@\n%@",title,descrip];
    }
    
    [message setThumbImage:thumbnail];
    message.description = descrip;
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = themeUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

-(void)loginWithWXAccount
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req];
}

-(void)getAccess_tokenWithWXCode:(NSString *)code
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                NSString *token = [dic objectForKey:@"access_token"];
                NSString *openId = [dic objectForKey:@"openid"];
                [self getUserInfoWithToken:token WithOpenId:openId];
            }
        });
    });
}

-(void)getUserInfoWithToken:(NSString *)token WithOpenId:(NSString *)openId
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
                NSString *nickName = [dic objectForKey:@"nickname"];
                UIImage *headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                
            }
        });
        
    });
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if(aresp.errCode == 0){
            NSString *code = aresp.code;
            [self getAccess_tokenWithWXCode:code];
        }else{
            [AppUtils showInfo:resp.errStr];
        }
    }
}

-(void)shareToQQZoneWithShareURL:(NSString *)shareUrl WithTitle:(NSString *)title WithDescription:(NSString *)desc WithPreviewImageUrl:(NSString *)preImageUrl
{
    NSURL* url = [NSURL URLWithString:shareUrl];
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:preImageUrl], 1.0f);
    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:url title:title description:desc previewImageData:imageData];
    
    [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPISENDSUCESS:
        {
            break;
        }
            
        case EQQAPIAPPNOTREGISTED:
        {
            [AppUtils showInfo:@"App未注册"];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            [AppUtils showInfo:@"发送参数错误"];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            [AppUtils showInfo:@"未安装手Q"];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            [AppUtils showInfo:@"API接口不支持"];
            break;
        }
        case EQQAPISENDFAILD:
        {
            [AppUtils showInfo:@"发送失败"];
            break;
        }
        default:
        {
            break;
        }
    }
}

-(void)loginWithQQAccount
{
    NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    [self.oauth authorize:_permissions inSafari:NO]; //授权
}

-(void)getUserInfoResponse:(APIResponse *)response
{
    //   NSLog(@"respons:%@",response.jsonResponse);
    
    NSString *nickName = [response.jsonResponse objectForKey:@"nickname"];
}

- (void)tencentDidLogin
{
    if (self.oauth.accessToken && 0 != [self.oauth.accessToken length]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessed object:self];
        //  记录登录用户的OpenID、Token以及过期时间
        [self.oauth getUserInfo];
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCancelled object:self];
    }
}

- (void)tencentDidNotNetWork
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}

- (void)tencentDidLogout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
}

-(void)loginWithWeiboAccount
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWeiboRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
        NSString* accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString* userID = [(WBAuthorizeResponse *)response userID];
        
        [alert show];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
        NSString* userID = [shareMessageToContactResponse.authResponse userID];
        
        [alert show];
    }
}
@end
