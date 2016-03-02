//
//  PartnerPraiseModel.h
//  study
//  朋友圈赞模型
//  Created by yang on 15/9/25.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnerPraiseModel : NSObject

@property (nonatomic, assign) NSInteger praiseId;  // 点赞id，传入praiseId时为取消点赞，不传或者为0时为点赞
@property (nonatomic, assign) NSInteger userId;    // 用户id，不为空
@property (nonatomic, assign) NSInteger feedId;    // 内容id，不为空
@property (nonatomic, assign) NSInteger phone;     // 手机号
@property (nonatomic, copy)   NSString *addTime;   // 点赞时间
@property (nonatomic, copy)   NSString *nickname;  // 昵称
@property (nonatomic, copy)   NSString *photo;     // 头像

@end
