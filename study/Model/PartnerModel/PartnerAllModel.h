//
//  PartnerAllModel.h
//  study
//  朋友圈动态模型
//  Created by yang on 15/9/25.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnerPartModel : NSObject

@property (nonatomic, assign) NSInteger userId;        // 用户id，该字段不为空，数字类型字符
@property (nonatomic, assign) NSInteger duration;      // 时长
@property (nonatomic, assign) NSInteger commentCount;  // 评论计数
@property (nonatomic, assign) NSInteger invalid;       //
@property (nonatomic, assign) NSInteger phone;         // 手机号
@property (nonatomic, assign) NSInteger praiseCount;   // 点赞计数
@property (nonatomic, assign) NSInteger uid;           //
@property (nonatomic, assign) NSInteger feedId;        // 新鲜事id
//@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy)   NSString *content;       // 发布文字内容
@property (nonatomic, copy)   NSString *visibleRange;  // 可见范围G=公开，S=个人
@property (nonatomic, copy)   NSString *photourl;      // 图片地址
@property (nonatomic, copy)   NSString *smphotourl;    // 图片缩略图地址
@property (nonatomic, copy)   NSString *firstpicurl;   // 链接的首图地址
@property (nonatomic, copy)   NSString *urlcontent;    // 链接内容
@property (nonatomic, copy)   NSString *title;         // 链接标题
@property (nonatomic, copy)   NSString *url;           // 链接地址
@property (nonatomic, copy)   NSString *webcontent;    // 链接正文户id
@property (nonatomic, copy)   NSString *videoSign;     // 标识
@property (nonatomic, copy)   NSString *location;      // 发送者位置
@property (nonatomic, copy)   NSString *lecrureId;     // 大课id
@property (nonatomic, copy)   NSString *picurl;        // 大课缩略图
@property (nonatomic, copy)   NSString *addtimeB;      // 大课发布时间
@property (nonatomic, copy)   NSString *titleB;        // 大课标题
@property (nonatomic, copy)   NSString *grade;         // 年级
@property (nonatomic, copy)   NSString *subject;       // 课程
@property (nonatomic, copy)   NSString *type;          // 类型（type必须有值 有且仅有4个值
                                                         //  type=A 查询所有动态自己的和自己的好友以及评论和点赞的数据
                                                         //  type=M 查询自己的动态和评论点赞的数据
                                                         //  type=S 查询学生的动态和评论点赞的数据
                                                         //  type=T 查询老师的动态和评论点赞的数据）

@property (nonatomic, copy)   NSString *addTime;       // 添加时间
@property (nonatomic, copy)   NSString *nickname;      // 昵称
@property (nonatomic, copy)   NSString *nicknameB;     //
@property (nonatomic, copy)   NSString *photo;         // 头像
@property (nonatomic, copy)   NSString *signature;     // 个性签名
@property (nonatomic, copy)   NSString *urlB;          // 大课视频路径
@property (nonatomic, copy)   NSString *picture;       // 背景图

@end

@interface PartnerAllModel : NSObject

@property (nonatomic, strong) PartnerPartModel *model;
@property (nonatomic, strong) NSMutableArray *userPraise;  // 赞
@property (nonatomic, strong) NSMutableArray *userComment; // 评论

@end
