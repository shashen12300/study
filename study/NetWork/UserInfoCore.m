//
//  UserInfoCore.m
//  study
//
//  Created by mijibao on 16/1/15.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "UserInfoCore.h"

@implementation UserInfoCore

//修改用户基本信息
- (void)changeUserInfomationWithUserId:(NSString *)userId
                         newInfomation:(NSString *)infomation
                               infoKey:(NSString *)infokey
                               saveKey:(NSString *)saveKey
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/editUserByUserID.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:userId forKey:@"userID"];
    [params setObject:infomation forKey:infokey];
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
            if ([returnResult isEqualToString:@"success"]) {
                [[NSUserDefaults standardUserDefaults] setObject:infomation forKey:saveKey];
            }
            if ([self.delegate respondsToSelector:@selector(passChangeResult:)]) {
                [self.delegate passChangeResult:returnResult];
            }
        }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSString *errorString = [NSString stringWithFormat:@"%@", error];
         if ([self.delegate respondsToSelector:@selector(passChangeResult:)]) {
             [self.delegate passChangeResult:errorString];
         }
     }];
}

//修改用户手机号
- (void)changeUserTelephone:(NSString *)oldPhone andNewPhone:(NSString *)newPhone
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/editUserPhoneByPhone.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:oldPhone forKey:@"newPhone"];
    [params setObject:newPhone forKey:@"oldPhone"];
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
             if ([returnResult isEqualToString:@"1"]) {
                 [[NSUserDefaults standardUserDefaults] setObject:newPhone forKey:[UserInfoList loginUserPhone]];
             }
             if ([self.delegate respondsToSelector:@selector(passChangeResult:)]) {
                 [self.delegate passChangeResult:returnResult];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSString *errorString = [NSString stringWithFormat:@"%@", error];
         if ([self.delegate respondsToSelector:@selector(passChangeResult:)]) {
             [self.delegate passChangeResult:errorString];
         }
     }];
}

//修改用户地区
- (void)changeUserLocationWithUserId:(NSString *)userId
                        withProvince:(NSString *)province
                             andCity:(NSString *)city;
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/updatePAndC.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:userId forKey:@"id"];
    [params setObject:province forKey:@"province"];
    [params setObject:city forKey:@"city"];
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
             if ([returnResult isEqualToString:@"success"]) {
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:province forKey:[AccountManeger loginUserProvince]];
                 [defaults setObject:city forKey:[AccountManeger loginUserCity]];
             }
             if ([self.delegate respondsToSelector:@selector(passChangeResult:)]) {
                 [self.delegate passChangeResult:returnResult];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSString *errorString = [NSString stringWithFormat:@"%@", error];
         if ([self.delegate respondsToSelector:@selector(passChangeResult:)]) {
             [self.delegate passChangeResult:errorString];
         }
     }];
}
@end
