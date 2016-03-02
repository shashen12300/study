//
//  MinePartnerManager.h
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinePartnerModel.h"

@interface MinePartnerManager : NSObject

+ (MinePartnerManager *)shareInstance;
//插入我的伙伴数据
- (void)insertWithModel:(MinePartnerModel *)model;
//读取我的伙伴数据
- (NSArray *)gainDataArray;
//清空数据库数据
- (void)deleteListData;

@end
