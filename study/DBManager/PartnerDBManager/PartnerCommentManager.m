//
//  PartnerCommentManager.m
//  study
//
//  Created by yang on 16/1/4.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import "PartnerCommentManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "PartnerCommentModel.h"

@interface PartnerCommentManager ()

{
    FMDatabase *db;
}

@end

@implementation PartnerCommentManager

+ (PartnerCommentManager *)shareInstence {
    static PartnerCommentManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PartnerCommentManager alloc] init];
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
                [db executeUpdate:@"CREATE TABLE partnerCommentList (commentId integer primary key AUTOINCREMENT, userId integer, feedId integer, addTime text, nickname text, photo text, phone integer, commentedId integer, commentDetail text, deleteFlag integer)"];
            }else {
                NSLog(@"fail to open");
            }
        }
    }
    
    return self;
}

- (void)insertWithModel:(PartnerCommentModel *)model {
    if ([db open]) {
        [db executeUpdate:@"insert into partnerCommentList (commentId,userId,feedId,addTime,nickname,photo,phone,commentedId,commentDetail,deleteFlag) values(?,?,?,?,?,?,?,?,?,?)",[NSString stringWithFormat:@"%ld",(long)model.commentId],[NSString stringWithFormat:@"%ld",(long)model.userId],[NSString stringWithFormat:@"%ld",(long)model.feedId],model.addTime,model.nickname,model.photo,[NSString stringWithFormat:@"%ld",(long)model.phone],[NSString stringWithFormat:@"%ld",(long)model.commentedId],model.commentDetail,[NSString stringWithFormat:@"%ld",(long)model.deleteFlag]];
    }else{
        NSLog(@"fail to open");
    }
}

- (void)delFeedId:(NSInteger)feedId {
    if ([db open]) {
        [db executeUpdate:@"DELETE FROM partnerCommentList WHERE feedId=?",[NSString stringWithFormat:@"%ld",(long)feedId]];
    }else {
        NSLog(@"fail to open");
    }
}

- (void)delCommentId:(NSInteger)commentId {
    if ([db open]) {
        [db executeUpdate:@"DELETE FROM partnerCommentList WHERE commentId=?",[NSString stringWithFormat:@"%ld",(long)commentId]];
    }else {
        NSLog(@"fail to open");
    }
}

- (void)clearAllData {
    if ([db open]) {
        if ([db executeUpdate:@"DELETE FROM partnerCommentList"]) {
            
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
        FMResultSet *set = [db executeQuery:@"SELECT * FROM partnerCommentList WHERE feedId=? order by addTime asc",[NSString stringWithFormat:@"%ld",(long)feedId]];
        
        while ([set next]) {
            PartnerCommentModel *model = [[PartnerCommentModel alloc] init];
            NSDictionary *dict = [set resultDictionary];
            [model setValuesForKeysWithDictionary:dict];
            [array addObject:model];
        }
        
        [set close];
        
        // 取出的数组是按时间升序排序的,不能直接使用
        if (array.count > 0) {
            
            for (int i = 0; i < array.count; i ++){
                PartnerCommentModel *model = array[i];
                
                if (model.commentedId != 0) {
                    
                    for (int j = 0; j < i; j++) {
                        PartnerCommentModel *mod = array[j];
                        
                        if (mod.commentId == model.commentedId) {
                            [array removeObject:model];
                            [array insertObject:model atIndex:j+1];
                        }
                    }
                }
            }
        }
    }else {
        NSLog(@"fail to open");
    }
    
    return array;
}

@end
