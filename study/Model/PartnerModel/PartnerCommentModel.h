//
//  PartnerCommentModel.h
//  study
//  朋友圈评论模型
//  Created by yang on 15/9/25.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnerCommentModel : NSObject

@property (nonatomic, assign) NSInteger commentId;       // 评论id，传入commentId时为删除评论，不传或者为0时为添加评论
@property (nonatomic, assign) NSInteger feedId;          // 内容id
@property (nonatomic, assign) NSInteger userId;          // 用户Id
@property (nonatomic, assign) NSInteger commentedId;     // 被评论id（无为0）
@property (nonatomic, assign) NSInteger phone;           // 手机号
@property (nonatomic, assign) NSInteger deleteFlag;      //
@property (nonatomic, copy)   NSString *commentDetail;   // 评论内容
@property (nonatomic, copy)   NSString *addTime;         // 评论时间
@property (nonatomic, copy)   NSString *nickname;        // 昵称
@property (nonatomic, copy)   NSString *photo;           // 头像

@end
