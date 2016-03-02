//
//  LoginViewController.m
//  study
//
//  Created by mijibao on 15/9/2.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCore.h"
#import "AppDelegate.h"
#import "SecondViewController.h"
#import "WXManager.h"
#import "WeiboSDK.h"
#import "WBManager.h"

@interface LoginViewController ()<WXApiDelegate, WeiboSDKDelegate>

@end

@implementation LoginViewController
{
    UITextField *_userTelephoneText;//手机号码输入框
    UITextField *_userPassWordText;//密码输入框
    UIActivityIndicatorView *_activityIndicator;//菊花
    NSDictionary *_userInfoDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdLoginSuccess:) name:kSFloginSuccess object:nil];
    //创建页面
    [self creatUI];
    //添加取消键盘手势
    UITapGestureRecognizer *cancelKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyBoard)];
    [self.view addGestureRecognizer:cancelKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark 创建页面
- (void)creatUI
{
    UIImageView *backGroundView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [backGroundView setImage:[UIImage imageNamed:@"Login_BackGround"]];
    backGroundView.userInteractionEnabled = YES;
    [self.view addSubview:backGroundView];
    //登陆信息输入框
    UIImageView *hiView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Width - widget_height(306)) *0.5 , widget_height(240), widget_height(306), widget_height(102))];
    [hiView setImage:[UIImage imageNamed:@"Login_Hi"]];
    [backGroundView addSubview:hiView];
    NSArray *textArray = @[@"手机号", @"验证码"];
    for (int i = 0; i < 2; i ++) {
        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake((Main_Width - 265) * 0.5, MaxY(hiView) + widget_height(214) + i *65, 265, 35)];
        textView.backgroundColor = RGBAVCOLOR(0xffffff, 0.4);
        textView.layer.cornerRadius = 8;
        textView.userInteractionEnabled = YES;
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 45, 35)];
        leftLabel.text = textArray[i];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.textColor = [UIColor whiteColor];
        [textView addSubview:leftLabel];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MaxX(leftLabel) + 10, 0, 265 - 125, 35)];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = [UIColor whiteColor];
        textField.tag = 100 + i;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textView addSubview:textField];
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(textField) + 15, 11.5, 15, 12)];
        [rightBtn setImage:[UIImage imageNamed:@"Login_Arrow"] forState:UIControlStateNormal];
        rightBtn.tag = 1000 + i;
        [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [textView addSubview:rightBtn];
        [backGroundView addSubview:textView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((Main_Width - 206) * 0.5 + i * ((180 - widget_height(40)) * 0.5 + 26 + widget_height(40)), MaxY(hiView) + widget_height(440) + 65, (180 - widget_height(40)) * 0.5, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xffffff);
        lineView.alpha = 0.4;
        [backGroundView addSubview:lineView];
    }
    _userTelephoneText = (UITextField *)[self.view viewWithTag:100];
    _userPassWordText = (UITextField *)[self.view viewWithTag:101];
    _userTelephoneText.text = [[NSUserDefaults standardUserDefaults] objectForKey:KLoginUserTelPhone];
    //第三方登陆按钮
    UIImageView *orImage = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Width - 206) * 0.5 + (180 - widget_height(40)) * 0.5 + 13, MaxY(hiView)+widget_height(432) + 65 , widget_height(40), widget_height(17))];
    [orImage setImage:[UIImage imageNamed:@"Login_OR"]];
    [backGroundView addSubview:orImage];
    NSArray *thirdImageArray = [[NSArray alloc]init];
    thirdImageArray = @[@"Login_QQ", @"Login_Weixin", @"Login_Sina"];
    for (int i = 0; i < thirdImageArray.count; i ++) {
        UIButton *thirdLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake((Main_Width - (70 + 3 *widget_height(90))) * 0.5 + (35 + widget_height(90)) * i, MaxY(orImage) + widget_height(46), widget_height(90), widget_height(90))];
        thirdLoginBtn.tag = 10000 + i;
        [thirdLoginBtn setImage:[UIImage imageNamed:thirdImageArray[i]] forState:UIControlStateNormal];
        [thirdLoginBtn addTarget:self action:@selector(thirdLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backGroundView addSubview:thirdLoginBtn];
        if (![WXApi isWXAppInstalled] && i == 1) {
            thirdLoginBtn.hidden = YES;
        }
    }
}

#pragma mark 点击输入框右侧按钮
- (void)rightBtnClicked:(UIButton *)btn
{
    LoginCore *login = [[LoginCore alloc] init];
    login.delegate = self;
    if (btn.tag == 1000) {//点击获取验证码
        if ([self checkTelephone:_userTelephoneText.text]) {
            _userPhone = _userTelephoneText.text;
            NetworkStatus status = [self checkCurrentNetWork];
            if (status != 0) {
                [login getAcessCodeWithUserPhone:_userPhone];
            }
        }else{
            [self creatAlert:@"请输入正确的手机号码"];
        }
    }else if (btn.tag == 1001){//点击至下一页面
        NSLog(@"点击后跳转至用户类型选择页面");
        if ([_userPassWordText.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kAccessPhoneCode]]) {
            self.userPass = _userPassWordText.text;
            SecondViewController *type = [[SecondViewController alloc] init];
            type.minePhone = _userPhone;
            type.phoneCode = _userPass;
            type.sfLogin = NO;
            [self presentViewController:type animated:YES completion:nil];
        }else{
            [self creatAlert:@"请输入正确的验证码"];
        }
    }
}

#pragma mark LoginCoreDelegate
- (void)passPhoneCodeResult:(BOOL)isSuccess returnResult:(NSString *)returnResult
{//验证码回调
    if (isSuccess) {
        [self showMessage:returnResult];
    }else{
        [self showMessage:@"获取验证码失败"];
    }
}

#pragma mark 点击第三方登陆按钮
- (void)thirdLoginBtnClicked:(UIButton *)btn
{
    if (btn.tag == 10000) {//点击的是qq登陆
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.qq.delegate = self;
        [delegate.qq login];
    }else if (btn.tag == 10001){//点击的是微信登陆
        WXManager *manger = [[WXManager alloc] init];
        [manger wxLogin];
    }else{//点击的是新浪微博登陆
        WBManager *manager = [[WBManager alloc] init];
        [manager sinaLogin];
    }
}

#pragma mark 手机号码客户端基础校验
- (BOOL)checkTelephone:(NSString *)telephone
{
    NSString *regex = @"^1[3|4|5|7|8|9][0-9][0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:telephone];
    if (!isMatch)
    {
        return NO;
    }
    return YES;
}

#pragma mark QQDelegate(qq登陆回调)

//- (void)passQQloginResult:(BOOL)result
//              description:(NSString *)description
//        disuserInfomation:(NSDictionary *)infomation
//{
//    if (!result) {
//        [self showMessage:description];
//    }else{
//        _userInfoDic = [[NSDictionary alloc]initWithDictionary:infomation];
//        NSLog(@"哈哈，登陆成功，用户信息，调用第三方登陆接口");
//    }
//}

- (void)creatAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

//取消键盘手势
- (void)cancelKeyBoard{
    [self.view endEditing:YES];
}

- (void)thirdLoginSuccess:(NSNotification *)notification
{
    SecondViewController *second = [[SecondViewController alloc] init];
    second.minePhone = notification.userInfo[@"openId"];
    second.sfType = notification.userInfo[@"accountType"];
    second.sfLogin = YES;
    [self presentViewController:second animated:YES completion:nil];
}

@end
