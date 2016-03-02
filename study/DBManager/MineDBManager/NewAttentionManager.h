//
//  NewAttentionManager.h
//  study
//
//  Created by mijibao on 16/2/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewAttentionManager : NSObject

+ (NewAttentionManager *)shareInstance;
//插入数据
- (void)insertWithModel:(NSDictionary *)dic;
//读取当前用户新的关注信息
- (NSMutableArray *)getUnReadDataWithUserId:(NSString *)userId;
//读取当前用户所有关注信息
- (NSMutableArray *)getAllReadDataWithUserId:(NSString *)userId;
//修改用户属性
- (void)upDataReadResultWithUserId:(NSString *)userId isRead:(NSString *)isRead;

@end
