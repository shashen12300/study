//
//  LectureNetCore.m
//  study
//  今日大课网络请求
//  Created by jzkj on 15/10/26.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "LectureNetCore.h"

@implementation LectureNetCore
{
    NSMutableArray *_dataArray;
}

//所有的课程
- (void)requestBigLessonAction
{
    NSString *requestStr =[NSString stringWithFormat:@"http://%@/studyManager/bigLessonAction/findBigLessonByGrade.action",SERVER_ADDRESS];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];

    [param setObject:@0 forKey:@"id"];
    [param setObject:@0 forKey:@"tag"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager POST:requestStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog ( @"operation: %@" , operation. responseString );
        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:@"0"]) {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonArray:withRequest:)]) {
                [self.del postBigLessonArray:[NSMutableArray array] withRequest:YES];
            }
        } else {
            NSArray *responArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (responArray != nil && responArray.count != 0) {
                if (self.del && [self.del respondsToSelector:@selector(postBigLessonArray:withRequest:)]) {
                    [self.del postBigLessonArray:[self messageModel:responArray] withRequest:YES];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (self.del && [self.del respondsToSelector:@selector(postBigLessonArray:withRequest:)]) {
            [self.del postBigLessonArray:[NSMutableArray array] withRequest:NO];
        }
    }];
}

//根据年级查询所有科目信息
- (void) requestBigLessonWithGrade:(NSString *)grade withSubject:(NSString *)sub
{
    NSString *requestStr =[NSString stringWithFormat:@"http://%@/studyManager/bigLessonAction/findBigLessonByGS.action?",SERVER_ADDRESS];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];

    if ([grade isEqualToString:@""] || grade == nil ||[sub isEqualToString:@""] || sub == nil) {
        return;
    }
    
    [param setObject:grade forKey:@"grade"];
    [param setObject:sub forKey:@"subject"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager POST:requestStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog ( @"operation: %@" , operation. responseString );
        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:@"0"]) {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonGradeBackSubject:withRequest:)]) {
                [self.del postBigLessonGradeBackSubject:[NSMutableArray array] withRequest:YES];
            }
        } else {
            NSArray * responArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (responArray != nil && responArray.count != 0) {
                if (self.del && [self.del respondsToSelector:@selector(postBigLessonGradeBackSubject:withRequest:)]) {
                    [self.del postBigLessonGradeBackSubject:[self messageModel:responArray] withRequest:YES];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (self.del && [self.del respondsToSelector:@selector(postBigLessonGradeBackSubject:withRequest:)]) {
            [self.del postBigLessonGradeBackSubject:[NSMutableArray array] withRequest:NO];
        }
    }];
}

//根据科目的id查询详情
- (void) requestFindBidLessonDetial:(NSString *)lecrureid withUserId:(NSString *)uid
{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/bigLessonAction/findBigLessonBySID.action",SERVER_ADDRESS];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:lecrureid forKey:@"lecrureid"];
    if (uid.length >0) {
        [param setObject:uid forKey:@"userId"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:@"0"]) {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonFindBigLessionDetail:isSuccess:)]) {
                [self.del postBigLessonFindBigLessionDetail:nil isSuccess:YES];
            }
        } else {
            NSArray * responArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (responArray.count != 0 && responArray.count == 1) {
                if (self.del && [self.del respondsToSelector:@selector(postBigLessonFindBigLessionDetail:isSuccess:)]) {
                    [self.del postBigLessonFindBigLessionDetail:[self LecturceNetDetailModel:responArray] isSuccess:YES];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.del && [self.del respondsToSelector:@selector(postBigLessonFindBigLessionDetail:isSuccess:)]) {
            [self.del postBigLessonFindBigLessionDetail:nil isSuccess:NO];
        }
    }];
}

//收藏
- (void) requestBigLessonWithCollect:(NSString *)lecrureid withUserId:(NSString *)uid
{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/bigLessonAction/addBigLessonCollect.action",SERVER_ADDRESS];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:lecrureid forKey:@"lecrureid"];
    [param setObject:uid forKey:@"userID"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseObject = %@",str);
        if ([str isEqualToString:@"0"]) {//添加收藏失败
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonCollectWithString:isSuccess:)]) {
                [self.del postBigLessonCollectWithString:@"0" isSuccess:YES];
            }
            
        } else if ([str isEqualToString:@"2"]) {//已收藏
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonCollectWithString:isSuccess:)]) {
                [self.del postBigLessonCollectWithString:@"2" isSuccess:YES];
            }
        }else {//成功
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonCollectWithString:isSuccess:)]) {
                [self.del postBigLessonCollectWithString:@"1" isSuccess:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        if (self.del && [self.del respondsToSelector:@selector(postBigLessonCollectWithString:isSuccess:)]) {
            [self.del postBigLessonCollectWithString:nil isSuccess:NO];
        }
    }];
}

//购买
- (void) requestBigLessonWithBuy:(NSString *)lecrureid withUserId:(NSString *)uid
{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/bigLessonAction/addBigLessonBuy.action",SERVER_ADDRESS];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:lecrureid forKey:@"lecrureid"];
    [param setObject:uid forKey:@"userID"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"0"]) {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonBuyWithString:isSuccess:)]) {
                [self.del postBigLessonBuyWithString:@"0" isSuccess:YES];
            }
            
        } else if ([str isEqualToString:@"2"]) {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonBuyWithString:isSuccess:)]) {
                [self.del postBigLessonBuyWithString:@"2" isSuccess:YES];
            }
        }else {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonBuyWithString:isSuccess:)]) {
                [self.del postBigLessonBuyWithString:@"1" isSuccess:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        if (self.del && [self.del respondsToSelector:@selector(postBigLessonBuyWithString:isSuccess:)]) {
            [self.del postBigLessonBuyWithString:nil isSuccess:NO];
        }
    }];
}

//分享
- (void) requestBigLessonWithShare:(NSDictionary *)dict
{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/usersShare/UserShare.action",SERVER_ADDRESS];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"1"]) {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonShareString:isSuccess:)]) {
                [self.del postBigLessonShareString:@"1" isSuccess:YES];
            }
        }else {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonShareString:isSuccess:)]) {
                [self.del postBigLessonShareString:@"0" isSuccess:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        if (self.del && [self.del respondsToSelector:@selector(postBigLessonBuyWithString:isSuccess:)]) {
            [self.del postBigLessonShareString:nil isSuccess:NO];
        }
    }];
}

//功能:我的视频
//收藏
- (void) findBigLessonWithCollectClass
{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/bigLessonAction/findBigLessonByUID.action",SERVER_ADDRESS];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:urlStr parameters:@{@"userID":[UserInfoList loginUserId]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:@"0"]) {
            if (self.del && [self.del respondsToSelector:@selector(backBigLessonCollects:isSuccess:)]) {
                [self.del backBigLessonCollects:[NSMutableArray array] isSuccess:NO];
            }
        } else {
            NSArray *responArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (responArray != nil && responArray.count != 0) {
                if (self.del && [self.del respondsToSelector:@selector(backBigLessonCollects:isSuccess:)]) {
                    [self.del backBigLessonCollects:[self BackCollectsModel:responArray] isSuccess:YES];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        if (self.del && [self.del respondsToSelector:@selector(backBigLessonCollects:isSuccess:)]) {
            [self.del backBigLessonCollects:nil isSuccess:NO];
        }
    }];
}

//删除收藏
- (void) requestBiglessonWithDelCollect:(NSString *)lessonid
{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/bigLessonAction/deleteCollect.action",SERVER_ADDRESS];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:urlStr parameters:@{@"id":lessonid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"1"]) {
            if (self.del && [self.del respondsToSelector:@selector(actionBigLessonDelCollect:)]) {
                [self.del actionBigLessonDelCollect:YES];
            }
        }else {
            if (self.del && [self.del respondsToSelector:@selector(actionBigLessonDelCollect:)]) {
                [self.del actionBigLessonDelCollect:NO];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        if (self.del && [self.del respondsToSelector:@selector(actionBigLessonDelCollect:)]) {
            [self.del actionBigLessonDelCollect:NO];
        }
    }];
}

//删除多个收藏
- (void) requestBigLessonWithDelCollectMore:(NSArray *)lecArr
{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/bigLessonAction/deleteCollectMore.action",SERVER_ADDRESS];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    NSString *lessonid = [lecArr componentsJoinedByString:@","];
    
    [manager POST:urlStr parameters:@{@"id":lessonid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"1"]) {
            if (self.del && [self.del respondsToSelector:@selector(actionBigLessonDelCollects:)]) {
                [self.del actionBigLessonDelCollects:YES];
            }
        }else {
            if (self.del && [self.del respondsToSelector:@selector(actionBigLessonDelCollects:)]) {
                [self.del actionBigLessonDelCollects:NO];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
//        if (self.del && [self.del respondsToSelector:@selector(actionBigLessonDelCollects:)]) {
//            [self.del actionBigLessonDelCollects:NO];
//        }
    }];
}

//点赞
- (void) requestPraiseWithFeedId:(NSString *)feedId withUserId:(NSString *)userId {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/usersShare/UserPraise.action",SERVER_ADDRESS];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:feedId forKey:@"feedId"];
    [param setValue:userId forKey:@"userId"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
 
        if ([str isEqualToString:@"0"]) {  //失败

            if (self.del && [self.del respondsToSelector:@selector(postBigLessonPraise:isSuccess:)]) {
                [self.del postBigLessonPraise:nil isSuccess:NO];
            }
        }else {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonPraise:isSuccess:)]) {
                [self.del postBigLessonPraise:str isSuccess:YES];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);

    }];
}

//取消点赞
- (void) requestDelPraiseId:(NSString *)praiseId {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/studyManager/usersShare/UserPraise.action",SERVER_ADDRESS];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[NSNumber numberWithInteger:[praiseId integerValue]]forKey:@"praiseId"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"1"]) {//成功
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonDelPraise:)]) {
                [self.del postBigLessonDelPraise:YES];
            }
        }else {
            if (self.del && [self.del respondsToSelector:@selector(postBigLessonDelPraise:)]) {
                [self.del postBigLessonDelPraise:NO];
            }
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}


#pragma mark - Other
-(NSMutableArray *)messageModel:(NSArray *)dataArray
{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    if (_dataArray.count != 0) {
        [_dataArray removeAllObjects];
    }
    
    for (NSDictionary *dic in dataArray) {
        LectureModel *model = [[LectureModel alloc] init];
        model.lecrureid = [dic objectForKey:@"lecrureid"];
        model.title = [dic objectForKey:@"title"];
        model.duration = [dic objectForKey:@"duration"];
        model.picurl = [dic objectForKey:@"picurl"];
        model.clickcount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"clickcount"]];
        model.grade = [dic objectForKey:@"grade"];
        model.subject = [dic objectForKey:@"subject"];
        
        NSString *timeStr= [dic objectForKey:@"addtime"];
        timeStr = [timeStr substringToIndex:[timeStr rangeOfString:@" "].location];
        NSArray *arr = [NSArray array];
        NSRange range = [timeStr rangeOfString:@"-"];
        if (range.length != 0) {
            arr = [timeStr componentsSeparatedByString:@"-"];
        }else{
            arr = [timeStr componentsSeparatedByString:@"."];
        }
        NSString *string = [NSString stringWithFormat:@"%@年%@月%@日", arr[0], arr[1], arr[2]];
        model.addTime = string;//[dateFormat stringFromDate:nd];
        
        [_dataArray addObject:model];
    }
    return _dataArray;
}

-(LectureDetailModel *)LecturceNetDetailModel:(NSArray *)array
{
    NSDictionary *dic = [array lastObject];
    
    LectureDetailModel *model = [[LectureDetailModel alloc] init];
    model.addtime = [dic objectForKey:@"addtime"];
    model.content = [dic objectForKey:@"content"];
    model.duration = [dic objectForKey:@"duration"];
    model.expriretime = [dic objectForKey:@"expriretime"];
    model.grade = [dic objectForKey:@"grade"];
    model.subject = [dic objectForKey:@"subject"];
    model.lecturer = [dic objectForKey:@"lecturer"];
    model.picurl = [dic objectForKey:@"picurl"];
    model.price = [dic objectForKey:@"price"];
    model.source = [dic objectForKey:@"source"];
    model.url = [dic objectForKey:@"url"];
    model.buyYOrN = [dic objectForKey:@"buyYOrN"];
    model.collectYOrN = [dic objectForKey:@"collectYOrN"];

    return model;
}

//绑定数据
- (NSMutableArray *)BackCollectsModel:(NSArray *)dataArray
{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    if (_dataArray.count != 0) {
        [_dataArray removeAllObjects];
    }
    for (NSDictionary *dic in dataArray) {
        Lecture_saveModel *model = [[Lecture_saveModel alloc] init];
        
        model.lid = [dic objectForKey:@"id"];
        model.title = [dic objectForKey:@"title"];
        model.picurl = [dic objectForKey:@"picurl"];
        model.lecrureid = [dic objectForKey:@"lecrureid"];
        
        model.duration = [dic objectForKey:@"duration"];
        
        NSString *addTimeStr= [dic objectForKey:@"addtime"];
        addTimeStr = [addTimeStr substringToIndex:[addTimeStr rangeOfString:@" "].location];
        NSArray *addTimearr = [addTimeStr componentsSeparatedByString:@"."];
        NSString *addTimestring = [NSString stringWithFormat:@"%@年%@月%@日", addTimearr[0], addTimearr[1], addTimearr[2]];
        model.addTime = addTimestring;//[dateFormat stringFromDate:nd];
        
        //截止时间
        NSString *stopTimeStr= [dic objectForKey:@"expriretime"];
        stopTimeStr = [stopTimeStr substringToIndex:[stopTimeStr rangeOfString:@" "].location];
        NSArray *stopTimearr = [addTimeStr componentsSeparatedByString:@"."];
        NSString *stopTimestring = [NSString stringWithFormat:@"%@年%@月%@日", stopTimearr[0], stopTimearr[1], stopTimearr[2]];
        model.stopTime = stopTimestring;
        
        [_dataArray addObject:model];
    }
    return _dataArray;
}

@end
