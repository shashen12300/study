//
//  LoginCore.h
//  study
//
//  Created by mijibao on 15/9/9.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LoginCoreDelegate <NSObject>

- (void)passLoginResult:(NSString *)result;
- (void)passPhoneCodeResult:(BOOL)isSuccess returnResult:(NSString *)returnResult;

@end

@interface LoginCore : NSObject

@property (weak,nonatomic) id<LoginCoreDelegate> delegate;

/**
 *  登陆请求
 *
 *  @param userName  用户账号
 *  @param passCode  验证码
 *  @param type      用户类型(T-老师，S-学生)
 */
- (void)loginUrlRequestWithUserName:(NSString *)userName
                           passCode:(NSString *)passCode
                            andType:(NSString *)type;

/**
 *  获取验证码
 *
 *  @param userphone  手机号码
 *
 */
- (void)getAcessCodeWithUserPhone:(NSString *)phone;

/**
 *  第三方登陆
 *
 *  @param userName     用户账号
 *  @param accountType  账户类型（1-QQ, 2-WeiChat，3-Sina）
 *  @param userType     用户类型(T-老师，S-学生)
 */
- (void)loginUrlRequestWithUserName:(NSString *)userName
                        accountType:(NSString *)accountType
                           userType:(NSString *)userType;



@end





