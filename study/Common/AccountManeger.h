//
//  AccountManeger.h
//  study
//
//  Created by mijibao on 16/1/20.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManeger : NSObject

+(NSString *)loginStatus;//登陆状态
+(NSString *)loginUserId;//用户Id
+(NSString *)loginUserPhone;//用户手机号码
+(NSString *)loginUserNickname;//用户昵称
+(NSString *)loginUserProvince;//用户省份
+(NSString *)loginUserGender;//用户性别
+(NSString *)loginUserType;//用户类型
+(NSString *)loginUserPhoto;//用户身份
+(NSString *)loginUserCity;//用户城市
+(NSString *)loginUserPassword;//用户密码
+(NSString *)loginUserAge;//用户教龄
+(NSString *)loginUserGrade;//用户年级
+(NSString *)loginUserSignature;//用户签名
+(NSString *)loginUserSchool;//学校
+(NSString *)loginUserSubject;//擅长课程
+(NSString *)loginUserPicture;//背景图片
+(NSString *)loginUserHonors;//所获荣誉
+(NSString *)loginUserBackCard;
+(NSString *)loginSftype;//第三方登陆类型
+(NSString *)loginSfStatus;//是否第三方登陆

@end
