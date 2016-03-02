//
//  ChatMsgListManage.m
//  jinherIU
//  消息管理类
//  Created by mijibao on 14-6-17.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import "ChatMsgListManage.h"
#import "JZCommon.h"
#import "MsgSummaryManage.h"


static ChatMsgListManage *instnce;

@implementation ChatMsgListManage

+ (id)shareInstance {
    @synchronized(self){
        if (instnce == nil) {
            instnce = [[[self class] alloc] init];
        }
    }
    return instnce;
}

//根据id查询消息
- (ChatMsgDTO *)queryChatMsg:(NSString *)msgId{
    ChatMsgDTO *model=[[ChatMsgDTO alloc]init];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM zChatMsgList where zmsgid=? and zownerid=?",msgId,[JZCommon getUserPhone]];
        
        while ([resultSet next]) {
            
            model.msgid=[resultSet stringForColumn:@"zmsgid"];
            model.fromuid=[resultSet stringForColumn:@"zfromuid"];
            model.touid=[resultSet stringForColumn:@"ztouid"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.sendtime=[resultSet stringForColumn:@"zsendtime"];
            model.orderytime=[resultSet dateForColumn:@"zorderytime"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.sendtype=[resultSet intForColumn:@"zsendtype"];
            model.url=[resultSet stringForColumn:@"zurl"];
            model.isread=[resultSet stringForColumn:@"zisread"];
            model.name=[resultSet stringForColumn:@"zname"];
            model.thumbnail=[resultSet stringForColumn:@"zthumbnail"];
            model.duration=[resultSet stringForColumn:@"zduration"];
            model.totalsize=[resultSet stringForColumn:@"ztotalsize"];
            model.success=[resultSet intForColumn:@"zsuccess"];
            model.progress=[resultSet stringForColumn:@"zprgress"];
            break;
        }
        [resultSet close];
    }];
    
    return model;
}

//查询消息是否存在
-(BOOL)queryMsgIsExist:(NSString *)msgId{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT count(1) as zcount FROM zChatMsgList where zmsgid=? and zownerid=?",msgId,[JZCommon getUserPhone]];
        while ([resultSet next]) {
            int count=[resultSet intForColumn:@"zcount"];
            if (count>0) {
                result=true;
            }
        }
        [resultSet close];
    }];
    return result;
}

//查询消息列表
- (NSMutableArray *)readChatMsgList:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype :(NSInteger)count{
    NSMutableArray *stations = [NSMutableArray array];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
    
        FMResultSet *resultSet;
        if (count>=0) {
            //单聊
            if (chattype==0) {
                resultSet = [database executeQuery:@"SELECT * FROM zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?)) order by zorderytime desc limit 10 offset ?",[JZCommon getUserPhone],fromuid,touid,@"1",touid,fromuid,@"0",[NSString stringWithFormat:@"%ld",count]];
            }
            else{
                resultSet = [database executeQuery:@"SELECT * FROM zChatMsgList where zownerid=? and ztouid=?  order by zorderytime desc limit 10 offset ?",touid,fromuid,[NSString stringWithFormat:@"%ld",(long)count]];
            }
        }
        else{
            //单聊
            if (chattype==0) {
                resultSet = [database executeQuery:@"select * from (SELECT * FROM zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?))  order by zorderytime desc limit 10 offset ? ) order by zorderytime ",[JZCommon getUserPhone],fromuid,touid,@"1",touid,fromuid,@"0",[NSString stringWithFormat:@"%ld",(long)count]];
            }
            else{
                resultSet = [database executeQuery:@"select * from (SELECT * FROM zChatMsgList where zownerid=? and ztouid=?  order by zorderytime desc limit 10 offset ?) order by zorderytime",touid,fromuid,[NSString stringWithFormat:@"%ld",(long)count]];
            }
        }
        while ([resultSet next]) {
            ChatMsgDTO *model=[[ChatMsgDTO alloc]init];
            model.msgid=[resultSet stringForColumn:@"zmsgid"];
            model.fromuid=[resultSet stringForColumn:@"zfromuid"];
            model.touid=[resultSet stringForColumn:@"ztouid"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.sendtime=[resultSet stringForColumn:@"zsendtime"];
            model.orderytime=[resultSet dateForColumn:@"zorderytime"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.sendtype=[resultSet intForColumn:@"zsendtype"];
            model.url=[resultSet stringForColumn:@"zurl"];
            model.isread=[resultSet stringForColumn:@"zisread"];
            model.localpath=[resultSet stringForColumn:@"zlocalpath"];
            model.name=[resultSet stringForColumn:@"zname"];
            model.thumbnail=[resultSet stringForColumn:@"zthumbnail"];
            model.duration=[resultSet stringForColumn:@"zduration"];
            model.totalsize=[resultSet stringForColumn:@"ztotalsize"];
            model.success=[resultSet intForColumn:@"zsuccess"];
            model.progress=[resultSet stringForColumn:@"zprgress"];
            model.receiverread = [resultSet stringForColumn:@"receiverread"];
            model.chatphoto=[resultSet stringForColumn:@"chatphoto"];
            model.questionID = [resultSet stringForColumn:@"questionID"];
            [stations insertObject:model atIndex:0];
        }
        [resultSet close];
    
    }];
    return stations;
}
//查询当前会话的所有图片
- (NSMutableArray *)readChatMsgListImageWith:(NSString *)fromuid :(NSString *)touid{
    NSMutableArray *stations = [NSMutableArray array];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM zChatMsgList where zownerid=? and zfiletype=? and zthumbnail = '0' and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?)) order by zorderytime desc",[JZCommon getUserPhone],@"2",fromuid,touid,@"1",touid,fromuid,@"0"];
        while ([resultSet next]) {
            ChatMsgDTO *model=[[ChatMsgDTO alloc]init];
            model.msgid=[resultSet stringForColumn:@"zmsgid"];
            model.fromuid=[resultSet stringForColumn:@"zfromuid"];
            model.touid=[resultSet stringForColumn:@"ztouid"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.sendtime=[resultSet stringForColumn:@"zsendtime"];
            model.orderytime=[resultSet dateForColumn:@"zorderytime"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.sendtype=[resultSet intForColumn:@"zsendtype"];
            model.url=[resultSet stringForColumn:@"zurl"];
            model.isread=[resultSet stringForColumn:@"zisread"];
            model.localpath=[resultSet stringForColumn:@"zlocalpath"];
            model.name=[resultSet stringForColumn:@"zname"];
            model.thumbnail=[resultSet stringForColumn:@"zthumbnail"];
            model.duration=[resultSet stringForColumn:@"zduration"];
            model.totalsize=[resultSet stringForColumn:@"ztotalsize"];
            model.success=[resultSet intForColumn:@"zsuccess"];
            model.progress=[resultSet stringForColumn:@"zprgress"];
            model.receiverread = [resultSet stringForColumn:@"receiverread"];
            model.chatphoto=[resultSet stringForColumn:@"chatphoto"];
            [stations insertObject:model atIndex:0];
        }
        [resultSet close];
    }];
    
    return stations;
}
//搜索聊天记录进入聊天获取数据源查询
- (NSMutableArray *)readSearchMsgList:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype :(NSString *)msgid :(NSInteger)type{
    NSMutableArray *stations = [NSMutableArray array];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet;
        if (type == 0) {
            if (chattype == 0) {
                resultSet =[database executeQuery: @"select * from (SELECT * FROM zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?)) and (rowid-(SELECT rowid FROM zChatMsgList where zmsgid=?))<0 order by zorderytime desc) order by rowid asc limit 10000",[JZCommon getUserPhone],fromuid,touid,@"1",touid,fromuid,@"0",msgid];
            }else{
                resultSet =[database executeQuery: @"select * from (SELECT * FROM zChatMsgList where zownerid=? and ztouid=? and (rowid-(SELECT rowid FROM zChatMsgList where zmsgid=?))<0 order by zorderytime desc) order by rowid asc limit 10000",touid,fromuid,msgid];
            }
            
        }else{
            if (chattype == 0) {
                resultSet =[database executeQuery: @"select * from (SELECT * FROM zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?)) and (rowid-(SELECT rowid FROM zChatMsgList where zmsgid=?))>=0 order by zorderytime desc) order by rowid desc limit 10000",[JZCommon getUserPhone],fromuid,touid,@"1",touid,fromuid,@"0",msgid];
            }else{
                resultSet =[database executeQuery: @"select * from (SELECT * FROM zChatMsgList where zownerid=? and ztouid=? and (rowid-(SELECT rowid FROM zChatMsgList where zmsgid=?))>=0 order by zorderytime desc) order by rowid desc limit 10000",touid,fromuid,msgid];
            }
        }
        
        while ([resultSet next]) {
            ChatMsgDTO *model=[[ChatMsgDTO alloc]init];
            model.msgid=[resultSet stringForColumn:@"zmsgid"];
            model.fromuid=[resultSet stringForColumn:@"zfromuid"];
            model.touid=[resultSet stringForColumn:@"ztouid"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.sendtime=[resultSet stringForColumn:@"zsendtime"];
            model.orderytime=[resultSet dateForColumn:@"zorderytime"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.sendtype=[resultSet intForColumn:@"zsendtype"];
            model.url=[resultSet stringForColumn:@"zurl"];
            model.isread=[resultSet stringForColumn:@"zisread"];
            model.localpath=[resultSet stringForColumn:@"zlocalpath"];
            model.name=[resultSet stringForColumn:@"zname"];
            model.thumbnail=[resultSet stringForColumn:@"zthumbnail"];
            model.duration=[resultSet stringForColumn:@"zduration"];
            model.totalsize=[resultSet stringForColumn:@"ztotalsize"];
            model.success=[resultSet intForColumn:@"zsuccess"];
            model.progress=[resultSet stringForColumn:@"zprgress"];
            
            [stations addObject:model];
        }
        [resultSet close];
        
    }];
    
    return stations;
}
- (NSMutableArray *)readMsgList:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype :(NSString *)msgid :(NSInteger)type{
    NSMutableArray *stations = [NSMutableArray array];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet;
        if (type == 0) {
            if (chattype == 0) {
                resultSet =[database executeQuery: @"select * from (SELECT * FROM zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?)) and (rowid-(SELECT rowid FROM zChatMsgList where zmsgid=?))<0 order by zorderytime desc) order by rowid asc limit 10",[JZCommon getUserPhone],fromuid,touid,@"1",touid,fromuid,@"0",msgid];
            }else{
                resultSet =[database executeQuery: @"select * from (SELECT * FROM zChatMsgList where zownerid=? and ztouid=? and (rowid-(SELECT rowid FROM zChatMsgList where zmsgid=?))<0 order by zorderytime desc) order by rowid asc limit 10",touid,fromuid,msgid];
            }

        }else{
            if (chattype == 0) {
                resultSet =[database executeQuery: @"select * from (SELECT * FROM zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?)) and (rowid-(SELECT rowid FROM zChatMsgList where zmsgid=?))>=0 order by zorderytime desc) order by rowid desc limit 10",[JZCommon getUserPhone],fromuid,touid,@"1",touid,fromuid,@"0",msgid];
            }else{
                resultSet =[database executeQuery: @"select * from (SELECT * FROM zChatMsgList where zownerid=? and ztouid=? and (rowid-(SELECT rowid FROM zChatMsgList where zmsgid=?))>=0 order by zorderytime desc) order by rowid desc limit 10",touid,fromuid,msgid];
        }
        }
        
        while ([resultSet next]) {
            ChatMsgDTO *model=[[ChatMsgDTO alloc]init];
            model.msgid=[resultSet stringForColumn:@"zmsgid"];
            model.fromuid=[resultSet stringForColumn:@"zfromuid"];
            model.touid=[resultSet stringForColumn:@"ztouid"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.sendtime=[resultSet stringForColumn:@"zsendtime"];
            model.orderytime=[resultSet dateForColumn:@"zorderytime"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.sendtype=[resultSet intForColumn:@"zsendtype"];
            model.url=[resultSet stringForColumn:@"zurl"];
            model.isread=[resultSet stringForColumn:@"zisread"];
            model.localpath=[resultSet stringForColumn:@"zlocalpath"];
            model.name=[resultSet stringForColumn:@"zname"];
            model.thumbnail=[resultSet stringForColumn:@"zthumbnail"];
            model.duration=[resultSet stringForColumn:@"zduration"];
            model.totalsize=[resultSet stringForColumn:@"ztotalsize"];
            model.success=[resultSet intForColumn:@"zsuccess"];
            model.progress=[resultSet stringForColumn:@"zprgress"];
            
            [stations addObject:model];
        }
        [resultSet close];
        
    }];
    
    return stations;
}

//查询聊天信息
- (NSMutableArray *)queryChatContent:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype{
    NSMutableArray *stations = [NSMutableArray array];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
    
        FMResultSet *resultSet;
        //单聊
        if (chattype==0) {
            resultSet = [database executeQuery:@"SELECT * FROM zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=? ) or (zfromuid=? AND ztouid=? AND zsendtype=?)) AND zfiletype=0",[JZCommon getUserPhone],fromuid,touid,@"1",touid,fromuid,@"0"];
        }
        else{
            resultSet = [database executeQuery:@"SELECT * FROM zChatMsgList where zownerid=? and ztouid=? and zfiletype=0",touid,fromuid];
        }
        while ([resultSet next]) {
            ChatMsgDTO *model=[[ChatMsgDTO alloc]init];
            model.msgid=[resultSet stringForColumn:@"zmsgid"];
            model.fromuid=[resultSet stringForColumn:@"zfromuid"];
            model.touid=[resultSet stringForColumn:@"ztouid"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.sendtime=[resultSet stringForColumn:@"zsendtime"];
            model.orderytime=[resultSet dateForColumn:@"zorderytime"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.sendtype=[resultSet intForColumn:@"zsendtype"];
            model.url=[resultSet stringForColumn:@"zurl"];
            model.isread=[resultSet stringForColumn:@"zisread"];
            model.localpath=[resultSet stringForColumn:@"zlocalpath"];
            model.name=[resultSet stringForColumn:@"zname"];
            model.thumbnail=[resultSet stringForColumn:@"zthumbnail"];
            model.duration=[resultSet stringForColumn:@"zduration"];
            model.totalsize=[resultSet stringForColumn:@"ztotalsize"];
            model.success=[resultSet intForColumn:@"zsuccess"];
            model.progress=[resultSet stringForColumn:@"zprgress"];
            [stations insertObject:model atIndex:0];
        }
        [resultSet close];
    }];
    return stations;
}

//查询申请列表
- (NSMutableArray *)queryApplyList{
    NSMutableArray *stations = [NSMutableArray array];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        
        FMResultSet *resultSet;
        
        resultSet = [database executeQuery:@"SELECT * FROM zChatMsgList where zchattype=3 and zownerid=?",[JZCommon getUserPhone]];
        while ([resultSet next]) {
            ChatMsgDTO *model=[[ChatMsgDTO alloc]init];
            model.msgid=[resultSet stringForColumn:@"zmsgid"];
            model.fromuid=[resultSet stringForColumn:@"zfromuid"];
            model.touid=[resultSet stringForColumn:@"ztouid"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.sendtime=[resultSet stringForColumn:@"zsendtime"];
            model.url=[resultSet stringForColumn:@"zurl"];
            model.name=[resultSet stringForColumn:@"zname"];
            model.isread=[resultSet stringForColumn:@"zisread"];
            model.localpath=[resultSet stringForColumn:@"zlocalpath"];
            model.thumbnail=[resultSet stringForColumn:@"zthumbnail"];
            [stations insertObject:model atIndex:0];
        }
        [resultSet close];
    }];
    return stations;
}

//根据消息id查询userid
- (NSString *)queryUseridWithMsgid:(NSString *)msgid{

    __block NSString *userId;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        
        FMResultSet *resultSet;
        
        resultSet = [database executeQuery:@"SELECT zfromuid FROM zChatMsgList where zchattype=3 and zmsgid=?",msgid];
        while ([resultSet next]) {
            userId = [resultSet stringForColumn:@"zfromuid"];
        }
        [resultSet close];
    }];
    return userId;
}

//审核更新列表
- (BOOL)updateMsgList:(ChatMsgDTO *)msgDto{
    
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        result=[database executeUpdate:@"update zChatMsgList set zisread=?,zlocalpath=? where zmsgid=? and zownerid=? and zchattype=3",msgDto.isread,msgDto.localpath,msgDto.msgid,[JZCommon getUserPhone]];
    }];
    
    return result;
}

//取所有聊天记录
- (NSMutableArray *)readAllChatMsgList:(NSInteger)chattype{
    NSMutableArray *stations = [NSMutableArray array];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet;
        resultSet = [database executeQuery:@"SELECT * FROM zChatMsgList where zchattype=? and zfiletype=0 and zownerid=?",[NSString stringWithFormat:@"%ld",(long)chattype],[JZCommon getUserPhone]];
        while ([resultSet next]) {
            ChatMsgDTO *model=[[ChatMsgDTO alloc]init];
            model.msgid=[resultSet stringForColumn:@"zmsgid"];
            model.fromuid=[resultSet stringForColumn:@"zfromuid"];
            model.touid=[resultSet stringForColumn:@"ztouid"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.sendtime=[resultSet stringForColumn:@"zsendtime"];
            model.orderytime=[resultSet dateForColumn:@"zorderytime"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.sendtype=[resultSet intForColumn:@"zsendtype"];
            model.chatType=[resultSet intForColumn:@"zchattype"];
            model.url=[resultSet stringForColumn:@"zurl"];
            model.isread=[resultSet stringForColumn:@"zisread"];
            model.localpath=[resultSet stringForColumn:@"zlocalpath"];
            model.name=[resultSet stringForColumn:@"zname"];
            model.thumbnail=[resultSet stringForColumn:@"zthumbnail"];
            model.duration=[resultSet stringForColumn:@"zduration"];
            model.totalsize=[resultSet stringForColumn:@"ztotalsize"];
            model.success=[resultSet intForColumn:@"zsuccess"];
            model.progress=[resultSet stringForColumn:@"zprgress"];
            [stations insertObject:model atIndex:0];
        }
    
        [resultSet close];
        
    }];
    return stations;
}

//删除消息的方法
- (BOOL)deleteChatMsg:(ChatMsgDTO *)msg{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //删除数据
        [database executeUpdate:@"delete from zChatMsgList where zmsgid=? and zownerid=?",msg.msgid,[JZCommon getUserPhone]];
    
    }];
    
    return result;
    
}

//批量删除消息
- (BOOL)deleteChatMsglist:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
    
        //单聊
        if (chattype==0) {
            //删除数据
            [database executeUpdate:@"delete from zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?))",touid,fromuid,touid,@"1",touid,fromuid,@"0"];
            
        }
        else{
            //删除数据
            [database executeUpdate:@"delete from zChatMsgList where zownerid=? and ztouid=?",touid,fromuid];
        }
    
    }];
    return result;
}

//清空消息
- (BOOL)clearChatMsglist{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //删除数据
        [database executeUpdate:@"delete from zChatMsgList where zownerid=? ",[JZCommon getUserPhone]];
    
    }];
    return result;
}

//删除所有消息
- (BOOL)deleteAllChatMsg{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //删除数据
        [database executeUpdate:@"delete from zChatMsgList "];
    }];
    return result;
}

//保存微信消息
- (BOOL)saveChatMsg:(ChatMsgDTO *)msg{
    BOOL result=NO;
    
    //数据库中不存在  先不判定 ===============
    if (![self queryMsgIsExist:msg.msgid]) {
        FMDatabaseQueue *queue = [self.class sharedQueue];
        [queue inDatabase:^(FMDatabase *database) {
            //插入数据
            [database executeUpdate:@"insert into zChatMsgList(zmsgid,zfromuid,ztouid,zcontent,zsendtime,zorderytime,zfiletype,zsendtype,zurl,zisread,zname,zthumbnail,zduration,zsuccess,zlocalpath,zownerid,zchattype,zprgress,ztotalsize,chatphoto,receiverread,questionID) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",msg.msgid,msg.fromuid,msg.touid,msg.content,msg.sendtime,[JZCommon stringToDate:msg.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"],[NSString stringWithFormat:@"%ld",(long)msg.filetype],[NSString stringWithFormat:@"%ld",(long)msg.sendtype],msg.url,msg.isread,msg.name,msg.thumbnail,msg.duration,[NSString stringWithFormat:@"%ld",(long)msg.success],msg.localpath,[JZCommon getUserPhone],[NSString stringWithFormat:@"%ld",(long)msg.chatType],msg.progress,msg.totalsize,msg.chatphoto,msg.receiverread,msg.questionID];
        }];
    }
    return result;
}

//保存申请加入组织消息
- (BOOL)saveJoinOrgMsg:(ChatMsgDTO *)msg{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    //数据库中不存在
    if (![self queryJoinOrgMsgIsExist:msg.fromuid]) {
        [queue inDatabase:^(FMDatabase *database) {
            //插入数据
            [database executeUpdate:@"insert into zChatMsgList(zmsgid,zfromuid,ztouid,zcontent,zsendtime,zorderytime,zfiletype,zsendtype,zurl,zisread,zname,zthumbnail,zduration,zsuccess,zlocalpath,zownerid,zchattype,zprgress,ztotalsize) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",msg.msgid,msg.fromuid,msg.touid,msg.content,msg.sendtime,[JZCommon stringToDate:msg.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"],[NSString stringWithFormat:@"%ld",(long)msg.filetype],[NSString stringWithFormat:@"%ld",(long)msg.sendtype],msg.url,msg.isread,msg.name,msg.thumbnail,msg.duration,[NSString stringWithFormat:@"%ld",(long)msg.success],msg.localpath,[JZCommon getUserPhone],[NSString stringWithFormat:@"%ld",(long)msg.chatType],msg.progress,msg.totalsize];
        }];
    }//数据库中存在并且审核过了
    else if([self queryJoinOrgMsgIsAudit:msg.fromuid] ){
        if (![self queryJoinOrgMsgIsExistAudit:msg.fromuid]) {
            [queue inDatabase:^(FMDatabase *database) {
                //插入数据
                [database executeUpdate:@"insert into zChatMsgList(zmsgid,zfromuid,ztouid,zcontent,zsendtime,zorderytime,zfiletype,zsendtype,zurl,zisread,zname,zthumbnail,zduration,zsuccess,zlocalpath,zownerid,zchattype,zprgress,ztotalsize) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",msg.msgid,msg.fromuid,msg.touid,msg.content,msg.sendtime,[JZCommon stringToDate:msg.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"],[NSString stringWithFormat:@"%ld",(long)msg.filetype],[NSString stringWithFormat:@"%ld",(long)msg.sendtype],msg.url,msg.isread,msg.name,msg.thumbnail,msg.duration,[NSString stringWithFormat:@"%ld",(long)msg.success],msg.localpath,[JZCommon getUserPhone],[NSString stringWithFormat:@"%ld",(long)msg.chatType],msg.progress,msg.totalsize];
            }];
        }else{
            [self updateJoinOrgMsgSuccess:msg];
        }
    }else{
        [self updateJoinOrgMsgSuccess:msg];
    }
    return result;
}

//查询消息是否存在
-(BOOL)queryJoinOrgMsgIsExist:(NSString *)fromuid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT count(1) as zcount FROM zChatMsgList where zfromuid=? and zownerid=? and zchattype=3",fromuid,[JZCommon getUserPhone]];
        while ([resultSet next]) {
            int count=[resultSet intForColumn:@"zcount"];
            if (count>0) {
                result=true;
            }
        }
        [resultSet close];
    }];
    return result;
}

//查询消息是否存在并且审核过了
-(BOOL)queryJoinOrgMsgIsAudit:(NSString *)fromuid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT count(1) as zcount FROM zChatMsgList where zfromuid=? and zownerid=? and zchattype=3 and (zisread=0 or zisread=1)",fromuid,[JZCommon getUserPhone]];
        while ([resultSet next]) {
            int count=[resultSet intForColumn:@"zcount"];
            if (count>0) {
                result=true;
            }
        }
        [resultSet close];
    }];
    return result;
}

//查询消息是否审核之后存在
-(BOOL)queryJoinOrgMsgIsExistAudit:(NSString *)fromuid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT count(1) as zcount FROM zChatMsgList where zfromuid=? and zownerid=? and zchattype=3 and zisread is not 0 and zisread is not 1",fromuid,[JZCommon getUserPhone]];
        while ([resultSet next]) {
            int count=[resultSet intForColumn:@"zcount"];
            if (count>0) {
                result=true;
            }
        }
        [resultSet close];
    }];
    return result;
}

//更新加入组织发送消息
- (BOOL)updateJoinOrgMsgSuccess:(ChatMsgDTO *)msg{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        [database executeUpdate:@"update zChatMsgList set zmsgid=?,ztouid=?,zcontent=?,zsendtime=?,zorderytime=?,zurl=?,zname=?,zthumbnail=?,zduration=? where zfromuid=? and zownerid=? and zchattype=3 and zisread is not 0 and zisread is not 1",msg.msgid,msg.touid,msg.content,msg.sendtime,[JZCommon stringToDate:msg.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"],msg.url,msg.name,msg.thumbnail,msg.duration,msg.fromuid,[JZCommon getUserPhone]];
        
    }];

    return result;
}

//更新消息发送状态
- (BOOL)saveSendMsgSuccess:(ChatMsgDTO *)msg{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        [database executeUpdate:@"update zChatMsgList set zsuccess=?,zsendtime=?,zorderytime=? where zmsgid=? and zownerid=?",[NSString stringWithFormat:@"%ld",(long)msg.success],msg.sendtime,[JZCommon stringToDate:msg.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"],msg.msgid,[JZCommon getUserPhone]];
        
    }];
    //更新汇总消息表发送状态
    [[MsgSummaryManage shareInstance] updateMsgSummarystate:msg.success :msg.msgid];
    return result;
}

//更新消息已读状态
- (BOOL)saveSendMsgRead:(ChatMsgDTO *)msg{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        [database executeUpdate:@"update zChatMsgList set zisread=? where zmsgid=? and zownerid=?",msg.isread,msg.msgid,[JZCommon getUserPhone]];
        
    
    }];
    //更新汇总消息已读状态
    [[MsgSummaryManage shareInstance] updateMsgSummaryread:msg.isread :msg.msgid];
    return result;
}

//更新消息已读状态
- (BOOL)updateReceiverMsgRead:(NSString *)msgId{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        [database executeUpdate:@"update zChatMsgList set receiverread=? where zmsgid=? and zownerid=?",@"1",msgId,[JZCommon getUserPhone]];
        
        
    }];
    return result;
}
- (void)updateReceiverNotRead:(NSString *)msgId{
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        [database executeUpdate:@"update zChatMsgList set receiverread=? where zmsgid=? and zownerid=?",@"0",msgId,[JZCommon getUserPhone]];
    }];
}

//更新消息本地地址
- (BOOL)saveSendMsgLocalpath:(ChatMsgDTO *)msg{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        [database executeUpdate:@"update zChatMsgList set zlocalpath=? where zmsgid=? and zownerid=?",msg.localpath,msg.msgid,[JZCommon getUserPhone]];
    }];
    return result;
}

//上传完毕后更新消息
- (BOOL)updateMsgurl:(ChatMsgDTO *)msg{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        [database executeUpdate:@"update zChatMsgList set zurl=?,zthumbnail=? where zmsgid=? and zownerid=?",msg.url,msg.thumbnail,msg.msgid,[JZCommon getUserPhone]];
    
    }];
    return result;
}

//更新消息
-(BOOL)updateChatMsg:(NSString *)msgid filed:(NSString*)filed content:(NSString *)content{
    BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE zChatMsgList SET '%@' = '%@' WHERE zmsgid = '%@' and zownerid='%@'",filed,content,msgid,[JZCommon getUserPhone]];
        //更新数据
        [database executeUpdate:updateSql];
    }];
    return result;
}


//查询消息列表是否存在
- (BOOL)checkChatMsgList:(NSString *)fromuid :(NSInteger)chattype{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        
        FMResultSet *resultSet;
        //单聊
        if (chattype==0) {
            resultSet = [database executeQuery:@"SELECT count(1) as zcount FROM zChatMsgList where zownerid=? and ((zfromuid=? AND ztouid=? AND zsendtype=?) or (zfromuid=? AND ztouid=? AND zsendtype=?))",[JZCommon getUserPhone],fromuid,[JZCommon getUserPhone],@"1",[JZCommon getUserPhone],fromuid,@"0"];
        }
        else{
            resultSet = [database executeQuery:@"SELECT count(1) as zcount FROM zChatMsgList where zownerid=? and ztouid=? ",[JZCommon getUserPhone],fromuid];
        }
        
        while ([resultSet next]) {
            int count=[resultSet intForColumn:@"zcount"];
            if (count>0) {
                result=true;
            }
        }
        [resultSet close];
        
    }];
    return result;
}
@end
