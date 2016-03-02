//
//  MinePartnerManager.m
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MinePartnerManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"


@implementation MinePartnerManager
{
    FMDatabase *_db;
}

+ (MinePartnerManager *)shareInstance {
    static MinePartnerManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MinePartnerManager alloc] init];
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
                [_db executeUpdate:@"CREATE TABLE mypartnerList (userId integer primary key AUTOINCREMENT, phone text, nickname text, type text, headImage text)"];
            }else{
                NSLog(@"fail to open");
            }
        }
    }
    return self;
}

- (void)insertWithModel:(MinePartnerModel *)model {
    if ([_db open]) {
        [_db executeUpdate:@"insert into mypartnerList (userId,phone,nickname,type,headImage) values(?,?,?,?,?)", [NSString stringWithFormat:@"%ld",(long)model.userId], model.phone, model.nickname, model.type, model.photo];
    }else{
        NSLog(@"fail to open");
    }
}

- (void)deleteListData{
    if ([_db open]) {
        [_db executeUpdate:@"delete from mypartnerList"];
    }else{
        NSLog(@"fail to open");
    }
}

- (NSArray *)gainDataArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([_db open]) {
        FMResultSet *set = [_db executeQuery:@"SELECT * FROM mypartnerList order by nickname desc"];
        while ([set next]) {
            MinePartnerModel *model = [[MinePartnerModel alloc]init];
            NSDictionary *dict = [set resultDictionary];
            model.userId = [dict[@"userId"] integerValue];
            model.phone = dict[@"phone"];
            model.nickname = dict[@"nickname"];
            model.photo = dict[@"headImage"];
            model.type = dict[@"type"];
            [array addObject:model];
        }
        [set close];
    }else {
        NSLog(@"fail to open");
    }
    return array;
}

@end
