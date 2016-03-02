//
//  QQ.h
//  ComponentProject
//
//  Created by jzkj on 11/24/15.
//  Copyright © 2015 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>

@protocol QQDelegate <NSObject>

/**
 *  qq登陆回调
 *
 *  @param result  登陆结果
 *  @param description 结果描述
 *  @param infomation 用户信息
 *
 */
-(void)passQQloginResult:(BOOL)result
             description:(NSString *)description
       disuserInfomation:(NSDictionary *)infomation;

@end

@interface QQ : NSObject<QQApiInterfaceDelegate,TencentSessionDelegate>

@property (strong, nonatomic) NSDictionary *userInfoDic;//用户qq信息
@property (weak, nonatomic) id<QQDelegate>delegate;
/**
 设置应用需要用户授权的API列表，并进行登陆授权请求
 */
- (void)login;

@end
