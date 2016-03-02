//
//  ChatMsgDTO.h
//  jinherIU
//  消息自定义实体
//  Created by hoho108 on 14-5-15.
//  Copyright (c) 2014年 hoho108. All rights reserved.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ChatMsgDTO : NSObject

@property(copy,nonatomic)NSString *content;//内容
@property(nonatomic)NSInteger filetype;//文件类型 0 文字 1语音 2图片 7老师抢答
@property(copy,nonatomic)NSString *url;//链接地址
@property(copy,nonatomic)NSString *fromuid;//发送者id
@property(copy,nonatomic)NSString *touid;//接收人id
@property(copy,nonatomic)NSString *name;//名字
@property(nonatomic)NSInteger sendtype;//0 发送  1 接收
@property(nonatomic,copy)NSString *joinId;//加入组织ID
@property (nonatomic, copy) NSString * questionID;//问题ID
@property(copy,nonatomic)NSString *sendtime;//发送时间
@property(copy,nonatomic)NSString *msgid;//消息id
@property(copy,nonatomic)NSDate *orderytime;//发送时间
@property(copy,nonatomic)NSString *thumbnail;// 图片缩略图
@property(copy,nonatomic)NSString *localpath;//图片缓存
@property(copy,nonatomic)NSString *duration;//语音播放时长
@property(nonatomic)NSInteger success;//0 失败  1 成功
@property(nonatomic)NSInteger chatType;//聊天类型 0 个人/公众号 1 群组 2 客服 3加入组织申请
@property(copy,nonatomic)NSString *isread;//0 未读  1 已读
@property(copy,nonatomic)NSString *receiverread;
@property(copy,nonatomic)NSString *progress;//下载进度
@property(copy,nonatomic)NSString *totalsize;//总大小
@property(nonatomic,copy)NSString *LoginAccount;//手机号
@property(copy,nonatomic)NSString *sendcontent;//发送内容
@property(copy,nonatomic)NSString *pushtype;//推送类型
@property(nonatomic,copy)NSString *isStar;//消息来源
@property (nonatomic, copy) NSString* chatphoto;//聊天对象头像
@property(nonatomic)CLLocationCoordinate2D sendCoordinate;
@property(copy,nonatomic)UIImage *chatimage;//发送时展示的图片
@property (nonatomic ) BOOL  isSelect;//转发消息是否选中
@property (nonatomic, copy) NSString* grade;//年级
@property (nonatomic, copy) NSString* subjects;//科目
@property (nonatomic, copy) NSString* teacherID;// 老师服务器id


@end
