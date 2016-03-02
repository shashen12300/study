//
//  HonorsViewController.m
//  study
//
//  Created by mijibao on 16/2/1.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "HonorsViewController.h"
#import "UserInfoCore.h"

@interface HonorsViewController ()<UITextViewDelegate, UserInfoCoreDelegate>

@end

@implementation HonorsViewController
{
    UITextView *_textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所获荣誉";
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, Main_Width - 20, 300)];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 8;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.textColor = UIColorFromRGB(0x656565);
    [self.view addSubview:_textView];
    [self setRightBarButtonItemTitle:@"保存"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setRightBarButtonItemTitle:(NSString *)string{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:nil action:@selector(saveHonorsBtnClicked)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0xff7949);
}

- (void)saveHonorsBtnClicked{
    UserInfoCore *core = [[UserInfoCore alloc] init];
    core.delegate = self;
    [core changeUserInfomationWithUserId:[UserInfoList loginUserId] newInfomation:_textView.text infoKey:@"honors" saveKey:[AccountManeger loginUserHonors]];
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
