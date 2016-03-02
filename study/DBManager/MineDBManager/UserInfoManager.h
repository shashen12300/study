//
//  UserInfoManager.h
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface UserInfoManager : NSObject

+ (UserInfoManager *)shareInstance;
//插入我的伙伴数据
- (void)insertWithModel:(UserInfoModel *)model;
//读取我的伙伴数据
- (NSMutableArray *)gainDataArrayWithUserId:(NSInteger)userId;
//删除所有信息
- (void)deleteListData;
//删除某一用户的信息
- (void)deleteInfomationWithUserId:(NSString *)userId;
@end
