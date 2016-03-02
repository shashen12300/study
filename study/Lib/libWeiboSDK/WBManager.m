//
//  WBManager.m
//  study
//
//  Created by mijibao on 16/2/23.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "WBManager.h"
#import "WeiboSDK.h"

@implementation WBManager

- (void)sinaLogin
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)getWeiboLoginResult:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *statusCode = [NSString stringWithFormat:@"%d", (int)response.statusCode];
        if ([statusCode isEqualToString:@"0"]) {//微博登陆认证成功，登陆第三方应用
            self.accessToken = [(WBAuthorizeResponse *)response accessToken];
            self.loginSinaId = [(WBAuthorizeResponse *)response userID];
            self.refreshToken = [(WBAuthorizeResponse *)response refreshToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"Sina" forKey:[AccountManeger loginSftype]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSFloginSuccess object:nil userInfo:@{@"openId":self.loginSinaId, @"accountType":@"3"}];
            [self getSinaUserInfomation:_accessToken userId:_loginSinaId];
        }else{
            NSLog(@"微博认证失败");
        }
    }
}

- (void)getSinaUserInfomation:(NSString *)accessToken userId:(NSString *)userId{
    NSString *urlString = @"https://api.weibo.com/2/users/show.json";
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:accessToken forKey:@"access_token"];
    [params setObject:userId forKey:@"uid"];
    //创建管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //利用方法请求数据
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result)
     {
         if (result){
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             if (![UserInfoList loginUserPhoto] || [JZCommon isBlankString:[UserInfoList loginUserPhoto]] || [[UserInfoList loginUserPhoto] isEqualToString:@""]) {
                 [defaults setObject:dict[@"avatar_large"] forKey:[AccountManeger loginUserPhoto]];
             }
             if (![UserInfoList loginUserNickname] || [JZCommon isBlankString:[UserInfoList loginUserNickname]] || [[UserInfoList loginUserNickname] isEqualToString:@""]) {
                 [defaults setObject:dict[@"screen_name"] forKey:[AccountManeger loginUserNickname]];
             }
             NSLog(@"获取用户信息成功");
         }else{
             NSLog(@"获取用户信息失败");
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"获取用户信息失败");
    }];

}
@end
