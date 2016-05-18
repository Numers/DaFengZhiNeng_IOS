//
//  GlobalVar.h
//  renrenfenqi
//
//  Created by baolicheng on 15/6/29.
//  Copyright (c) 2015年 RenRenFenQi. All rights reserved.
//

#ifndef renrenfenqi_GlobalVar_h
#define renrenfenqi_GlobalVar_h
#define NetWorkConnectFailedDescription @"网络连接失败"

#define SignatureDeviceKey @"QRMtnYe54h94D5vhb87N8y4FprPG98dq"
#define SignatureAPPKey @"RNIuYTzjt3oIDT_chVfxiUA.#B*9WYVA"
//支付宝相关
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

//合作身份者id，以2088开头的16位纯数字
#define PartnerID   @"2088511976480245"
//收款支付宝账号
#define SellerID    @"renrenkeji@renrenfenqi.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY     @"q3g7khdi2qhjbvh5czpysmxtrbs2gtpl"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBANYYLBNvvbYJxaCYpWouH0Wo8E4qlJs6jxpb5MYDLcO6RjZ3WNm5LVrM+7166P7PgMvR/EQB193aRt5BnjrOELMmSyyg/WmBqx2sbMbYWNYgIkjr7nHOJANGCPVaSwJmMK5heohD66j1sMcIC4ewQk6SlpK01FNVpZmzoTf5dpObAgMBAAECgYBfSdjsObK1P/ou9WHCNY8DoSJ7l+YWhOTGdZoIK8gFsnWnrkzkcs/l9xAgkID9UHvhu69M0YkznAAo0gnL4IV7dkVidp/pUaL3mFmAAzT9i1o76G+GGrRrh+S9uu79DbtcAAG7eH+dO8A7ib0XM13maImfWSSYj9M0DsYN2mrzcQJBAPkmEeuae/mF/QMCTxFFzkIHb/swe4r8TjySCUZZmTc8rlpuxKhPjIoBZ32phRbNnNcWwKHgD7YSnKfUsWcOLzMCQQDb+1SvhT6GV+Wy6UIIhS3m1KI0YxYBNE7eH8RDFXAyv+xNu9d1SEfjHFtERWiEJ49i6N3oIChgqG4qdDzqdqn5AkAtoo99vBohJi2ls3KQE10oMvyL4eF/H5+k8IrKW/b4ayD0Z32V5pwzWvZ9yeMaviaQLxaxj7zQ+K/A/fBQlASJAkAOFZVid4F9UHtgbRbRPNWnhc2s1Ps/sH2sMxR5xxGb7jXO9EvjMnGH1PTy9g6vB2lix84NYqGzLpV/GlocGOThAkAwbQ9RHvXvqbRl7crPv6qqWlAV9uJ5XERjmz8rYY9hLgyWqHbpxBeZu1VkQaUIDVKTNLmxUt6CXp/6JvP84AYa"

//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#define APP_SCHEME      @"KouZhaoIOSClient"
#define NOTIFY_ALIPAY_CALLBACK          @"AlipayCallBack"
/**
 *  APP内模块相关宏
 */
#pragma mark - 本地数据存储
/**
 *  配置API
 */
//////////////////////////////////////////////////////////
#define SC_Config_API @"/v1/config"
/////////////////////////////////////////////////////////

/**
 *  推送API
 */
//////////////////////////////////////////////////////////
#define SC_Push_API @"/v1/push/tag"
/////////////////////////////////////////////////////////

/**
 *  短信模块API
 */
//////////////////////////////////////////////////////////
#define SC_SMS_API @"/app/v1/sms"
/////////////////////////////////////////////////////////

/**
 *  登录模块API
 */
//////////////////////////////////////////////////////////
#define SC_Login_API @"/app/v1/login"
/////////////////////////////////////////////////////////

/**
 *  注册模块API
 */
//////////////////////////////////////////////////////////
#define SC_Register_API @"/app/v1/member"
#define SC_VerificationCode_API @"/v1/sms/reg"
/////////////////////////////////////////////////////////

/**
 *  找回密码API
 */
//////////////////////////////////////////////////////////
#define SC_FindPwdVerificationCode_API @"/v1/sms/forgot/passwd"
#define SC_FindPwd_API @"/v1/forgotPassword"
/////////////////////////////////////////////////////////

/**
 *  首页API
 */
//////////////////////////////////////////////////////////
#define SC_WheatherInfo_API @"/v1/weather/getCityPmTwoFive"
#define SC_ReportData_API @"/v1/request/pm_two_five"
/////////////////////////////////////////////////////////

/**
 *  地图API
 */
//////////////////////////////////////////////////////////
#define SC_RegionPM_API @"/v1/regional/air/pm"
/////////////////////////////////////////////////////////

/**
 *  商城API
 */
//////////////////////////////////////////////////////////
#define SC_ShopIndex_API @"/wap/tmpl/intelligentmask/product_detail.html?goods_id="
/////////////////////////////////////////////////////////

/**
 *  我的订单API
 */
//////////////////////////////////////////////////////////
#define SC_MyOrder_API @"/wap/tmpl/intelligentmask/member/order_list.html"
/////////////////////////////////////////////////////////

/**
 *  消息API
 */
//////////////////////////////////////////////////////////
#define SC_News_API @"/v1/msg/list"
/////////////////////////////////////////////////////////

/**
 *  常见问题API
 */
//////////////////////////////////////////////////////////
#define SC_Problem_API @"http://test.maskcrm.guozhongbao.com/v1/mask/faq"
/////////////////////////////////////////////////////////

/**
 *  反馈API
 */
//////////////////////////////////////////////////////////
#define SC_Feedback_API @"/app/v1/feedback"
/////////////////////////////////////////////////////////
#endif


