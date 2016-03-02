//
//  MinePartnerCore.m
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MinePartnerCore.h"
#import "MinePartnerModel.h"
#import "MinePartnerManager.h"
#import "UserInfoModel.h"
#import "UserInfoManager.h"

@implementation MinePartnerCore

//获取我的伙伴
- (void)requestPartnerWithUserId:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/findMyFriendsByUID.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:userId forKey:@"userID"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result)
     {
         if (result)
         {
             NSString *requestResult = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
             if ([requestResult isEqualToString:@"0"]) {
                 if ([self.delegate respondsToSelector:@selector(passRequstResult:infomation:)]) {
                     [self.delegate passRequstResult:NO infomation:nil];
                 }
             }else{
                 NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                 NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                 for (NSDictionary *dic in arr) {
                     MinePartnerModel *model = [[MinePartnerModel alloc]init];
                     model.nickname = dic[@"nickname"];
                     model.phone = dic[@"phone"];
                     model.userId = [dic[@"userId"] integerValue];
                     model.type = dic[@"type"];
                     model.photo = dic[@"photo"];
                    [[MinePartnerManager shareInstance]insertWithModel:model];
                     [resultArray addObject:model];
                 }
                 if ([self.delegate respondsToSelector:@selector(passRequstResult:infomation:)]) {
                     [self.delegate passRequstResult:YES infomation:resultArray];
                 }
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([self.delegate respondsToSelector:@selector(passRequstResult:infomation:)]) {
             [self.delegate passRequstResult:NO infomation:nil];
         }
     }];
}

- (void)requestUseInfomationWithMineId:(NSString *)mineId anotherId:(NSString *)anotherId
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/usersAction/queryUserByID.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:mineId forKey:@"userIdOne"];
    [params setObject:anotherId forKey:@"userIdTow"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id result)
     {
         if (result)
         {
             NSString *requestResult = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
             if ([requestResult isEqualToString:@"0"]) {
                 if ([self.delegate respondsToSelector:@selector(passRequstResult:infomation:)]) {
                     [self.delegate passRequstResult:NO infomation:nil];
                 }
             }else{
                 NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                 NSDictionary *dic = arr[0];
                 [self saveUseInfomation:dic];
                 if ([self.delegate respondsToSelector:@selector(passRequstResult:infomation:)]) {
                     [self.delegate passRequstResult:YES infomation:arr];
                 }
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([self.delegate respondsToSelector:@selector(passRequstResult:infomation:)]) {
             [self.delegate passRequstResult:NO infomation:nil];
         }
     }];
}

- (void)saveUseInfomation:(NSDictionary *)dic
{
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model.userId = [[self saveInfomation:dic withKey:@"id"] integerValue];
    model.phone = [self saveInfomation:dic withKey:@"phone"];
    model.nickname = [self saveInfomation:dic withKey:@"nikename"];
    model.photo = [self saveInfomation:dic withKey:@"photo"];
    model.picture = [self saveInfomation:dic withKey:@"picture"];
    model.type = [self saveInfomation:dic withKey:@"type"];
    model.gender = [self saveInfomation:dic withKey:@"gender"];
    model.province = [self saveInfomation:dic withKey:@"province"];
    model.city = [self saveInfomation:dic withKey:@"city"];
    model.signature = [self saveInfomation:dic withKey:@"signature"] ;
    model.age = [self saveInfomation:dic withKey:@"age"];
    model.grade = [self saveInfomation:dic withKey:@"grade"];
    model.honors = [self saveInfomation:dic withKey:@"honor"];
    model.subject = [self saveInfomation:dic withKey:@"subject"];
    model.photourl1 = [self saveInfomation:dic withKey:@"photourl1"];
    model.photourl2 = [self saveInfomation:dic withKey:@"photourl2"];
    model.photourl3 = [self saveInfomation:dic withKey:@"photourl3"];
    model.photourl4 = [self saveInfomation:dic withKey:@"photourl4"];
    model.video1 = [self saveInfomation:dic withKey:@"video1"];
    model.video2 = [self saveInfomation:dic withKey:@"video2"];
    model.video3 = [self saveInfomation:dic withKey:@"video3"];
    model.video4 = [self saveInfomation:dic withKey:@"video4"];
    model.rate = [self saveInfomation:dic withKey:@"rate"];
    model.isfriend = [self saveInfomation:dic withKey:@"isfriend"];
    model.isattention = [self saveInfomation:dic withKey:@"isattention"];
    model.instantanswerCount = [[self saveInfomation:dic withKey:@"instantanswerCount"] integerValue];
    [[UserInfoManager shareInstance] insertWithModel:model];
    NSLog(@"hahahhah");
}

- (NSString *)saveInfomation:(id)saveObjec withKey:(NSString *)key
{
    NSString *saveString = (saveObjec[key] == [NSNull null] || saveObjec[key] == nil) ? @"" : saveObjec[key];
    return saveString;
}
@end
