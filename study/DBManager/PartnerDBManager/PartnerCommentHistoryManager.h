//
//  PartnerCommentHistoryManager.h
//  study
//  朋友圈动态评论
//  Created by yang on 16/1/11.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PartnerCommentModel;

@interface PartnerCommentHistoryManager : NSObject

+ (PartnerCommentHistoryManager *)shareInstence;

- (void)insertWithModel:(PartnerCommentModel *)model;

- (void)delFeedId:(NSInteger)feedId;

- (void)delCommentId:(NSInteger)commentId;

- (void)clearAllData;

- (NSArray *)gainDataArrayWithFeedId:(NSInteger)feedId;

@end
