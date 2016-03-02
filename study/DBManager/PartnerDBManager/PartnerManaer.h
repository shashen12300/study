//
//  PartnerManaer.h
//  study
//  朋友圈首页
//  Created by yang on 16/1/4.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PartnerPartModel;

@interface PartnerManaer : NSObject

+ (PartnerManaer *)shareInstance;

/**
 *  插入数据
 *
 *  @param model
 */
- (void)insertWithModel:(PartnerPartModel *)model;
/**
 *  根据feedId删除
 *
 *  @param feedId
 */
- (void)delFeedId:(NSInteger)feedId;
/**
 *  清楚数据库
 */
- (void)clearAllData;
/**
 *  查询数据库
 *
 *  @return 
 */
- (NSArray *)gainDataArray;

@end
