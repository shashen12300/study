//
//  PartnerCommentManager.h
//  study
//  朋友圈首页评论
//  Created by yang on 16/1/4.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PartnerCommentModel;

@interface PartnerCommentManager : NSObject

+ (PartnerCommentManager *)shareInstence;
/**
 *  插入
 *
 *  @param model
 */
- (void)insertWithModel:(PartnerCommentModel *)model;
/**
 *  根据feedId删除
 *
 *  @param feedId
 */
- (void)delFeedId:(NSInteger)feedId;
/**
 *  根据commentId删除
 *
 *  @param commentId
 */
- (void)delCommentId:(NSInteger)commentId;
/**
 *  清空数据库
 */
- (void)clearAllData;
/**
 *  根据feedId查询数据库
 *
 *  @param feedId
 *
 *  @return
 */
- (NSArray *)gainDataArrayWithFeedId:(NSInteger)feedId;

@end
