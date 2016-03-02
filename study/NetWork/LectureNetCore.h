//
//  LectureNetCore.h
//  study
//  今日大课网络请求
//  Created by jzkj on 15/10/26.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LectureModel.h"
#import "LectureDetailModel.h"
#import "Lecture_saveModel.h"

@protocol LectureNetCoreDelegate <NSObject>

@optional
//所有课程
- (void)postBigLessonArray:(NSMutableArray *)mArray withRequest:(BOOL)isSuccess;
//根据年级查询所有科目信息
- (void)postBigLessonGradeBackSubject:(NSMutableArray *)mArray withRequest:(BOOL)isSuccess;
//根据科目的id查询详情
- (void)postBigLessonFindBigLessionDetail:(LectureDetailModel *)model isSuccess:(BOOL)isSuccess;
//收藏
- (void)postBigLessonCollectWithString:(NSString *)string isSuccess:(BOOL)isSuccess;
//购买
- (void)postBigLessonBuyWithString:(NSString *)string isSuccess:(BOOL)isSuccess;
//分享
- (void)postBigLessonShareString:(NSString *)string isSuccess:(BOOL)isSuccess;
//点赞
- (void)postBigLessonPraise:(NSString *)praiseId isSuccess:(BOOL)isSuccess;
//取消点赞
- (void)postBigLessonDelPraise:(BOOL)isSuccess;
//我的视频
//购买查询
- (void)backBigLessonBuys:(NSMutableArray *)mArray isSuccess:(BOOL)success;
//收藏查询结果
- (void)backBigLessonCollects:(NSMutableArray *)mArray isSuccess:(BOOL)success;
//下载历史记录(本地数据库查询)
- (void)backBigLessonDownLoads:(NSMutableArray *)mArray isSuccess:(BOOL)success;

//收藏删除
- (void)actionBigLessonDelCollect:(BOOL)isSuccess;
- (void)actionBigLessonDelCollects:(BOOL)isSuccess;

@end

@interface LectureNetCore : NSObject

@property (nonatomic, weak) id<LectureNetCoreDelegate>del;
//所有课程
- (void) requestBigLessonAction;
//根据年级查询所有科目信息
- (void) requestBigLessonWithGrade:(NSString *)grade withSubject:(NSString *)sub;
//根据科目的id查询详情
- (void) requestFindBidLessonDetial:(NSString *)lecrureid withUserId:(NSString *)uid;
//视频详情
//收藏
- (void) requestBigLessonWithCollect:(NSString *)lecrureid withUserId:(NSString *)uid;
//购买
- (void) requestBigLessonWithBuy:(NSString *)lecrureid withUserId:(NSString *)uid;
//分享
- (void) requestBigLessonWithShare:(NSDictionary *)dict;
//点赞
- (void) requestPraiseWithFeedId:(NSString *)feedId withUserId:(NSString *)userId;
//取消点赞
- (void) requestDelPraiseId:(NSString *)praiseId;
//我的视频里
//购买
- (void) findBigLessonWithBuyedClass;
//收藏
- (void) findBigLessonWithCollectClass;
//缓存


//删除收藏
- (void) requestBiglessonWithDelCollect:(NSString *)lecrureid;
//删除多个收藏
- (void) requestBigLessonWithDelCollectMore:(NSArray *)lecArr;
@end
