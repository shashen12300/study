//
//  NewAttentionManager.m
//  study
//
//  Created by mijibao on 16/2/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "NewAttentionManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation NewAttentionManager

{
    FMDatabase *_db;
}

+ (NewAttentionManager *)shareInstance {
    static NewAttentionManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NewAttentionManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_db) {
            NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            dbPath = [dbPath stringByAppendingPathComponent:@"study.sqlite"];
            _db = [FMDatabase databaseWithPath:dbPath];
            if ([_db open]) {
                BOOL ret = [_db executeUpdate:@"CREATE TABLE newAttentionList (userid text, fromid text, date text, isRead text, primary key(userid,fromid))"];
                if (!ret) {
                    NSError *error = [_db lastError];
                }
            }else{
                NSLog(@"fail to open");
            }
        }
    }
    return self;
}

- (void)insertWithModel:(NSDictionary *)dic {
    if ([_db open]) {
        [_db executeUpdate:@"insert into newAttentionList (userid, fromid, date, isRead) values(?,?,?,?)", [UserInfoList loginUserId], dic[@"fromId"], dic[@"date"], dic[@"isRead"]];
    }else{
        NSLog(@"fail to open");
    }
}

//- (void)deleteInfomationWithUserId:(NSString *)userId {
//    if ([_db open]) {
//        [_db executeUpdate:@"DELETE * FROM userInfomationList where userId=?", userId];
//    }else{
//        NSLog(@"fail to open");
//    }
//}
//
//- (void)deleteListData{
//    if ([_db open]) {
//        [_db executeUpdate:@"delete from userInfomationList"];
//    }else{
//        NSLog(@"fail to open");
//    }
//}
//
- (NSMutableArray *)getUnReadDataWithUserId:(NSString *)userId
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([_db open]) {
        FMResultSet *set = [_db executeQuery:@"SELECT * FROM newAttentionList where userid=? and isRead=?", userId, @"0"];
        while ([set next]) {
            dict = [set resultDictionary];
            [array addObject:dict];
        }
    }else {
        NSLog(@"fail to open");
    }
    return array;
}

- (NSMutableArray *)getAllReadDataWithUserId:(NSString *)userId
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([_db open]) {
        FMResultSet *set = [_db executeQuery:@"SELECT * FROM newAttentionList where userid=?", [NSString stringWithFormat:@"%@",userId]];
        while ([set next]) {
            dict = [set resultDictionary];
            [array addObject:dict];
        }
    }else {
        NSLog(@"fail to open");
    }
    return array;
}
//更新读取状态
- (void)upDataReadResultWithUserId:(NSString *)userId isRead:(NSString *)isRead {
    if ([_db open]) {
        [_db beginDeferredTransaction];
        [_db executeUpdate:@"UPDATE newAttentionList SET isRead=? WHERE userid = ?",@"1", @"232"];
        [_db commit];
        [_db close];
    }else{
        NSLog(@"fail to open");
    }
}

@end
