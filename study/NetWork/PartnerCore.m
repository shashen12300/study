//
//  PartnerCore.m
//  study
//
//  Created by yang on 15/9/21.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PartnerCore.h"
#import "AFNetworking.h"
#import "PartnerAllModel.h"
#import "PartnerCommentModel.h"
#import "PartnerPraiseModel.h"
#import "PartnerFriendIndoModel.h"
#import "PartnerManaer.h"
#import "PartnerPraiseManager.h"
#import "PartnerCommentManager.h"
#import "PartnerHistoryManager.h"
#import "PartnerPraiseHistoryManager.h"
#import "PartnerCommentHistoryManager.h"
#import "JZCommon.h"

@implementation PartnerCore

// 发布历史
-(void)partnerUserId:(NSInteger)userId FeedId:(NSInteger)feedId tag:(NSString *)tag type:(NSString *)type withFeedRefresh:(FeedRefresh)feedRefresh {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/studyManager/usersShare/selectUserShare.action",SERVER_ADDRESS];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)userId] forKey:@"userId"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)feedId] forKey:@"id"];
    [param setObject:tag forKey:@"tag"];
    [param setObject:type forKey:@"type"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        NSMutableArray *resultArray = [NSMutableArray new];
//        
//        if (array.count != 0) {
//            // 清空数据库
//            if (feedRefresh != FeedRefreshDown) {
//                if ([type isEqualToString:@"A"]) {
//                    [[PartnerManaer shareInstance] clearAllData];
//                }else
//                    [[PartnerHistoryManager shareInstance] clearAllData];
//            }
//            // 转模型并使评论排序
//            for (NSDictionary *dic in array) {
//                PartnerAllModel *allModel = [[PartnerAllModel alloc] init];
//                PartnerPartModel *partModel = [[PartnerPartModel alloc] init];
//                [partModel setValuesForKeysWithDictionary:dic];
//                allModel.model = partModel;
//                
//                // 插入数据到数据库
//                if (feedRefresh != FeedRefreshDown) {
//                    if ([type isEqualToString:@"A"]) {
//                        [[PartnerManaer shareInstance] insertWithModel:partModel];
//                    }else
//                        [[PartnerHistoryManager shareInstance] insertWithModel:partModel];
//                }
//                // 赞转模型
//                NSMutableArray *praiseArray = [NSMutableArray new];
//                if ([dic[@"userPraise"] count] != 0) {
//                    for (NSDictionary *praiseDic in dic[@"userPraise"]) {
//                        PartnerPraiseModel *praiseModel = [[PartnerPraiseModel alloc] init];
//                        [praiseModel setValuesForKeysWithDictionary:praiseDic];
//                        [praiseArray addObject:praiseModel];
//                        // 插入数据到数据库
//                        if (feedRefresh != FeedRefreshDown) {
//                            if (feedRefresh != FeedRefreshDown) {
//                                if ([type isEqualToString:@"A"]) {
//                                    [[PartnerPraiseManager shareInstence] insertWithModel:praiseModel];
//                                }else
//                                    [[PartnerPraiseHistoryManager shareInstence] insertWithModel:praiseModel];
//                            }
//                        }
//                    }
//                }
//                allModel.userPraise = praiseArray;
//                // 评论转模型
//                NSMutableArray *commentArray = [NSMutableArray new];
//                if ([dic[@"userComment"] count] != 0) {
//                    for (NSDictionary *commentDic in dic[@"userComment"]) {
//                        PartnerCommentModel *commentModel = [[PartnerCommentModel alloc] init];
//                        [commentModel setValuesForKeysWithDictionary:commentDic];
//                        [commentArray addObject:commentModel];
//                        // 插入数据到数据库
//                        if (feedRefresh != FeedRefreshDown) {
//                            if ([type isEqualToString:@"A"]) {
//                                [[PartnerCommentManager shareInstence] insertWithModel:commentModel];
//                            }else
//                                [[PartnerCommentHistoryManager shareInstence] insertWithModel:commentModel];
//                        }
//                    }
//                }
//                
//                __weak NSMutableArray *weakArray = commentArray;
//                NSArray *sortCommentArray = [commentArray sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                    PartnerCommentModel *number1 = obj1;
//                    PartnerCommentModel *number2 = obj2;
//                    
//                    if (number1.commentId == number2.commentedId) {
//                        [weakArray removeObject:obj2];
//                        NSInteger index = [weakArray indexOfObject:obj1];
//                        NSLog(@"index == %ld",(long)index);
//                        [weakArray insertObject:obj2 atIndex:index + 1];
//                    }
//                    return NSOrderedSame;
//                }];
//
//                sortCommentArray = nil;
//                
//                allModel.userComment = commentArray;
//                [resultArray addObject:allModel];
//            }
//        }
//        
//        if ([self.delegate respondsToSelector:@selector(gainPartnerResult:withResultArray:withFeedRefresh:)]) {
//            [self.delegate gainPartnerResult:YES withResultArray:resultArray withFeedRefresh:feedRefresh];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(gainPartnerResult:withResultArray:withFeedRefresh:)]) {
            [self.delegate gainPartnerResult:NO withResultArray:nil withFeedRefresh:feedRefresh];
        }
        NSLog(@"error == %@",error.localizedDescription);
    }];
}

// 发布
- (void)publishWithParam:(NSDictionary *)param {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/studyManager/usersShare/UserShare.action",SERVER_ADDRESS];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(publishResult:)]) {
            [self.delegate publishResult:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(publishResult:)]) {
            [self.delegate publishResult:NO];
        }
        NSLog(@"error == %@",error.localizedDescription);
    }];
}

// 删除新鲜事
- (void)deleteUserFeed:(NSInteger)feedId {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/studyManager/usersShare/UserShare.action",SERVER_ADDRESS];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)feedId] forKey:@"id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(delPartnerResult:withFeedId:)]) {
            [self.delegate delPartnerResult:YES withFeedId:feedId];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(delPartnerResult:withFeedId:)]) {
            [self.delegate delPartnerResult:NO withFeedId:feedId];
        }
        NSLog(@"error == %@",error.localizedDescription);
    }];
}

// 评论
- (void)commentId:(NSInteger)commentId withFeedId:(NSInteger)feedId withCommentedId:(NSInteger)commentedId withCommentDetail:(NSString *)commentDetail withIndexPath:(NSIndexPath *)indexPath  {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/studyManager/usersShare/UserComment.action",SERVER_ADDRESS];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (commentId != 0) {
        [param setObject:[NSString stringWithFormat:@"%ld",(long)commentId] forKey:@"commentId"];
    }
    [param setObject:[NSString stringWithFormat:@"%ld",(long)feedId] forKey:@"feedId"];
    [param setObject:[UserInfoList loginUserId] forKey:@"userId"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)commentedId] forKey:@"commentedId"];
    [param setObject:commentDetail forKey:@"commentDetail"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (commentId != 0) {
            if ([self.delegate respondsToSelector:@selector(delCommentResult:withCommentId:withIndexPath:)]) {
                [self.delegate delCommentResult:YES withCommentId:commentId withIndexPath:indexPath];
            }
        }else {
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            if ([self.delegate respondsToSelector:@selector(addCommentResult:withCommentId:withFeedId:withCommentedId:withCommentDetail:withIndexPath:)]) {
                [self.delegate addCommentResult:YES withCommentId:[str integerValue]  withFeedId:feedId withCommentedId:commentedId withCommentDetail:commentDetail withIndexPath:indexPath];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (commentId != 0) {
            if ([self.delegate respondsToSelector:@selector(delCommentResult:withCommentId:withIndexPath:)]) {
                [self.delegate delCommentResult:NO withCommentId:commentId withIndexPath:indexPath];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(addCommentResult:withCommentId:withFeedId:withCommentedId:withCommentDetail:withIndexPath:)]) {
                [self.delegate addCommentResult:NO withCommentId:0 withFeedId:feedId withCommentedId:commentedId withCommentDetail:commentDetail withIndexPath:indexPath];
            }
        }
        NSLog(@"error == %@",error.localizedDescription);
    }];
}

// 赞
- (void)praiseId:(NSInteger)praiseId withFeedId:(NSInteger)feedId withPraiseType:(FeedPraise)praiseType withIndexPath:(NSIndexPath *)indexPath {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/studyManager/usersShare/UserPraise.action",SERVER_ADDRESS];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    if (praiseId != 0) {
        [param setObject:[NSString stringWithFormat:@"%ld",(long)praiseId] forKey:@"praiseId"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)feedId] forKey:@"feedId"];
    [param setObject:[UserInfoList loginUserId] forKey:@"userId"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)praiseId] forKey:@"praiseId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([self.delegate respondsToSelector:@selector(praiseResult:withPraiseId:withPraiseType:withIndexPath:)]) {
            if (praiseType == FeedPraiseAdd) {
                [self.delegate praiseResult:YES withPraiseId:[str integerValue] withPraiseType:praiseType withIndexPath:indexPath];
            }else {
                [self.delegate praiseResult:YES withPraiseId:praiseId withPraiseType:praiseType withIndexPath:indexPath];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(praiseResult:withPraiseId:withPraiseType:withIndexPath:)]) {
            [self.delegate praiseResult:NO withPraiseId:0 withPraiseType:praiseType withIndexPath:indexPath];
        }
        NSLog(@"error == %@",error.localizedDescription);
    }];
}

// 背景图片
- (void)replaceBackImageWithUserId:(NSInteger)userId picture:(NSString *)picture {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/studyManager/usersAction/editUserByPicture.action",SERVER_ADDRESS];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)userId] forKey:@"id"];
    [param setObject:picture forKey:@"picture"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:picture forKey:@"loginUserPicture"];
        [defaults synchronize];
        
        if ([self.delegate respondsToSelector:@selector(recomposeImageResult:)]) {
            [self.delegate recomposeImageResult:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(recomposeImageResult:)]) {
            [self.delegate recomposeImageResult:NO];
        }
        
        NSLog(@"error == %@",error.localizedDescription);
    }];
}

- (void)gainFriendsInfoWithPhone:(NSInteger)phone userId:(NSInteger)userId {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/studyManager/addFriendsAction/findFriendByCPhone.action",SERVER_ADDRESS];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)userId] forKey:@"userId"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)phone] forKey:@"phone"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            PartnerFriendIndoModel *model = [[PartnerFriendIndoModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [arr addObject:model];
        }
        
        if ([self.delegate respondsToSelector:@selector(gainFriendsArray:)]) {
            [self.delegate gainFriendsArray:arr];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error == %@",error.localizedDescription);
    }];
}

@end
