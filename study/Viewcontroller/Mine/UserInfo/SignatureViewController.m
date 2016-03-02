//
//  SignatureViewController.m
//  study
//
//  Created by mijibao on 16/1/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "SignatureViewController.h"
#import "UserInfoCore.h"

@interface SignatureViewController ()<UserInfoCoreDelegate>

@end

@implementation SignatureViewController
{
    UITextField *_sigTextfield;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性签名";
    _sigTextfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, Main_Width, 40)];
    _sigTextfield.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sigTextfield];
    [self setRightBarButtonItemTitle:@"保存"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRightBarButtonItemTitle:(NSString *)string{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:nil action:@selector(saveBtnClicked)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0xff7949);
}

- (void)saveBtnClicked{
    UserInfoCore *core = [[UserInfoCore alloc] init];
    core.delegate = self;
    [core changeUserInfomationWithUserId:[UserInfoList loginUserId] newInfomation:_sigTextfield.text infoKey:@"signature" saveKey:[AccountManeger loginUserSignature]];
}

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
