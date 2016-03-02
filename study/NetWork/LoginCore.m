//
//  LoginCore.m
//  study
//
//  Created by mijibao on 15/9/9.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "LoginCore.h"
#import "MD5Tool.h"
#import "UserInfoList.h"

@implementation LoginCore

//登陆请求
- (void)loginUrlRequestWithUserName:(NSString *)userName
                           passCode:(NSString *)passCode
                            andType:(NSString *)type
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/clientLogin.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"phone"];
    [params setObject:passCode forKey:@"password"];
    [params setObject:type forKey:@"type"];
    //创建管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //利用方法请求数据
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result)
    {
        if (result)
        {
            NSString *returnResult = [[NSString alloc]init];
            returnResult = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            if ([returnResult isEqualToString:@"4"] || [returnResult isEqualToString:@"5"]) {
                //登录失败
                if ([self.delegate respondsToSelector:@selector(passLoginResult:)]) {
                    [self.delegate passLoginResult:returnResult];
                }
            }else{
                //登录成功
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[AccountManeger loginSfStatus]];
                [self solveLoginSuccessResult:dataArr];
                [defaults setObject:userName forKey:KLoginUserTelPhone];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        //网络请求错误
        NSString *errorString = [NSString stringWithFormat:@"%@", error];
        if ([self.delegate respondsToSelector:@selector(passLoginResult:)]) {
            [self.delegate passLoginResult:errorString];
        }
    }];
}

//获取验证码
- (void)getAcessCodeWithUserPhone:(NSString *)phone
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/phoneCode.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    //创建管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //利用方法请求数据
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result)
     {
         if (result)
         {
             NSString *returnResult = [[NSString alloc]init];
             returnResult = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
             if ([returnResult isEqualToString:@"2"]) {
                 if ([self.delegate respondsToSelector:@selector(passPhoneCodeResult:returnResult:)]){
                             [self.delegate passPhoneCodeResult:NO returnResult:nil];
                 }
             }else{
                 [[NSUserDefaults standardUserDefaults] setObject:returnResult forKey:kAccessPhoneCode];
                 if ([self.delegate respondsToSelector:@selector(passPhoneCodeResult:returnResult:)]) {
                             [self.delegate passPhoneCodeResult:YES returnResult:returnResult];
                 }
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //网络请求错误
         NSString *errorString = [NSString stringWithFormat:@"%@", error];
         if ([self.delegate respondsToSelector:@selector(passLoginResult:)]) {
             [self.delegate passLoginResult:errorString];
         }
     }];
}

//第三方登陆
- (void)loginUrlRequestWithUserName:(NSString *)userName
                        accountType:(NSString *)accountType
                           userType:(NSString *)userType
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/clientLoginBySF.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"openid"];
    [params setObject:accountType forKey:@"accounttype"];
    [params setObject:userType forKey:@"usertype"];
    //创建管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //利用方法请求数据
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result)
     {
         if (result)
         {
             NSString *returnResult = [[NSString alloc]init];
             returnResult = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
             if ([returnResult isEqualToString:@"4"] || [returnResult isEqualToString:@"5"]) {
                 //登录失败
                 if ([self.delegate respondsToSelector:@selector(passLoginResult:)]) {
                     [self.delegate passLoginResult:returnResult];
                 }
             }else{
                 //登录成功
                 NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[AccountManeger loginSfStatus]];
                 [self solveLoginSuccessResult:dataArr];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //网络请求错误
         if ([self.delegate respondsToSelector:@selector(passPhoneCodeResult:returnResult:)]) {
             [self.delegate passPhoneCodeResult:NO returnResult:nil];
         }
     }];
}

- (void)solveLoginSuccessResult:(NSArray *)array
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = array[0];
    [self saveInfomation:dic[@"age"] withKey:[AccountManeger loginUserAge]];
    [self saveInfomation:dic[@"city"] withKey:[AccountManeger loginUserCity]];
    [self saveInfomation:dic[@"gender"] withKey:[AccountManeger loginUserGender]];
    [self saveInfomation:dic[@"grade"] withKey:[AccountManeger loginUserGrade]];
    [self saveInfomation:[NSString stringWithFormat:@"%@",dic[@"id"]] withKey:[AccountManeger loginUserId]];
    [self saveInfomation:dic[@"nickname"] withKey:[AccountManeger loginUserNickname]];
    [self saveInfomation:dic[@"password"] withKey:[AccountManeger loginUserPassword]];
    [self saveInfomation:dic[@"phone"] withKey:[AccountManeger loginUserPhone]];
    [self saveInfomation:dic[@"photo"] withKey:[AccountManeger loginUserPhoto]];
    [self saveInfomation:dic[@"picture"] withKey:[AccountManeger loginUserPicture]];
    [self saveInfomation:dic[@"province"] withKey:[AccountManeger loginUserProvince]];
    [self saveInfomation:dic[@"signature"] withKey:[AccountManeger loginUserSignature]];
    [self saveInfomation:dic[@"type"] withKey:[AccountManeger loginUserType]];
    [self saveInfomation:dic[@"school"] withKey:[AccountManeger loginUserSchool]];
    [self saveInfomation:dic[@"subject"] withKey:[AccountManeger loginUserSubject]];
    [self saveInfomation:dic[@"honors"] withKey:[AccountManeger loginUserHonors]];
    [defaults setBool:YES forKey:[AccountManeger loginStatus]];
    [[NSNotificationCenter defaultCenter]postNotificationName:KChangeRootView object:nil userInfo:nil];
}

- (void)saveInfomation:(id)saveObjec withKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([key isEqualToString:[AccountManeger loginUserNickname]] || [key isEqualToString:[AccountManeger loginUserPhoto]]) {
        if (saveObjec == [NSNull null] || saveObjec == nil || [JZCommon isBlankString:saveObjec]) {
            NSLog(@"无昵称，不保存返回信息");
        }else{
            [defaults setObject:saveObjec forKey:key];
        }
    }else{
        NSString *saveString = (saveObjec == [NSNull null] || saveObjec == nil) ? @"" : saveObjec;
       [defaults setObject:saveString forKey:key];
    }
}
@end

