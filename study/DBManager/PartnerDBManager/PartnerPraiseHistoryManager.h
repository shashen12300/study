//
//  PartnerPraiseHistoryManager.h
//  study
//  朋友圈动态赞
//  Created by yang on 16/1/11.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PartnerPraiseModel;

@interface PartnerPraiseHistoryManager : NSObject

+ (PartnerPraiseHistoryManager *)shareInstence;
/**
 *  插入
 *
 *  @param model
 */
- (void)insertWithModel:(PartnerPraiseModel *)model;
/**
 *  根据feedId删除
 *
 *  @param feedId
 */
- (void)delFeedId:(NSInteger)feedId;
/**
 *  根据praiseId删除
 *
 *  @param praiseId
 */
- (void)delPraiseId:(NSInteger)praiseId;
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
