//
//  CollectionCore.m
//  study
//
//  Created by mijibao on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CollectionCore.h"
#import "CollectionModel.h"
#import "CollectionManager.h"

@implementation CollectionCore

- (void)requestMyCollectionByUserId:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/studyManager/bigLessonAction/findBigLessonByUID.action",[OperatePlist HTTPServerAddress], [OperatePlist HTTPServerPort]];
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
                 if ([self.delegate respondsToSelector:@selector(passSearchResult:resultInfomation:)]) {
                     [self.delegate passSearchResult:NO resultInfomation:nil];
                 }
             }else{
                 NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                 NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                 for (NSDictionary *dic in arr) {
                     CollectionModel *model = [[CollectionModel alloc]init];
                     model.lecrureid = [dic[@"lecrureid"] integerValue];
                     model.userId = [dic[@"id"] integerValue];
                     model.grade = dic[@"grade"];
                     model.subject = dic[@"subject"];
                     model.title = dic[@"title"];
                     model.duration = dic[@"duration"];
                     model.picurl = dic[@"picurl"];
                     model.addtime = dic[@"addtime"];
                     model.expriretime = dic[@"expriretime"];
                     [[CollectionManager shareInstance]insertWithModel:model];
                     [resultArray addObject:model];
                 }
                 if ([self.delegate respondsToSelector:@selector(passSearchResult:resultInfomation:)]) {
                     [self.delegate passSearchResult:YES resultInfomation:resultArray];
                 }
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([self.delegate respondsToSelector:@selector(passSearchResult:resultInfomation:)]) {
             [self.delegate passSearchResult:NO resultInfomation:nil];
         }
     }];
}

@end
