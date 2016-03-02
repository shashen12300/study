//
//  CollectionManager.m
//  study
//
//  Created by mijibao on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CollectionManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation CollectionManager

{
    FMDatabase *_db;
}

+ (CollectionManager *)shareInstance {
    static CollectionManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CollectionManager alloc] init];
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
                [_db executeUpdate:@"CREATE TABLE collectionList (lecrureid integer primary key AUTOINCREMENT, userId integer, grade text, subject text, title text, duration text, picurl text, addtime text, expriretime text)"];
            }else{
                NSLog(@"fail to open");
            }
        }
    }
    return self;
}

- (void)insertWithModel:(CollectionModel *)model {
    if ([_db open]) {
        [_db executeUpdate:@"insert into collectionList (lecrureid, userId, grade, subject, title, duration, picurl, addtime, expriretime) values(?,?,?,?,?,?,?,?,?)", [NSString stringWithFormat:@"%ld",(long)model.lecrureid], [NSString stringWithFormat:@"%ld",(long)model.userId], model.grade, model.subject, model.title, model.duration, model.picurl, model.addtime, model.expriretime];
    }else{
        NSLog(@"fail to open");
    }
}

- (void)deleteListData{
    if ([_db open]) {
        [_db executeUpdate:@"delete from collectionList"];
    }else{
        NSLog(@"fail to open");
    }
}

- (NSArray *)gainDataArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([_db open]) {
        FMResultSet *set = [_db executeQuery:@"SELECT * FROM collectionList order by addtime desc"];
        while ([set next]) {
            CollectionModel *model = [[CollectionModel alloc]init];
            NSDictionary *dict = [set resultDictionary];
            model.lecrureid = [dict[@"lecrureid"] integerValue];
            model.userId = [dict[@"userId"] integerValue];
            model.grade = dict[@"grade"];
            model.subject = dict[@"subject"];
            model.title = dict[@"title"];
            model.duration = dict[@"duration"];
            model.picurl = dict[@"picurl"];
            model.addtime = dict[@"addtime"];
            model.expriretime = dict[@"expriretime"];
            [array addObject:model];
        }
        [set close];
    }else {
        NSLog(@"fail to open");
    }
    return array;
}

@end
