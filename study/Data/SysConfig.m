//
//  SysConfig.m
//  jinherIU
//  系统配置
//  Created by hoho108 on 14-5-15.
//  Copyright (c) 2014年 hoho108. All rights reserved.


#import "SysConfig.h"

@implementation SysConfig

+ (NSString *)firstLaunch{

    return @"firstLaunch";
}

+ (NSString *)isLogin{
    
    return @"isLogin";
}


+ (NSString *)isCompleteInfo{
    
    return @"isCompleteInfo";
}


+ (NSString *)userId{
    
    return @"userId";
}
+ (NSString *)loginUserId{
    
    return @"loginUserId";
}

+ (NSString *)loginUserJid{
    
    return @"loginUserJid";
}

+ (NSString *)loginUserPhone{
    
    return @"loginUserPhone";
}


+ (NSString *)loginUserPass{
    
    return @"loginUserPass";
}


+ (NSString *)loginUserName{
    
    return @"loginUserName";
}

+ (NSString *)loginUserPicture{
    
    return @"loginUserPicture";
}
//系统时间;
+ (NSString *)serverUTCTime{
    return @"serverUTCTime";
}

//使用听筒模式播放
+ (NSString *)IsSoundPlay{
    return @"IsSoundPlay";
}




//推送设置
+(NSString *)isSaveMessages
{
     return @"isSaveMessages";
}
+(NSString *)isVibration
{
     return @"isVibration";
}
+(NSString *)isBell
{
     return @"isBell";
}

@end
