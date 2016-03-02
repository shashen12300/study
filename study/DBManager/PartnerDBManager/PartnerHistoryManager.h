//
//  PartnerHistoryManager.h
//  study
//  朋友圈动态
//  Created by yang on 16/1/11.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PartnerPartModel;

@interface PartnerHistoryManager : NSObject

+ (PartnerHistoryManager *)shareInstance;
/**
 *  插入
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
 *  情况数据库
 */
- (void)clearAllData;
/**
 *  查询数据库
 *
 *  @return 
 */
- (NSArray *)gainDataArray;

@end
