//
//  CollectionCore.h
//  study
//
//  Created by mijibao on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CollectionCoreDelegate <NSObject>

- (void)passSearchResult:(BOOL)isSuccess resultInfomation:(NSMutableArray *)infomation;

@end

@interface CollectionCore : NSObject

@property (weak, nonatomic) id<CollectionCoreDelegate>delegate;

/**
 *  个人收藏列表查询
 *
 *  @param userId  用户id
 *
 */
- (void)requestMyCollectionByUserId:(NSString *)userId;

/**
 *  删除收藏
 *
 *  @param userId  用户id
 *
 */


/**
 *  转发收藏
 *
 *  @param userId  用户id
 *
 */

@end
