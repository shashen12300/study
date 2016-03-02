//
//  PartnerCore.h
//  study
//
//  Created by yang on 15/9/21.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FeedPraiseAdd,    // 添加
    FeedPraiseDelete, // 删除
}FeedPraise;

typedef enum {
    FeedRefreshUp,    // 下拉
    FeedRefreshDown,  // 上拉
    FeedRefreshNone   //
}FeedRefresh;

@protocol PartnerCoreDelegate <NSObject>

@optional
/**
 *  发布结果
 *
 *  @param result YES:成功  NO:失败
 */
- (void)publishResult:(BOOL)result;
/**
 *  获取动态数据
 *
 *  @param result      YES:成功  NO:失败
 *  @param resultArray
 *  @param feedRefresh
 */
- (void)gainPartnerResult:(BOOL)result withResultArray:(NSArray *)resultArray withFeedRefresh:(FeedRefresh)feedRefresh;
/**
 *  删除动态
 *
 *  @param result YES:成功  NO:失败
 *  @param feedId feedId
 */
- (void)delPartnerResult:(BOOL)result withFeedId:(NSInteger)feedId;
/**
 *  评论
 *
 *  @param result        YES:成功  NO:失败
 *  @param commentId     commentId
 *  @param feedId        feedId
 *  @param commentedId   commentedId
 *  @param commentDetail 评论内容
 *  @param indexPath     indexPath
 */
- (void)addCommentResult:(BOOL)result withCommentId:(NSInteger)commentId withFeedId:(NSInteger)feedId withCommentedId:(NSInteger)commentedId withCommentDetail:(NSString *)commentDetail withIndexPath:(NSIndexPath *)indexPath;
/**
 *  删除评论
 *
 *  @param result    YES:成功  NO:失败
 *  @param commentId commentId
 *  @param indexPath indexPath
 */
- (void)delCommentResult:(BOOL)result withCommentId:(NSInteger)commentId withIndexPath:(NSIndexPath *)indexPath;
/**
 *  赞  取消赞
 *
 *  @param result     YES:成功  NO:失败
 *  @param praiseId   praiseId
 *  @param praiseType
 *  @param indexPath  indexPath
 */
- (void)praiseResult:(BOOL)result withPraiseId:(NSInteger)praiseId withPraiseType:(FeedPraise)praiseType withIndexPath:(NSIndexPath *)indexPath;
/**
 *  修改背景结果
 *
 *  @param result  YES:成功  NO:失败
 */
- (void)recomposeImageResult:(BOOL)result;
/**
 *  通讯录数据
 *
 *  @param array
 */
- (void)gainFriendsArray:(NSArray *)array;

@end

@interface PartnerCore : NSObject

@property (weak, nonatomic) id<PartnerCoreDelegate> delegate;

/**
 *  动态数据获取
 *
 *  @param userId      用户id
 *  @param feedId      事件id
 *  @param tag         刷新 D=下拉获取，传入最后一条的id，不下拉时传0
 *  @param type         type=A 查询所有动态自己的和自己的好友以及评论和点赞的数据
                        type=M 查询自己的动态和评论点赞的数据
                        type=S 查询学生的动态和评论点赞的数据
                        type=T 查询老师的动态和评论点赞的数据）
 *  @param feedRefresh
 */
-(void)partnerUserId:(NSInteger)userId FeedId:(NSInteger)feedId tag:(NSString *)tag type:(NSString *)type withFeedRefresh:(FeedRefresh)feedRefresh;
/**
 *  发布
 *
 *  @param param 发布相关参数字典
 */
- (void)publishWithParam:(NSDictionary *)param;
/**
 *  删除动态
 *
 *  @param feedId 事件id
 */
- (void)deleteUserFeed:(NSInteger)feedId;
/**
 *  评论
 *
 *  @param commentId     评论id
 *  @param feedId        事件id
 *  @param commentedId   被评论id
 *  @param commentDetail 评论内容
 *  @param indexPath
 */
- (void)commentId:(NSInteger)commentId withFeedId:(NSInteger)feedId withCommentedId:(NSInteger)commentedId withCommentDetail:(NSString *)commentDetail withIndexPath:(NSIndexPath *)indexPath;
/**
 *  赞
 *
 *  @param praiseId   赞id
 *  @param feedId     事件id
 *  @param praiseType
 *  @param indexPath
 */
- (void)praiseId:(NSInteger)praiseId withFeedId:(NSInteger)feedId withPraiseType:(FeedPraise)praiseType withIndexPath:(NSIndexPath *)indexPath;
/**
 *  修改背景图片
 *
 *  @param userId  用户id
 *  @param picture 图片url
 */
- (void)replaceBackImageWithUserId:(NSInteger)userId picture:(NSString *)picture;
/**
 *  通讯录
 *
 *  @param phone  电话
 *  @param userId 用户id
 */
- (void)gainFriendsInfoWithPhone:(NSInteger)phone userId:(NSInteger)userId;

@end
