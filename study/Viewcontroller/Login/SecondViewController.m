//
//  SecondViewController.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "SecondViewController.h"
#import "LoginCore.h"

@interface SecondViewController ()<LoginCoreDelegate>

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgation];
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI
{
    UIImageView *backGroundView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [backGroundView setImage:[UIImage imageNamed:@"Login_BackGround"]];
    backGroundView.userInteractionEnabled = YES;
    [self.view addSubview:backGroundView];
    NSArray *imageName = @[@"Login_Student", @"Login_Teacher"];
    NSArray *textArray = @[@"我是学生", @"我是老师"];
    for (int i = 0; i < 2; i ++) {
        UIImageView *typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(120) + i * (Main_Width - widget_width(410)), widget_height(450), widget_width(170), widget_width(170))];
        [typeImage setImage:[UIImage imageNamed:imageName[i]]];
        typeImage.tag = i + 100;
        [backGroundView addSubview:typeImage];
        typeImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseLoginUserType:)];
        [typeImage addGestureRecognizer:gesture];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MinX(typeImage) - 20, MaxY(typeImage) + widget_height(48), widget_width(170) + 40, 30)];
        label.text = textArray[i];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [backGroundView addSubview:label];
    }
}

- (void)creatNavgation
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)choseLoginUserType:(UITapGestureRecognizer *)gesture
{
    [self showHud];
    if (gesture.view.tag == 100) {
        self.mineType = @"S";
    }else{
        self.mineType = @"T";
    }
    NetworkStatus status = [self checkCurrentNetWork];
    if (status != 0) {
        LoginCore *core = [[LoginCore alloc] init];
        core.delegate = self;
        if (!_sfLogin) {
            [core loginUrlRequestWithUserName:self.minePhone passCode:self.phoneCode andType:self.mineType];
        }else{
            [core loginUrlRequestWithUserName:_minePhone accountType:_sfType userType:_mineType];
        }
    }
}

- (void)passLoginResult:(NSString *)result
{//登陆回调
    [self stopHud];
    self.view.userInteractionEnabled = YES;
    if ([result isEqualToString:@"4"]) {
        [self creatAlert:@"账户不存在"];
    }else if ([result isEqualToString:@"5"]){
        [self creatAlert:@"您输入的验证码不正确"];
    }else{
        [self showMessage:@"登陆失败！"];
    }
}

- (void)creatAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
