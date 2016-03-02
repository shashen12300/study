//
//  UserInfoManager.m
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "UserInfoManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation UserInfoManager
{
    FMDatabase *_db;
}

+ (UserInfoManager *)shareInstance {
    static UserInfoManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[UserInfoManager alloc] init];
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
                [_db executeUpdate:@"CREATE TABLE userInfomationList (id integer primary key AUTOINCREMENT, phone text, nickname text, photo text, picture text, type text, gender text, province text, city text, signature text, age text, grade text, honors text, subject text, photourl1 text, photourl2 text, photourl3 text, photourl4 text, video1 text, video2 text, video3 text, video4 text, rate text, instantanswerCount integer, isfriend text, isattention text)"];
            }else{
                NSLog(@"fail to open");
            }
        }
    }
    return self;
}

- (void)insertWithModel:(UserInfoModel *)model {
    if ([_db open]) {
        [_db executeUpdate:@"insert into userInfomationList (id, phone, nickname, photo, picture, type, gender, province, city, signature, age, grade, honors, subject, photourl1, photourl2, photourl3, photourl4, video1, video2, video3, video4, rate, instantanswerCount, isfriend, isattention) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", [NSString stringWithFormat:@"%ld",(long)model.userId], model.phone, model.nickname, model.photo, model.picture, model.type, model.gender, model.province, model.city, model.signature, model.age, model.grade, model.honors, model.subject, model.photourl1, model.photourl2, model.photourl3, model.photourl4, model.video1, model.video2, model.video3, model.video4, model.rate, [NSString stringWithFormat:@"%ld",(long)model.instantanswerCount], model.isfriend, model.isattention];
    }else{
        NSLog(@"fail to open");
    }
}

- (void)deleteInfomationWithUserId:(NSString *)userId {
    if ([_db open]) {
        [_db executeUpdate:@"DELETE * FROM userInfomationList where userId=?", userId];
    }else{
        NSLog(@"fail to open");
    }
}

- (void)deleteListData{
    if ([_db open]) {
        [_db executeUpdate:@"delete from userInfomationList"];
    }else{
        NSLog(@"fail to open");
    }
}

- (NSMutableArray *)gainDataArrayWithUserId:(NSInteger)userId
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([_db open]) {
        FMResultSet *set = [_db executeQuery:@"SELECT * FROM userInfomationList where id=?", [NSString stringWithFormat:@"%ld",(long)userId]];
        while ([set next]) {
            dict = [set resultDictionary];
        }
        [set close];
    }else {
        NSLog(@"fail to open");
    }
    [array addObject:dict];
    return array;
}

@end
