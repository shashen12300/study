//
//  PartnerFriendIndoModel.h
//  study
//  通讯录模型
//  Created by yang on 16/1/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnerFriendIndoModel : NSObject

@property (nonatomic, assign) NSInteger addId;      // 添加id
@property (nonatomic, assign) NSInteger addStatus;  // 添加状态：0：邀请（未注册）
                                                        //     1：待验证（已发送请求添加好友）
                                                        //     2：已经添加（好友）
                                                        //     3: 拒绝（被添加人拒绝）
                                                        //     4: 未发送请求好友(已经注册)）
@property (nonatomic, assign) NSInteger addUserId;  // 添加用户
@property (nonatomic, assign) NSInteger phone;      // 手机号码
@property (nonatomic, copy)   NSString *photo;      // 头像
@property (nonatomic, copy)   NSString *nickname;   // 昵称

@end
