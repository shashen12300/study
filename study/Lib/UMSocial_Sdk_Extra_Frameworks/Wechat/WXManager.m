//
//  WXManager.m
//  study
//
//  Created by mijibao on 16/2/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "WXManager.h"
#import "WXApi.h"

@implementation WXManager

- (void)wxLogin
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"ios.study";
    [WXApi sendReq:req];
}

- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp
{
    if (resp.errCode == 0)
    {//同意登陆
        SendAuthResp *aresp = (SendAuthResp *)resp;
        [self getAccessTokenWithCode:aresp.code];
    }else if (resp.errCode == -4){//用户取消登陆
        
    }else if (resp.errCode == -2){//
        
    }
}

- (void)getAccessTokenWithCode:(NSString *)code{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx383b5b5c22db8516",@"555646b4d6c4b52c96c03463e3745f66",code];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"]){
                    NSLog(@"获取token错误");
                }else{
                    NSLog(@"成功获取access_token和unionid及openid信息");
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"refresh_token"] forKey:kWeiXinRefreshToken];
                    //根据access_token和openid获取微信用户的基本信息，并保存refresh_token以便获取用户信息失败时，通过其重新获取。
                    [[NSUserDefaults standardUserDefaults] setObject:@"WeChat" forKey:[AccountManeger loginSftype]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kSFloginSuccess object:nil userInfo:@{@"openId":dict[@"openid"], @"accountType":@"2"}];
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
            }
        });
    });
}

- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {//获取用户信息失败,根据refreshtoken重新获取用户基本信息
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:kWeiXinRefreshToken]];
                }else{//获取需要的数据
                    NSLog(@"获取得到微信账户");
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if (![UserInfoList loginUserPhoto] || [JZCommon isBlankString:[UserInfoList loginUserPhoto]] || [[UserInfoList loginUserPhoto] isEqualToString:@""]) {
                        [defaults setObject:dict[@"headimgurl"] forKey:[AccountManeger loginUserPhoto]];
                    }
                    if (![UserInfoList loginUserNickname] || [JZCommon isBlankString:[UserInfoList loginUserNickname]] || [[UserInfoList loginUserNickname] isEqualToString:@""]) {
                        [defaults setObject:dict[@"nickname"] forKey:[AccountManeger loginUserNickname]];
                    }
                }
            }});
    });
}

- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",@"wx383b5b5c22db8516",refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {//授权过期
                    NSLog(@"微信授权已过期");
                }else{
                    //重新使用AccessToken获取信息
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
            }
        });
    });
}


@end
