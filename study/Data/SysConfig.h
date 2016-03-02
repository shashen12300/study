//
//  SysConfig.h
//  jinherIU
//  系统配置
//  Created by hoho108 on 14-5-15.
//  Copyright (c) 2014年 hoho108. All rights reserved.

#import <Foundation/Foundation.h>

@interface SysConfig : NSObject
+ (NSString *)firstLaunch;//首次打开
+ (NSString *)isLogin;//已登录
+ (NSString *)userId;//用户id
+ (NSString *)loginUserId;//当前登录用户id
+ (NSString *)loginUserPhone;//当前登录用户手机号
+ (NSString *)loginUserPass;//当前登录用户密码
+ (NSString *)loginUserJid;//当前用户jid
+ (NSString *)loginUserName;//当前登录用户昵称
+ (NSString *)loginUserPicture;//当前登录用户头像
+ (NSString *)IsSoundPlay;//使用听筒模式播放
+ (NSString *)serverUTCTime;//系统时间;





//推送设置
+(NSString *)isSaveMessages;//开启后将收到提醒
+(NSString *)isVibration;//震动
+(NSString *)isBell;//铃声



@end



