//
//  MinePartnerCore.h
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MinePartnerCoreDelegate <NSObject>

- (void)passRequstResult:(BOOL)result infomation:(NSMutableArray *)array;

@end

@interface MinePartnerCore : NSObject

@property (nonatomic, weak) id<MinePartnerCoreDelegate>delegate;

/**
 *  我的伙伴请求
 *
 *  @param userId  用户ID
 *
 */
- (void)requestPartnerWithUserId:(NSString *)userId;

/**
 *  查看用户详情信息
 *
 *  @param mineId    用户ID
 *  @param anotherId 查询对象的ID
 *
 */
- (void)requestUseInfomationWithMineId:(NSString *)mineId anotherId:(NSString *)anotherId;

@end
