//
//  UserInfoList.h
//  study
//
//  Created by mijibao on 15/9/9.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoList : NSObject
+(BOOL)loginStatus;//登陆状态
+(NSString *)loginUserId;//用户Id
+(NSString *)loginUserPhone;//用户手机号码
+(NSString *)loginUserNickname;//用户昵称
+(NSString *)loginUserProvince;//用户省份
+(NSString *)loginUserGender;//用户性别
+(NSString *)loginUserType;//用户类型
+(NSString *)loginUserPhoto;//用户头像
+(NSString *)loginUserCity;//用户城市
+(NSString *)loginUserPassword;//用户密码
+(NSString *)loginUserAge;//用户年龄
+(NSString *)loginUserGrade;//用户年级
+(NSString *)loginUserSignature;//用户签名
+(NSString *)loginUserSchool;
+(NSString *)loginUserSubject;
+(NSString *)loginUserHonors;
+(NSString *)loginUserPicture;//背景图片
+(NSMutableArray *)loginUserBackCard;
+(NSString *)loginSfType;//第三方登陆类型
+(BOOL)loginSfStatus;//是否第三方登陆

@end
