//
//  QQ.m
//  ComponentProject
//
//  Created by jzkj on 11/24/15.
//  Copyright © 2015 jzkj. All rights reserved.
//

#import "QQ.h"

@implementation QQ
{
    TencentOAuth *_oauth;
}

/**
 创建TencentOAuth并初始化其appid 
 */
- (instancetype)init
{
    if (self = [super init]) {
        _oauth = [[TencentOAuth alloc] initWithAppId:@"1105066249" andDelegate:self];
    }
    return self;
}

- (void)login
{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO,
                            nil];
    [_oauth authorize:permissions inSafari:NO];
}

#pragma mark - QQApiInterfaceDelegate
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req
{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:sendResp.result message:sendResp.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
        default:
        {
            break;
        }
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

#pragma mark - TencentSessionDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    NSLog(@"登陆成功");
    if (_oauth.accessToken && _oauth.accessToken.length != 0) {
        //获取accesstoken成功，成功登陆，并获取用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:kSFloginSuccess object:nil userInfo:@{@"openId":_oauth.openId, @"accountType":@"1"}];
        [[NSUserDefaults standardUserDefaults] setObject:@"QQ" forKey:[AccountManeger loginSftype]];
        [_oauth getUserInfo];
        }else{
            //获取accesstoken失败
        NSLog(@"没有获取到accetoken，登陆失败");
        }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {//用户取消登陆，默认会自动返回到登陆页面
        NSLog(@"用户取消登陆");
    }else{
        NSLog(@"登陆失败");
        if ([self.delegate respondsToSelector:@selector(passQQloginResult:description:disuserInfomation:)]) {
            [self.delegate passQQloginResult:NO description:@"登陆失败" disuserInfomation:nil];
        }
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    NSLog(@"请检查您的网络");
    if ([self.delegate respondsToSelector:@selector(passQQloginResult:description:disuserInfomation:)]) {
        [self.delegate passQQloginResult:NO description:@"请检查您的网络" disuserInfomation:nil];
    }
}

/**
 * 退出登录的回调
 */
- (void)tencentDidLogout
{
    NSLog(@"用户退出登陆");
}

/**
 * 获取用户个人信息回调
 */
- (void)getUserInfoResponse:(APIResponse *)response
{
    if ([_oauth getUserInfo]) {//获取用户信息成功,如果当前用户没有设置头像或者昵称，则用qq昵称和头像
        self.userInfoDic = response.jsonResponse;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![UserInfoList loginUserPhoto] || [JZCommon isBlankString:[UserInfoList loginUserPhoto]] || [[UserInfoList loginUserPhoto] isEqualToString:@""]) {
            [defaults setObject:self.userInfoDic[@"figureurl_qq_1"] forKey:[AccountManeger loginUserPhoto]];
        }
        if (![UserInfoList loginUserNickname] || [JZCommon isBlankString:[UserInfoList loginUserNickname]] || [[UserInfoList loginUserNickname] isEqualToString:@""]) {
            [defaults setObject:self.userInfoDic[@"nickname"] forKey:[AccountManeger loginUserNickname]];
        }
    }else{
        NSLog(@"获取用户qq信息失败");
    }
}

@end
