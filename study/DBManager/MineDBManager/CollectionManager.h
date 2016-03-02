//
//  CollectionManager.h
//  study
//
//  Created by mijibao on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionModel.h"

@interface CollectionManager : NSObject

+ (CollectionManager *)shareInstance;
//插入我的收藏数据
- (void)insertWithModel:(CollectionModel *)model;
//读取我的收藏数据
- (NSArray *)gainDataArray;
//清空数据库数据
- (void)deleteListData;

@end
