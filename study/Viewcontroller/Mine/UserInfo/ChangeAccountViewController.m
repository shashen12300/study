//
//  ChangeAccountViewController.m
//  study
//
//  Created by mijibao on 16/1/18.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "ChangeAccountViewController.h"
#import "UserInfoCore.h"

@interface ChangeAccountViewController ()<UserInfoCoreDelegate>

@end

@implementation ChangeAccountViewController
{
    UIView *_fistStepView;//进入账号更换页面第一个视图
    UIView *_secondStepView;//确认更换账号后进入的页面
    UITextField *_codeField;//验证码输入框
    UITextField *_newPhoneField;//新手机号输入框
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号";
    [self createFirstStepView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createFirstStepView{
    _fistStepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height)];
    //上方图片
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Width - 60) * 0.5, 28, 64, 64)];
    [phoneView setImage:[UIImage imageNamed:@"UserInfo_AccountTel"]];
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.cornerRadius = 30;
    //第一个文本提示框
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(phoneView) + 15, Main_Width, 20)];
    NSString *string = [UserInfoList loginUserPhone];
    firstLabel.text = [NSString stringWithFormat:@"您当前的账号为%@",string];
    firstLabel.font = [UIFont systemFontOfSize:13];
    firstLabel.textColor = UIColorFromRGB(0x4c4c4c);
    firstLabel.textAlignment = NSTextAlignmentCenter;
    //第二个文本提示框
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(firstLabel) + 15, Main_Width, 20)];
    secondLabel.text = @"更改后个人信息不变，下次可以使用新账号登陆";
    secondLabel.font = [UIFont systemFontOfSize:12];
    secondLabel.textColor = UIColorFromRGB(0x989898);
    secondLabel.textAlignment = NSTextAlignmentCenter;
    //更换账号按钮
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake((Main_Width - 265) * 0.5, MaxY(secondLabel) + 20, 265, 35)];
    [changeBtn setTitle:@"更换账号" forState:UIControlStateNormal];
    changeBtn.backgroundColor = UIColorFromRGB(0xff7949);
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBtn setTitleFont:[UIFont systemFontOfSize:13]];
    changeBtn.layer.cornerRadius = 8;
    [changeBtn addTarget:self action:@selector(changeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_fistStepView addSubview:phoneView];
    [_fistStepView addSubview:firstLabel];
    [_fistStepView addSubview:secondLabel];
    [_fistStepView addSubview:changeBtn];
    [self.view addSubview:_fistStepView];
}

- (void)creatSecondStepView{
    _secondStepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height)];
    //上方提示文本框
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, Main_Width, 20)];
    topLabel.text = @"更改后个人信息不变，下次可以使用新账号登陆";
    topLabel.font = [UIFont systemFontOfSize:12];
    topLabel.textColor = UIColorFromRGB(0x989898);
    topLabel.textAlignment = NSTextAlignmentCenter;
    //手机号输入框
    _newPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(25, MaxY(topLabel) + 15, Main_Width - 97, 28)];
    _newPhoneField.backgroundColor = [UIColor whiteColor];
    _newPhoneField.layer.cornerRadius = 4;
    _newPhoneField.placeholder = @"手机号";
    _newPhoneField.textColor = UIColorFromRGB(0xdbdbdb);
    _newPhoneField.textAlignment = NSTextAlignmentLeft;
    _newPhoneField.font = [UIFont systemFontOfSize:12];
    //验证码按钮
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(_newPhoneField) + 5, MinY(_newPhoneField), 42, 28)];
    codeBtn.backgroundColor = UIColorFromRGB(0xff7949);
    [codeBtn setTitleFont:[UIFont systemFontOfSize:13]];
    [codeBtn setTitle:@"验证" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius = 4;
    [codeBtn addTarget:self action:@selector(getCodeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //验证码输入框
    _codeField = [[UITextField alloc] initWithFrame:CGRectMake(25, MaxY(_newPhoneField) + 10, Main_Width - 50, 28)];
    _codeField.backgroundColor = [UIColor whiteColor];
    _codeField.layer.cornerRadius = 4;
    _codeField.placeholder = @"验证码";
    _codeField.textColor = UIColorFromRGB(0xdbdbdb);
    _codeField.textAlignment = NSTextAlignmentLeft;
    _codeField.font = [UIFont systemFontOfSize:12];
    //确认更换按钮
    UIButton *makeSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, MaxY(_codeField) + 10, Main_Width - 50, 28)];
    [makeSureBtn setTitle:@"确认更换" forState:UIControlStateNormal];
    makeSureBtn.backgroundColor = UIColorFromRGB(0xff7949);
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitleFont:[UIFont systemFontOfSize:13]];
    makeSureBtn.layer.cornerRadius = 8;
    [makeSureBtn addTarget:self action:@selector(makeSureClieked) forControlEvents:UIControlEventTouchUpInside];
    [_secondStepView addSubview:_newPhoneField];
    [_secondStepView addSubview:topLabel];
    [_secondStepView addSubview:codeBtn];
    [_secondStepView addSubview:_codeField];
    [_secondStepView addSubview:makeSureBtn];
    [self.view addSubview:_secondStepView];
}

#pragma mark 更换账号按钮
- (void)changeBtnClicked{
    [_fistStepView removeFromSuperview];
    [self creatSecondStepView];
}

#pragma mark 获取验证码按钮
- (void)getCodeBtnClicked{
    NSLog(@"点击获取验证码按钮");
}

#pragma mark 确认更换按钮
- (void)makeSureClieked{
    NSLog(@"点击确认更换按钮");
    UserInfoCore *core = [[UserInfoCore alloc]init];
    core.delegate = self;
    [core changeUserTelephone:[UserInfoList loginUserPhone] andNewPhone:_newPhoneField.text];
}

#pragma mark UserInfoCoreDelegate
- (void)passChangeResult:(NSString *)result{
    NSString *message = [[NSString alloc] init];
    if ([result isEqualToString:@"success"]) {
        message = @"修改成功";
    }else{
        message = @"修改失败";
    }
    [self showMessage:message];
    [self delaySeconds:0.5f perform:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)delaySeconds:(float)seconds perform:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
