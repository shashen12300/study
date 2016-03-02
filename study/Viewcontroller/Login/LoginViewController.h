//
//  LoginViewController.h
//  study
//
//  Created by mijibao on 15/9/2.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LoginCore.h"
#import "QQ.h"
#import "WXApi.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate,LoginCoreDelegate,QQDelegate>

@property (copy, nonatomic) NSString *userPhone;//用户账号
@property (copy, nonatomic) NSString *userPass;//用户密码

- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp;

@end
