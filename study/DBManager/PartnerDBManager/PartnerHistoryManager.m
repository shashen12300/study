
//
//  PartnerHistoryManager.m
//  study
//
//  Created by yang on 16/1/11.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import "PartnerHistoryManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "PartnerAllModel.h"
#import "PartnerPraiseHistoryManager.h"
#import "PartnerCommentHistoryManager.h"

@interface PartnerHistoryManager ()

{
    FMDatabase *db;
}

@end

@implementation PartnerHistoryManager

+ (PartnerHistoryManager *)shareInstance {
    static PartnerHistoryManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PartnerHistoryManager alloc] init];
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
                [db executeUpdate:@"CREATE TABLE partnerHistoryList (feedId integer primary key AUTOINCREMENT, content text, userId integer, visibleRange text, photourl text, smphotourl text, firstpicurl text, urlcontent text, title text, url text, webcontent text, videoSign text, location text, lecrureId integer, picurl text, duration integer, addtimeB text, titleB text, grade text, subject text, type text, addTime text, commentCount integer, invalid integer, nickname text, nicknameB text, phone integer, photo text, praiseCount integer, signature text, urlB text, picture text, uid integer)"];
            }else{
                NSLog(@"fail to open");
            }
        }
    }
    return self;
}

- (void)insertWithModel:(PartnerPartModel *)model {
    if ([db open]) {
        [db executeUpdate:@"insert into partnerHistoryList (feedId,content,userId,visibleRange,photourl,smphotourl,firstpicurl,urlcontent,title,url,webcontent,videoSign,location,lecrureId,picurl,duration,addtimeB,titleB,grade,subject,type,addTime,commentCount,invalid,nickname,nicknameB,phone,photo,praiseCount,signature,urlB,picture,uid) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[NSString stringWithFormat:@"%ld",(long)model.feedId],model.content,[NSString stringWithFormat:@"%ld",(long)model.userId],model.visibleRange,model.photourl,model.smphotourl,model.firstpicurl,model.urlcontent,model.title,model.url,model.webcontent,model.videoSign,model.location,model.lecrureId,model.picurl,[NSString stringWithFormat:@"%ld",(long)model.duration],model.addtimeB,model.titleB,model.grade,model.subject,model.type,model.addTime,[NSString stringWithFormat:@"%ld",(long)model.commentCount],[NSString stringWithFormat:@"%ld",(long)model.invalid],model.nickname,model.nicknameB,[NSString stringWithFormat:@"%ld",(long)model.phone],model.photo,[NSString stringWithFormat:@"%ld",(long)model.praiseCount],model.signature,model.urlB,model.picture,[NSString stringWithFormat:@"%ld",(long)model.uid]];
    }else{
        NSLog(@"fail to open");
    }
}

- (void)delFeedId:(NSInteger)feedId
{
    if ([db open]) {
        [db executeUpdate:@"DELETE FROM partnerHistoryList WHERE feedId=?",[NSString stringWithFormat:@"%ld",(long)feedId]];
        
        [[PartnerPraiseHistoryManager shareInstence] delFeedId:feedId];
        [[PartnerCommentHistoryManager shareInstence] delFeedId:feedId];
    }else {
        NSLog(@"fail to open");
    }
}

- (void)clearAllData
{
    if ([db open]) {
        if ([db executeUpdate:@"DELETE FROM partnerHistoryList"]) {
            [[PartnerPraiseHistoryManager shareInstence] clearAllData];
            [[PartnerCommentHistoryManager shareInstence] clearAllData];
        }else{
            NSLog(@"fail to clear");
        }
    }else{
        NSLog(@"fail to open");
    }
}


- (NSArray *)gainDataArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"SELECT * FROM partnerHistoryList order by addTime desc"];
        
        while ([set next]) {
            PartnerPartModel *model = [[PartnerPartModel alloc] init];
            NSDictionary *dict = [set resultDictionary];
            [model setValuesForKeysWithDictionary:dict];
            PartnerAllModel *allModel = [[PartnerAllModel alloc] init];
            allModel.model = model;
            allModel.userPraise = (NSMutableArray *)[[PartnerPraiseHistoryManager shareInstence] gainDataArrayWithFeedId:model.feedId];
            allModel.userComment = (NSMutableArray *)[[PartnerCommentHistoryManager shareInstence] gainDataArrayWithFeedId:model.feedId];
            [array addObject:allModel];
        }
        
        [set close];
    }else {
        NSLog(@"fail to open");
    }
    
    return array;
}

@end