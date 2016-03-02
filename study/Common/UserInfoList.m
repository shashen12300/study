//
//  UserInfoList.m
//  study
//
//  Created by mijibao on 15/9/9.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "UserInfoList.h"
#import "AccountManeger.h"

@implementation UserInfoList

+(BOOL)loginStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults boolForKey:[AccountManeger loginStatus]];
}

+(NSString *)loginUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserId]];
}

+(NSString *)loginUserPhone{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   return [defaults objectForKey:[AccountManeger loginUserPhone]];
}

+(NSString *)loginUserNickname{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserNickname]];
}

+(NSString *)loginUserProvince{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserProvince]];
}

+(NSString *)loginUserGender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:[AccountManeger loginUserGender]];
}

+(NSString *)loginUserType{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserType]];
}

+(NSString *)loginUserPhoto{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserPhoto]];
}

+(NSString *)loginUserCity{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserCity]];
}

+(NSString *)loginUserPassword{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserPassword]];
}

+(NSString *)loginUserAge{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserAge]];
}

+(NSString *)loginUserGrade{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserGrade]];
}

+(NSString *)loginUserSignature{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserSignature]];
}

+(NSString *)loginUserSchool{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserSchool]];
}

+(NSString *)loginUserSubject{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserSubject]];
}

+(NSString *)loginUserPicture{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserPicture]];
}

+(NSString *)loginUserHonors{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserHonors]];
}

+(NSMutableArray *)loginUserBackCard{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [defaults objectForKey:[AccountManeger loginUserBackCard]];
    return array;
}

+(NSString *)loginSfType{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginSftype]];
}

+(BOOL)loginSfStatus{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:[AccountManeger loginSfStatus]];
}
@end
