//
//  MsgSummaryManage.m
//  jinherIU
//  消息汇总信息管理类
//  Created by mijibao on 14-6-17.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import "MsgSummaryManage.h"
#import "AppDelegate.h"
#import "RegexKitLite.h"
#import "JZCommon.h"
#import "ChatMsgListManage.h"

static MsgSummaryManage *instnce;
#define maxcontentlength 15
#define BEGIN_FLAG @"["
#define END_FLAG @"]"

@implementation MsgSummaryManage

+ (id)shareInstance {
    static MsgSummaryManage *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MsgSummaryManage alloc] init];
    });
    return _sharedInstance;
}

//查询微信消息
- (MsgSummary *)queryMsgSummaryBychatid:(NSString *)fromId{
    MsgSummary *model=[[MsgSummary alloc] init];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM zMsgSummary where zownerid=? and zmsgid=? order by ztoptime,zdate",[JZCommon queryLoginUserId],fromId];
        while ([resultSet next]) {
            model.ownerid=[resultSet stringForColumn:@"zownerid"];
            model.chartype=[resultSet intForColumn:@"zchartype"];
            model.toptime=[resultSet stringForColumn:@"ztoptime"];
            model.date=[resultSet dateForColumn:@"zdate"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.count=[resultSet intForColumn:@"zcount"];
            model.istop=[resultSet boolForColumn:@"zistop"];
            model.chatid=[resultSet stringForColumn:@"zchatid"];
            model.grade = [resultSet stringForColumn:@"grade"];
            model.subjects = [resultSet stringForColumn:@"subjects"];
            model.teacherID = [resultSet stringForColumn:@"teacherID"];
            break;
        }
        [resultSet close];
        
    }];
    
    return model;
}

//查询汇总消息是否存在
-(BOOL)queryMsgSummaryIsExist:(NSString *)fromId{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT count(1) as zcount FROM zMsgSummary where zownerid=? and zchatid=? order by ztoptime,zdate",[JZCommon queryLoginUserId],fromId];
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

//删除消息汇总
- (BOOL)deleteMsgSummary:(NSString *)chatid :(NSInteger)chattype{
    
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {

        //删除数据
        result=[database executeUpdate:@"delete from zMsgSummary where zownerid=? and zchatid=? ",[JZCommon queryLoginUserId],chatid];
    
    }];
    //级联删除消息列表
    [[ChatMsgListManage shareInstance] deleteChatMsglist:chatid :[JZCommon queryLoginUserId] :chattype];
    
    return result;
}

//清空聊天记录
- (BOOL)clearMsgSummary{
    
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //删除数据
        result=[database executeUpdate:@"delete from zMsgSummary where zownerid=? ",[JZCommon queryLoginUserId]];
    
    }];
    
    //级联清空消息列表
    [[ChatMsgListManage shareInstance] clearChatMsglist];
    
    return result;
}

//删除所有聊天记录
- (BOOL)deleteAllMsgSummary{
    
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //删除数据
        result=[database executeUpdate:@"delete from zMsgSummary "];
    
    }];
    //级联清空消息列表
    [[ChatMsgListManage shareInstance] clearChatMsglist];
    return result;
}


//更新消息汇总
- (BOOL)updateMsgSummary:(ChatMsgDTO *)chatmsg :(NSString *)chatid{
    __block BOOL result=NO;
    //消息对象
    NSString *userid=chatmsg.fromuid;
    //群聊
    if (chatmsg.chatType==1){
        userid=chatmsg.touid;
    }
    //发送
    if (chatmsg.sendtype==0) {
        userid=chatmsg.touid;
    }
    //查询聊天对象是否存在
    MsgSummary *msg=[self queryMsgSummaryBychatid:userid];
    
    if (![JZCommon isBlankString:msg.ownerid]) {
        msg.state = [NSString stringWithFormat:@"%ld",(long) chatmsg.success];
        if (chatmsg.sendtype == 1) {
            msg.state = @"1";
        }
        msg.isRead = chatmsg.isread;
        if (chatmsg.sendtype == 0) {
            msg.isRead = @"1";
        }
        
        if (chatmsg.filetype==0) {
            msg.content = [self dealString:chatmsg.content];
            
        }
        else{
            msg.content=[self msgContent:chatmsg.filetype];
        }
        msg.date = chatmsg.orderytime;
        
        //不是当前聊天对象
        if (![userid isEqualToString: chatid] && chatmsg.sendtype==1) {
            msg.count++;
        }
        //更新数据
        result=[self updateMsgSummarydata:msg :chatid];
    }
    return result;
}

//更新消息置顶
- (BOOL)updateMsgSummaryisTop:(MsgSummary*)msg :(NSString *)chatid{

    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        result=[database executeUpdate:@"update zMsgSummary set zistop=?,ztoptime=? where zownerid=? and zchatid=? ",[NSString stringWithFormat:@"%ld",(long)msg.istop],msg.toptime,[JZCommon queryLoginUserId],chatid];
    
    }];
    return result;
}

//添加汇总消息
-(BOOL)saveMsgSummary:(MsgSummary *)msg{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
    //插入数据
    result=[database executeUpdate:@"insert into zMsgSummary(zchartype,zcount,zfiletype,zistop,zdate,zchatid,zcontent,ztoptime,zownerid,zstate,zisread,zmsgid,chatphoto,grade,subjects,teacherID) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[NSString stringWithFormat:@"%ld",(long)msg.chartype],[NSString stringWithFormat:@"%ld",(long)msg.count],[NSString stringWithFormat:@"%ld",(long)msg.filetype],[NSString stringWithFormat:@"%ld",(long)msg.istop],msg.date,msg.chatid,msg.content,msg.toptime,msg.ownerid,msg.state,msg.isRead,msg.msgid,msg.chatphoto,msg.grade,msg.subjects,msg.teacherID];
    
    }];
    return result;
}

//更新汇总消息
-(BOOL)updateMsgSummarydata:(MsgSummary *)msg :(NSString *)chatid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
    //更新数据
    result=[database executeUpdate:@"update zMsgSummary set zcount=?,zfiletype=?,zdate=?,zcontent=? ,zstate=?,zisread=?,zmsgid=?,ztoptime=?,chatphoto=? where zownerid=? and zchatid=? ",[NSString stringWithFormat:@"%ld",(long)msg.count],[NSString stringWithFormat:@"%ld",(long)msg.filetype],msg.date,msg.content,msg.state,msg.isRead, msg.msgid,msg.toptime,msg.chatphoto, [JZCommon queryLoginUserId],chatid];
    }];
    return result;
}

//更新汇总消息数量
-(BOOL)updateMsgSummarycount:(NSInteger)count :(NSString *)chatid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        result=[database executeUpdate:@"update zMsgSummary set zcount=? where zownerid=? and zchatid=? ",[NSString stringWithFormat:@"%ld",(long)count],[JZCommon queryLoginUserId],chatid];
    }];
    return result;
}

//更新汇总消息发送状态
-(BOOL)updateMsgSummarystate:(NSInteger)state :(NSString *)msgid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        result=[database executeUpdate:@"update zMsgSummary set zstate=? where zmsgid=? and zownerid=?",[NSString stringWithFormat:@"%ld",(long)state],msgid,[JZCommon queryLoginUserId]];;
    }];
    return result;
}

//更新汇总消息已读状态
-(BOOL)updateMsgSummaryread:(NSString *)isread :(NSString *)msgid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        result=[database executeUpdate:@"update zMsgSummary set zisread=? where zmsgid=? and zownerid=?",isread,msgid,[JZCommon queryLoginUserId]];;
    }];
    return result;
}
//更新汇总消息问题ID
-(BOOL)updateMsgSummaryQuestionID:(NSString *)questionid :(NSString *)msgid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        result=[database executeUpdate:@"update zMsgSummary set zmsgid=? where zmsgid=? and zownerid=?",questionid,msgid,[JZCommon queryLoginUserId]];;
    }];
    return result;
}
//更新消息老师ID
-(BOOL)updateMsgSummaryTeacherID:(NSString *)chatid TeacherUserID:(NSString *)teacherid Questionid:(NSString *)msgid{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        result=[database executeUpdate:@"update zMsgSummary set zchatid=? teacherID = ? where zmsgid=? and zownerid=?",chatid,teacherid, msgid,[JZCommon queryLoginUserId]];;
    }];
    return result;
}
//处理消息
- (void)dealMsgSummary:(ChatMsgDTO *)chatmsg :(NSString*)chatid{
    //消息对象
    NSString *userid=chatmsg.fromuid;
    //群聊
    if (chatmsg.chatType==1){
        userid=chatmsg.touid;
    }
    //发送
    if (chatmsg.sendtype==0) {
        userid=chatmsg.touid;
    }
    NSString *msgcontent=@"";
    if (chatmsg.filetype==0) {
        msgcontent =  [self dealString:chatmsg.content];
        
    }
    else{
        msgcontent = [self msgContent:chatmsg.filetype];
    }
    //查询聊天对象是否存在
    MsgSummary *msg=[self queryMsgSummaryBychatid:chatmsg.questionID];
    msg.msgid = chatmsg.questionID;//消息来源
    if (![JZCommon isBlankString:msg.ownerid]) {
        //对外沟通助手
        if (msg.chartype==2 ) {
            if ([msg.content isEqualToString:msgcontent]) {
                return;
            }
        }
//        msg.content=msgcontent;
        msg.date = chatmsg.orderytime;
        msg.state = [NSString stringWithFormat:@"%ld",(long) chatmsg.success];
        if (chatmsg.sendtype == 1) {
            msg.state = @"1";
        }
        msg.isRead = chatmsg.isread;
        if (chatmsg.sendtype == 0) {
            msg.isRead = @"1";
        }
        msg.msgid = chatmsg.questionID;
        msg.filetype=chatmsg.filetype;
//        msg.date =[NSDate date];
        msg.chatphoto = chatmsg.chatphoto;
        //不是当前聊天对象
        if (![userid isEqualToString: chatid] && chatmsg.sendtype==1) {
            msg.count++;
        }
        //更新数据
        [self updateMsgSummarydata:msg :userid];
        
         [[NSNotificationCenter defaultCenter]postNotificationName:@"messageReloadTableView" object:nil];
    }
    //新聊天对象
    else{
        
        MsgSummary * userMessage = [[MsgSummary alloc] init];
        userMessage.ownerid=[JZCommon queryLoginUserId];
        userMessage.chatid = [NSString stringWithFormat:@"%@",userid];
        userMessage.chartype=chatmsg.chatType;
        userMessage.date = [NSDate date];
        userMessage.state = [NSString stringWithFormat:@"%ld",(long) chatmsg.success];
        userMessage.grade = chatmsg.grade;
        userMessage.subjects = chatmsg.subjects;
        userMessage.teacherID = chatmsg.teacherID;
        if (chatmsg.sendtype == 1) {
            userMessage.state =@"1";
        }
        userMessage.isRead = chatmsg.isread;
        if (chatmsg.sendtype == 0) {
            userMessage.isRead = @"1";
        }
        userMessage.msgid = chatmsg.questionID;
        userMessage.content=msgcontent;
        userMessage.filetype=chatmsg.filetype;
        userMessage.chatphoto = chatmsg.chatphoto;
        //不是当前聊天对象
        if (userid && ![userid isEqualToString: chatid] && chatmsg.sendtype==1) {
            userMessage.count=1;
        }
        
        userMessage.istop = 0;
        //插入数据
        [self saveMsgSummary:userMessage];
    }
}

//查询消息汇总列表
- (NSMutableArray *)getMsgSummaryList:(NSString *)userid{
    NSMutableArray *stations = [NSMutableArray array];
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM zMsgSummary where zownerid=? order by zdate desc",userid];
//        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM zMsgSummary where zownerid=? order by ztoptime desc,zdate desc",userid];
        while ([resultSet next]) {
            MsgSummary *model=[[MsgSummary alloc] init];
            model.ownerid=[resultSet stringForColumn:@"zownerid"];
            model.chatid=[resultSet stringForColumn:@"zchatid"];
            model.chartype=[resultSet intForColumn:@"zchartype"];
            model.toptime=[resultSet stringForColumn:@"ztoptime"];
            model.date=[resultSet dateForColumn:@"zdate"];
            model.content=[resultSet stringForColumn:@"zcontent"];
            model.filetype=[resultSet intForColumn:@"zfiletype"];
            model.count=[resultSet intForColumn:@"zcount"];
            model.istop=[resultSet boolForColumn:@"zistop"];
            model.isRead = [resultSet stringForColumn:@"zisread"];
            model.state  =[resultSet stringForColumn:@"zstate"];
            model.msgid = [resultSet stringForColumn:@"zmsgid"];
            model.chatphoto = [resultSet stringForColumn:@"chatphoto"];
            [stations addObject:model];
        }
        [resultSet close];
    
    }];
    
    return stations;
}
//消息记录
- (void)updateMsgSummarycount:(MsgSummary *)msg chatid:(NSString*)chatid isdelete:(BOOL)delete{
    __block BOOL result=NO;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    
    [queue inDatabase:^(FMDatabase *database) {
        //更新数据
        result=[database executeUpdate:@"update zMsgSummary set zcount=? where zownerid=? and zchatid=? ",@"0", [JZCommon queryLoginUserId],chatid];
    }];
}
//查询
- (NSInteger)selectMsgSummaryCount:(MsgSummary *)msg chatid:(NSString*)chatid{
    __block NSInteger count1 = 0;
    FMDatabaseQueue *queue = [self.class sharedQueue];
    [queue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT zcount FROM zMsgSummary where zownerid=? zchatid",[JZCommon queryLoginUserId],chatid];
        while ([resultSet next]) {
           count1=(long)[resultSet intForColumn:@"zcount"];
        }
        [resultSet close];
        
    }];
    return count1;
}
//添加


//处理文本
-(NSString *)dealString :(NSString *)content{
    if (content.length>maxcontentlength) {
        NSString *save=[content substringToIndex:maxcontentlength];
        NSString *temp=[content substringFromIndex:maxcontentlength];
        NSInteger location=temp.length;
        if (temp.length>12) {
            location=12;
        }
        temp=[temp substringToIndex:location];
        NSRange range=[temp rangeOfString: END_FLAG];
        if(range.length>0){
            NSString *tempcontent=[temp substringToIndex:range.location];
            NSString *matchrange=@"[A-Za-z0-9_A-Za-z0-9]";
            BOOL ismatch=[tempcontent isMatchedByRegex:matchrange];
            if (ismatch) {
                temp=[temp substringToIndex:range.location+1];
                content=[save stringByAppendingString:temp];
            }
            else{
                content=save;
            }
        }
        else{
            content=save;
        }
        content=[NSString stringWithFormat:@"%@...",content];
    }
    return  content;
}

-(NSString *)msgContent :(NSInteger)filetype{
    NSString *content=[[NSString alloc]init];
    if (filetype==1) {
        content = @"[语音]";
    }
    else if (filetype==2){
        content = @"[图片]";
    }
    else if (filetype==3){
        content = @"[视频]";
    }
    else if (filetype==4){
        content = @"[名片]";
    }
    else if (filetype==5){
        content = @"[链接]";
    }
    else if (filetype==6){
        content = @"[位置]";
    }
    return content;
}

@end
