//
//  XMPPManager.m
//  XMPPTest
//
//  Created by mijibao on 15/9/22.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "XMPPManager.h"
#import "XMPPMessage+XEP_0085.h"
#import "ChatMsgListManage.h"
#import "MessageModel.h"
#import "MsgSummaryManage.h"
#import "MD5Tool.h"
#import "NewAttentionManager.h"
#import "UIImageView+MJWebCache.h"
#import "ImageRequestCore.h"

@interface XMPPManager ()<XMPPRosterDelegate, XMPPStreamDelegate, XMPPvCardAvatarDelegate, XMPPvCardTempModuleDelegate>

@property (strong, readonly, nonatomic) XMPPStream *xmppStream; //xmpp基础服务类

@property (strong, readonly, nonatomic) XMPPAutoPing *xmppAutoPing; // 心跳监听

@property (strong, readonly, nonatomic) XMPPReconnect *xmppReconnect; // 如果失去连接,自动重连

@property (strong, readonly, nonatomic) XMPPRoster *xmppRoster; //好友列表类
@property (strong, readonly, nonatomic) XMPPRosterCoreDataStorage *xmppRosterStorage; //好友列表（用户账号）在core data中的操作类

@property (strong, readonly, nonatomic) XMPPvCardCoreDataStorage *xmppvCardStorage; // 好友名片（昵称，签名，性别，年龄等信息）在core data中的操作类
@property (strong, readonly, nonatomic) XMPPvCardTempModule *xmppvCardTempModule;
@property (strong, readonly, nonatomic) XMPPvCardAvatarModule *xmppvCardAvatarModule;

@property (strong, readonly, nonatomic) XMPPCapabilities *xmppCapabilities;
@property (strong, readonly, nonatomic) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

@property (strong, readonly, nonatomic) XMPPMessageArchiving *xmppMessageArchiving;
@property (strong, readonly, nonatomic) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;


- (NSManagedObjectContext *)managedObjectContextRoster;
- (NSManagedObjectContext *)managedObjectContextCapabilities;
- (NSManagedObjectContext *)managedObjectContextMessageArchiving;

@end

@implementation XMPPManager

static XMPPManager *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[XMPPManager alloc] init];
        
        [sharedManager setupStream];
    });
    return sharedManager;
}

#pragma mark - 发送消息
/*
 发送消息的格式
 <message type="chat" to="hehe@example.com">
 　　<body>Hello World!<body />
 <message />
 */
- (void)sendMessage:(ChatMsgDTO *)model
{
    NSString *subject = model.touid;
    //收件人
    NSString *jidstring = [NSString stringWithFormat:@"%@@%@",model.touid,[OperatePlist OpenFireServerAddress]];
    MessageModel *msg = [[MessageModel alloc] init];
    msg.addTime = model.sendtime;
    msg.isStar = model.questionID;
    msg.sendAddress = @"";
    msg.voiceLength = @"";
    msg.fileUrl = @"";
    msg.location = @"";
    
    if (model.filetype == 0) {
        msg.attachType = @"0";
        msg.textContent = model.content;
    } else if (model.filetype == 1) {
        msg.attachType = @"1";
        msg.fileUrl = model.url;
        msg.voiceLength = model.duration;
    } else if (model.filetype == 2) {
        msg.attachType = @"2";
        msg.fileUrl = model.url;
    } else if (model.filetype == 3) {
        msg.attachType = @"3";
        msg.fileUrl = model.url;
        msg.voiceLength = model.duration;//长度
        msg.textContent = model.content;
        msg.senderPhone = model.thumbnail;//暂时代替缩略图路径
        msg.receivePhone = model.totalsize;//视频内存
    } else if (model.filetype == 4){
        
        msg.attachType = @"4";
        msg.textContent = model.content; //手机号了
        msg.sendName = model.name; //名字片上的名字
        
        
    } else if (model.filetype == 6){
        msg.attachType = @"6";
        msg.fileUrl = model.url;
        msg.filePath = model.thumbnail;
        msg.textContent = model.content;
    }else if (model.filetype == 7){
        msg.attachType = @"7";
        msg.textContent = model.content;
    }
    msg.receiveId = model.touid;
    msg.sender = model.fromuid;
    if (model.chatType == 0) {
        msg.isGroup = @"S";
        subject = model.touid;
        //收件人
        jidstring = [NSString stringWithFormat:@"%@@%@",model.touid,[OperatePlist OpenFireServerAddress]];
        
    }else{
        msg.isGroup = @"F";
    }
    msg.iD = model.msgid;
    msg.listPosition = @"";
    msg.delay = false;
//    msg.delivery_status = 1;
    msg.direction = @"1";
    msg.hasAttach = @"0";
    msg.imageHeight = 0;
    msg.imageWidth = 0;
    msg.isCalendar = @"F";
    msg.isShowTime = @"T";
    
    XMPPJID *jid = [XMPPJID jidWithString:jidstring];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid elementID:model.msgid];
    [message addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",model.fromuid,[OperatePlist OpenFireServerAddress]]];
    [message addAttributeWithName:@"xmlns" stringValue:@"jabber:client"];
//    [message addmessageIsSuccess:@"0"]; // 状态使用
    [message addmessageBareJidStr:jidstring];
    [message addMessageId:model.msgid];
    NSDictionary *dic = [JZCommon dictionaryWithModel:msg];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *content = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    [message addBody:content];
//    [message addSubject:subject];
    
    //send
    [[self xmppStream] sendElement:message];
    NSLog(@"%@",message);
}
- (void)sendMessage:(NSString *)msg toUser:(NSString *)user
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:msg];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@baidu.com",user];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    [_xmppStream sendElement:message];
}

- (void)dealloc
{
    [self teardownStream];
}

- (void)teardownStream
{
    [_xmppStream            removeDelegate:self];
    [_xmppRoster            removeDelegate:self];
    [_xmppMessageArchiving  removeDelegate:self];
    [_xmppAutoPing          removeDelegate:self];
    
    [_xmppAutoPing          deactivate];
    [_xmppReconnect         deactivate];
    [_xmppRoster            deactivate];
    [_xmppvCardTempModule   deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppCapabilities      deactivate];
    [_xmppMessageArchiving  deactivate];
    
    [_xmppStream disconnect];
    
    _xmppStream                     = nil;
    _xmppAutoPing                   = nil;
    _xmppReconnect                  = nil;
    _xmppRoster                     = nil;
    
    _xmppvCardTempModule            = nil;
    _xmppvCardAvatarModule          = nil;
    _xmppCapabilities               = nil;
    _xmppCapabilitiesStorage        = nil;
    _xmppMessageArchiving           = nil;
    _xmppMessageArchivingStorage    = nil;
}

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContextRoster
{
    return [_xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContextCapabilities
{
    return [_xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContextMessageArchiving
{
    return [_xmppMessageArchivingStorage mainThreadManagedObjectContext];
}

#pragma mark - Private
// 初始化xmpp
- (void)setupStream
{
    NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");
    
    _xmppStream = [[XMPPStream alloc] init];
#if !TARGET_IPHONE_SIMULATOR
    {
        // 设置此行为YES,表示允许socket在后台运行
        // 在模拟器上是不支持在后台运行的
        _xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
//  服务器会在一定的时间间隔内（默认是300S）向客户端发送一个IQ，如何客户端不做出响应，服务器则会默认在客户端的连接是断开的
    _xmppAutoPing = [[XMPPAutoPing alloc] init];
    [_xmppAutoPing setPingInterval:1000];
    [_xmppAutoPing setRespondsToQueries:YES];
    // 设置ping目标服务器，如果为nil,则监听socketstream当前连接上的那个服务器
//    _xmppAutoPing.targetJID = nil;
    
    _xmppReconnect = [[XMPPReconnect alloc] init];// 自动重连，当我们被断开了，自动重新连接上去，并且将上一次的信息自动加上去
    [_xmppReconnect activate:_xmppStream];
    // 配置花名册并配置本地花名册储存
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    //当你已申请添加对方为好友，对方同意后会自动添加彼此到对方好友列表
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    _xmppRoster.autoFetchRoster = YES;
    
    // 配置vCard存储支持，vCard模块结合vCardTempModule可下载用户Avatar
    _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
    
    // XMPP特性模块配置，用于处理复杂的哈希协议等
    _xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesStorage];
    _xmppCapabilities.autoFetchHashedCapabilities = YES;
    _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // 消息相关
    _xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingStorage];
    [_xmppMessageArchiving setClientSideMessageArchivingOnly:YES];
    [_xmppMessageArchiving activate:_xmppStream];
    
    // 所有的Module模块，都要激活active
    [_xmppAutoPing          activate:_xmppStream];
    [_xmppReconnect         activate:_xmppStream];
    [_xmppRoster            activate:_xmppStream];
    [_xmppvCardTempModule   activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];
    [_xmppCapabilities      activate:_xmppStream];
    [_xmppMessageArchiving  activate:_xmppStream];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppMessageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark Connect/disconnect
// 连接
- (BOOL)connect
{
    if (![_xmppStream isDisconnected]) {
        return NO;
    }
    
    NSString *userid = [JZCommon getUserPhone];
    NSString *jidString = [NSString stringWithFormat:@"%@@%@", userid, [OperatePlist OpenFireServerAddress]];
    [_xmppStream setMyJID:[XMPPJID jidWithString:jidString]];
    [_xmppStream setHostName:[OperatePlist OpenFireServerAddress]];
    // 连接
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"Error connecting: %@", [error description]);
        
        return NO;
    }
    return YES;
}
// 断开连接
- (BOOL)disconnect
{
    if ([_xmppStream isDisconnected]) {
        NSLog(@"current xmpp stream is disconnected.");
        return NO;
    }
    
    [self goOffline];
    [_xmppStream disconnect];
    
    return YES;
}
// 上线
- (void)goOnline
{
    //  available
    //  away
    //  do not disturb
    //  unavaiable
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
//    NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
//    [status setStringValue:@"在线"];
//    [presence addChild:status];
    // 发送状态信息
    [_xmppStream sendElement:presence];
//    if ( && ![JZCommon isBlankString:path]) {
//        NSRange range = NSMakeRange(0, 4);
//        NSString *fromString = [path substringWithRange:range];
//        NSString *imageStr = [[NSString alloc] init];
//        if ([fromString isEqualToString:@"http"]) {
//            imageStr = path;
//        }else{
//            imageStr =[JZCommon getFileDownloadPath:path];
//        }
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:image];
//    }else{
//        [imageView setImage:image];
//    }
    [self insertMyInfomationToXmppWithImage:[ImageRequestCore imageWithUrl:[UserInfoList loginUserPhoto]]nickName:[UserInfoList loginUserNickname]];
}
// 下线
- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

#pragma mark - XMPPStream Delegate
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    NSLog(@"%s",__FUNCTION__);
}
// 连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"%s",__FUNCTION__);
    //连接超时,继续重连
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self connect];
    });
}

// XMPP开始连接
- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark -  XMPP已经连接
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"%s",__FUNCTION__);
    
    if ([_xmppStream isConnected]) {
        NSString *password = [JZCommon getLoginUserPwd];
        password = [MD5Tool md5:password];
//        NSString *password =@"96e79218965eb72c92a549dd5a330112";
        NSError *error = nil;
        if (![_xmppStream authenticateWithPassword:password error:&error]) {
            NSLog(@"密码校验失败，登录不成功:%@\n%@",password,error.localizedDescription);
        }

        /** 注册推送通知功能, */
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
#ifdef __IPHONE_8_0
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                                 settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
        }
    }
}

#pragma mark - - XMPPLogin call-back
// XMPP验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"密码校验成功，用户将要上线");
    [self goOnline];
}

// XMPP验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%s :密码校验失败，登录不成功,原因是：%@",__FUNCTION__, [error XMLString]);
    //验证失败断开连接
    [self disconnect];
}

// 收到错误消息
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    NSLog(@"%s",__FUNCTION__);
    DDXMLNode *errorNode = (DDXMLNode *)error;
    //遍历错误节点
    for(DDXMLNode *node in [errorNode children]) {
        //若错误节点有【冲突】
        if([[node name] isEqualToString:@"conflict"]) {
            //弹出登陆冲突,点击OK后logout
            
        }
    }
}
// 下线成功
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"%s:%@",__FUNCTION__,error.localizedDescription);
}

#pragma mark - XMPPRegister call-back
// 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
     NSLog(@"%s",__FUNCTION__);
}
// 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"%s",__FUNCTION__);
    /*
     <iq xmlns="jabber:client" type="error" to="127.0.0.1/347f0596">
     <query xmlns="jabber:iq:register">
     <username>test</username>
     <password>test</password>
     </query>
     <error code="409" type="cancel">
     <conflict xmlns="urn:ietf:params:xml:ns:xmpp-stanzas"></conflict>
     </error>
     </iq>
     */
}

/*
 一个 IQ 响应：
 <iq type="result"
 　　id="1234567"
 　　to="xiaoming@example.com">
 　　<query xmlns="jabber:iq:roster">
 　　　　<item jid="xiaoyan@example.com" name="小燕" />
 　　　　<item jid="xiaoqiang@example.com" name="小强"/>
 　　<query />
 <iq />
 type 属性，说明了该 iq 的类型为 result，查询的结果
 <query xmlns="jabber:iq:roster"/> 标签的子标签 <item />，为查询的子项，即为 roster
 item 标签的属性，包含好友的 JID，和其它可选的属性，例如昵称等。
 */
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    // 服务器会在给定的时间内向客户端发送ping包（用来确认客户端用户是否在线）,当第二次发送bing包时，如果客户端无响应则会T用户下线
    if (iq.isGetIQ) {
        NSXMLElement *query = iq.childElement;
        if ([query.name isEqualToString:@"ping"]) {
            XMPPIQ *pong = [XMPPIQ iqWithType:@"result" to:[iq from] elementID:[iq elementID]];
            [_xmppStream sendElement:pong];
        }
        return YES;
    }
    return NO;
}

// 发送IQ包成功
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
    
}
// 发送IQ包失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    
}

/*
 发送消息的格式
 <message type="chat" to="hehe@example.com">
 　　<body>Hello World!<body />
 <message />
 */
#pragma mark - ReceiveMessage 接收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *msgString = [[message elementForName:@"body"] stringValue];
    
    //回执
    NSString *subject = [[message elementForName:@"subject"] stringValue];
    if ([subject isEqualToString:@"receipt"]) {
        [message addmessageIsSuccess:@"1"];
        if ([self.delegate respondsToSelector:@selector(sendMessageIsSuccess:)]) {
            [self.delegate sendMessageIsSuccess:message];
        }
        NSLog(@"发送成功");
        return;
    }
    //聊天消息
    else if (!message.isErrorMessage &&[[msgString substringToIndex:1] isEqualToString:@"{"]){
        NSData *data = [msgString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        ChatMsgDTO *msg = [self messageFromJson:dict];
        if (msg.filetype == 7) {
            NSString *chatId = [NSString stringWithFormat:@"%@",msg.fromuid];
            [[MsgSummaryManage shareInstance] updateMsgSummaryTeacherID:chatId TeacherUserID:msg.content Questionid:msg.questionID];
            [[NSNotificationCenter defaultCenter] postNotificationName:kResponderNotification object:msg userInfo:nil];
            return;
        }
        //播放声音
        if (msg.chatType == 1) {
            [self palysoundandshake:msg.touid];
        }else{
            [self palysoundandshake:msg.fromuid];
        }
        
        // 保存消息到数据库
        
        [[ChatMsgListManage shareInstance] saveChatMsg:msg];
        //保存消息汇总信息
//        [[MsgSummaryManage shareInstance] dealMsgSummary:msg :[self appDelegate].chatuserid];
        NSDictionary *newMessage = [[NSDictionary alloc] initWithObjectsAndKeys:msg, @"newMessage", nil];
       
        // 发出新消息通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessageNotification object:nil userInfo:newMessage];
//        [self appDelegate].isHaveNewMsg = YES;
    }
}

- (ChatMsgDTO *)messageFromJson:(NSDictionary *)msg
{
    ChatMsgDTO *result = [[ChatMsgDTO alloc] init];
    NSString *filetype =[NSString stringWithFormat:@"%@",[msg objectForKey:@"attachType"]];
    result.msgid = [JZCommon GUID];
    result.questionID = [msg objectForKey:@"isStar"];
    result.sendtime = [msg objectForKey:@"addTime"];
    result.sendtype = 1;
    result.fromuid = [msg objectForKey:@"sender"];
    result.touid = [msg objectForKey:@"receiveId"];

//    result.isfail = @"1";
//    result.sender.headurl = [msg objectForKey:@"chatphoto"];
    NSString *isgroup = [msg objectForKey:@"isGroup"];
//    result.sender = [[BuddyModelDBManager sharedManager] queryBuddyModelByUID:result.fromid];   //因为是接收到别人的信息，sender是对方fromid
    //单聊
    if ([isgroup isEqualToString:@"S"]) {
        result.chatType = 0;
    } else {
        result.chatType =1;
    }
    result.isread = @"0";
    //T文本消息，S语音消息，P图片消息
    //文本、表情
    if ([filetype isEqualToString:@"0"]) {
        result.filetype = 0;
        result.content = [msg objectForKey:@"textContent"];
        
    } else if ([filetype isEqualToString:@"1"]) {
        //语音
        result.filetype = 1;
        result.url = [msg objectForKey:@"fileUrl"];
        if ([[msg objectForKey:@"voiceLength"] isKindOfClass:[NSString class]]) {
            result.duration = [msg objectForKey:@"voiceLength"];
        } else {
            result.duration = [[msg objectForKey:@"voiceLength"] stringValue];
        }
        
    } else if ([filetype isEqualToString:@"2"]) {
        //图片
        result.filetype = 2;
        result.content = [msg objectForKey:@"fileUrl"];
        result.url = [msg objectForKey:@"fileUrl"];
    }else if ([filetype isEqualToString:@"3"]) {
        //视频
        result.filetype = 3;
        result.url = [msg objectForKey:@"fileUrl"];
        if ([[msg objectForKey:@"voiceLength"] isKindOfClass:[NSString class]]) {
            result.duration = [msg objectForKey:@"voiceLength"];
        } else {
            result.duration = [[msg objectForKey:@"voiceLength"] stringValue];
        }
//        result.content = [msg objectForKey:@"textContent"];
        result.thumbnail = [msg objectForKey:@"senderPhone"];
        result.totalsize = [msg objectForKey:@"receivePhone"];
        
    } else if ([filetype isEqualToString:@"4"]) {
       
        result.filetype = 4;
        result.name =  result.name = [msg objectForKey:@"sendName"];
        result.content = [msg objectForKey:@"textContent"];
    } else if ([filetype isEqualToString:@"6"]) {
        
        result.filetype = 6;
        result.name =  result.name = [msg objectForKey:@"sendName"];
        result.url = [msg objectForKey:@"fileUrl"];
        result.thumbnail = [msg objectForKey:@"filePath"];
        result.content = [msg objectForKey:@"textContent"];
    }else if ([filetype isEqualToString:@"7"]){
        result.filetype = 7;
        result.content = [msg objectForKey:@"textContent"];
    }else {
        result.content = [msg objectForKey:@"textContent"];
    }
    return result;
}

// 发送消息成功
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"%s",__FUNCTION__);
    [message addmessageIsSuccess:@"1"];
//   [[NSNotificationCenter defaultCenter] postNotificationName:kMessageSendNotification object:nil userInfo:@{@"message":message}];
    if ([self.delegate respondsToSelector:@selector(sendMessageIsSuccess:)]) {
        [self.delegate sendMessageIsSuccess:message];
    }
    NSLog(@"-------------------------------------发送成功");
//    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageSendNotification object:nil userInfo:@{@"isSuccess":@"success"}];
}
// 发送消息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    [message addmessageIsSuccess:@"2"];
    if ([self.delegate respondsToSelector:@selector(sendMessageIsSuccess:)]) {
        [self.delegate sendMessageIsSuccess:message];
    }

    NSLog(@"-------------------------------------发送失败 %@",error);
//    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageSendNotification object:nil userInfo:@{@"message":message}];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageSendNotification object:nil userInfo:@{@"isSuccess":@"fail"}];
}

- (void)XMPPAddFriendSubscribe:(NSString *)touid nickName:(NSString *)nickName
{//添加好友
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",touid,[OperatePlist OpenFireServerAddress]]];
    [_xmppRoster addUser:jid withNickname:nickName];
}

- (void)insertMyInfomationToXmppWithImage:(UIImage *)image nickName:(NSString *)nickname
{
    XMPPvCardTemp *myvCard = [_xmppvCardTempModule myvCardTemp];
    //以下为设置其具体信息,由于png图片校对于jpeg格式图片，数据过大，故采用jepg，并对其进行压缩后上传openfire服务器
    myvCard.photo = UIImageJPEGRepresentation(image, 0.7);
    myvCard.nickname = nickname;
    [_xmppvCardTempModule updateMyvCardTemp:myvCard];
}


// 添加好友回调
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{//收到好友请求
    NSString *type = presence.type;
    NSString *user = presence.from.user;
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",user,[OperatePlist OpenFireServerAddress]]];
    if (![presence.type isEqualToString:[UserInfoList loginUserPhone]]) {//防止自己添加自己
        if ([type isEqualToString:@"subscribe"]) {//xx添加我为好友，建立提示框是否添加
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate:sender.authenticationDate];
            NSDictionary *dic = @{@"fromId":user, @"date":dateString, @"isRead":@"0"};
            [[NewAttentionManager shareInstance] insertWithModel:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:kaddMessageNotification object:nil userInfo:@{@"presenceFromUser":user}];
            [_xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
        }else if ([type isEqualToString:@"unsubscribe"]){//xx将我从好友列表删除,将其从好友列表移除
            [_xmppRoster removeUser:presence.from];
        }else if ([type isEqualToString:@"subscribed"]){//xx已成为我的好友
        }
    }    NSLog(@"%s:type:%@,user:%@",__FUNCTION__,type,user);
}
//好友处理
- (void)xmppManagerPresenceWithType:(NSString *)type user:(XMPPJID *)jid{
    if ([type isEqualToString:@"0"]) {//同意添加好友
       // [_xmppRoster acceptPresenceSubscriptionRequestFrom: andAddToRoster:YES];
    }else{//拒绝
       // [_xmppRoster rejectPresenceSubscriptionRequestFrom:];
    }
}
//获取个人头像
- (XMPPvCardAvatarModule *)avatarModule{
    return _xmppvCardAvatarModule;
}

//个人名片
- (XMPPvCardTemp *)vCardTempWithUserId:(NSString *)userId{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", userId,[OperatePlist OpenFireServerAddress]]];
    return  [_xmppvCardTempModule vCardTempForJID:jid shouldFetch:YES];
}

// 发送Presence成功
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
    NSString *type = presence.type;
    NSLog(@"%s:%@",__FUNCTION__,type);
}
// 发送Presence失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}
// 被通知要下线
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender
{
    NSLog(@"%s",__FUNCTION__);
}

//#pragma mark - XMPPRosterDelegate
//// 收到添加好友的请求
//- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
//{
//    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]];//在线状态
//    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];//请求来源
//    NSLog(@"收到好友请求");
//    //注册新好友通知
////    presence.from.user.
//    [[NSNotificationCenter defaultCenter] postNotificationName:kaddMessageNotification object:nil userInfo:@{@"presenceFromUser":presenceFromUser}];
////    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
////    [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
////    [_xmppRoster rejectPresenceSubscriptionRequestFrom:(XMPPJID *)jid];
//}
// 添加好友同意后，会进入到此代理
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq {
    NSLog(@"添加成功!!!didReceiveRosterPush -> :%@",iq.description);
    NSLog(@"%s",__FUNCTION__);
}
//    NSString *msgString = [[message elementForName:@"body"] stringValue];
//    MessageModel *model = [[MessageModel alloc] init];
//    model.fromid = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPRECEIVEJID];
//    model.toid = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPJID];
//    model.msgid = [JZCommon GUID];
//    model.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
//    model.chattype = @"0";
//    model.sendtype = @"1";
//    model.content = msgString;
//    model.isfail = @"1";
//    model.isread = @"0";
//    model.filetype = @"0";
//
//    NSDictionary *newMessage = @{@"newMessage":model};
//    // 发出新消息通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessageNotification object:nil userInfo:newMessage];

/**
 * Sent when the roster receives a roster item.
 *
 * Example:
 *
 * <item jid='romeo@example.net' name='Romeo' subscription='both'>
 *   <group>Friends</group>
 * </item>
 **/
// 获取到一个好友节点
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    NSLog(@"%s",__FUNCTION__);
}
//完成获取好友列表
//- (NSFetchedResultsController *)
- (void)xmppRosterDidEndPupulating:(XMPPRoster *)sender
{
//    NSManagedObjectContext *context = _xmppRosterStorage.mainThreadManagedObjectContext;
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@XMPPUserCoreDataStorageObject];
//    
//    //筛选本用户的好友
//    NSString *userinfo = [NSString stringWithFormat:@%@@%@,self.user,self.domain];
//    
//    NSLog(@userinfo = %@,userinfo);
//    NSPredicate *predicate =
//    [NSPredicate predicateWithFormat:@ streamBareJidStr = %@ ,userinfo];
//    request.predicate = predicate;
//    
//    //排序
//    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@displayName ascending:YES];
//    request.sortDescriptors = @[sort];
//    
//    self.fetFriend = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
//    self.fetFriend.delegate = self;
//    NSError *error;
//    [self.fetFriend performFetch:&error];
//    
//    //返回的数组是XMPPUserCoreDataStorageObject  *obj类型的
//    //名称为 obj.displayName
//    NSLog(@%lu,(unsigned long)self.fetFriend.fetchedObjects.count);
//    return  self.fetFriend.fetchedObjects;
}

#pragma mark - XMPPRoomDelegate
// 创建聊天室成功
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    
}
// 如果房间存在，会调用委托
// 收到禁止名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    
}
// 收到好友名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    
}
// 收到主持人名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    
}
// 房间不存在，调用委托
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
    
}

// 新人加入群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID
{
    NSLog(@"%s",__FUNCTION__);
}
// 有人退出群聊
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID
{
    NSLog(@"%s",__FUNCTION__);
}
// 有人在群里发言
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - XMPPReconnectDelegate
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags
{
    NSLog(@"%s",__FUNCTION__);
}

- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags
{
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"%s",__FUNCTION__);
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        } else {
            completionHandler(NO);
        }
    });
}
- (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark - 播放声音
//播放震动和提示音
- (void)palysoundandshake:(NSString*)toid {
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    //震动
//    if (![[defaults valueForKey:[SysConfig IsShakeNotification]]isEqualToString:@"0"]) {
//        NSString *str = [defaults valueForKey:toid];
//        if (str == nil) {
//            str = @"0";
//        }
//        if ([str isEqualToString:@"0"]) {
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        }else{
//            
//        }
//    }
//    else{
//        AudioServicesPlaySystemSound(NO);
//    }
//    //提示音
//    if (![[defaults valueForKey:[SysConfig IsSoundNotification]]isEqualToString:@"0"]) {
//        NSString *str = [defaults valueForKey:toid];
//        if (str == nil) {
//            str = @"0";
//        }
//        if ([str isEqualToString:@"0"]) {
//            AudioServicesPlaySystemSound(1007);
//        }else{
//            
//        }
//        
//    }
//    else{
//        AudioServicesPlaySystemSound(NO);
//    }
}
@end
