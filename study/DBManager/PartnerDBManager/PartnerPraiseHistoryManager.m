//
//  PartnerPraiseHistoryManager.m
//  study
//
//  Created by yang on 16/1/11.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import "PartnerPraiseHistoryManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "PartnerPraiseModel.h"

@interface PartnerPraiseHistoryManager ()

{
    FMDatabase *db;
}

@end

@implementation PartnerPraiseHistoryManager

+ (PartnerPraiseHistoryManager *)shareInstence {
    static PartnerPraiseHistoryManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PartnerPraiseHistoryManager alloc] init];
    });
    
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!db) {
            NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            dbPath = [dbPath stringByAppendingPathComponent:@"study.sqlite"];
            db = [FMDatabase databaseWithPath:dbPath];
            if ([db open]) {
                [db executeUpdate:@"CREATE TABLE partnerPraiseHistoryList (praiseId integer primary key AUTOINCREMENT, userId integer, feedId integer, addTime text, nickname text, photo text, phone integer)"];
            }else {
                NSLog(@"fail to open");
            }
        }
    }
    
    return self;
}

- (void)insertWithModel:(PartnerPraiseModel *)model { 
    if ([db open]) {
        [db executeUpdate:@"insert into partnerPraiseHistoryList (praiseId,userId,feedId,addTime,nickname,photo,phone) values(?,?,?,?,?,?,?)",[NSString stringWithFormat:@"%ld",(long)model.praiseId],[NSString stringWithFormat:@"%ld",(long)model.userId],[NSString stringWithFormat:@"%ld",(long)model.feedId],model.addTime,model.nickname,model.photo,[NSString stringWithFormat:@"%ld",(long)model.phone]];
    }else{
        NSLog(@"fail to open");
    }
}

- (void)delFeedId:(NSInteger)feedId {
    if ([db open]) {
        [db executeUpdate:@"DELETE FROM partnerPraiseHistoryList WHERE feedId=?",[NSString stringWithFormat:@"%ld",(long)feedId]];
    }else {
        NSLog(@"fail to open");
    }
}

- (void)delPraiseId:(NSInteger)praiseId {
    if ([db open]) {
        [db executeUpdate:@"DELETE FROM partnerPraiseHistoryList WHERE praiseId=?",[NSString stringWithFormat:@"%ld",(long)praiseId]];
    }else {
        NSLog(@"fail to open");
    }
}

- (void)clearAllData {
    if ([db open]) {
        if ([db executeUpdate:@"DELETE FROM partnerPraiseHistoryList"]) {
            
        }else{
            NSLog(@"fail to clear");
        }
    }else{
        NSLog(@"fail to open");
    }
}


- (NSArray *)gainDataArrayWithFeedId:(NSInteger)feedId {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"SELECT * FROM partnerPraiseHistoryList WHERE feedId=?",[NSString stringWithFormat:@"%ld",(long)feedId]];
        
        while ([set next]) {
            PartnerPraiseModel *model = [[PartnerPraiseModel alloc] init];
            NSDictionary *dict = [set resultDictionary];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
        
        [set close];
    }else {
        NSLog(@"fail to open");
    }
    
    return array;
}

@end
