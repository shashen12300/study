//
//  BalanceViewController.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BalanceViewController.h"
#import "RechargeViewController.h"
#import "CashViewContriller.h"

@interface BalanceViewController ()

@end

@implementation BalanceViewController

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

- (void)creatNavgation
{
    self.title = @"我的余额";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatUI
{
    UIImageView *moneyImage = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Width - 64) * 0.5, widget_height(30), 64, 64)];
    [moneyImage setImage:[UIImage imageNamed:@"Account_Money"]];
    [self.view addSubview:moneyImage];
    NSString *string1 = @"我的余额";
    NSString *string2 = @"￥600";
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    NSDictionary *dic2 = @{NSFontAttributeName: [UIFont systemFontOfSize:35]};
    CGSize size1 = [string1 sizeWithAttributes:dic];
    CGSize size2 = [string2 sizeWithAttributes:dic2];
    //我的余额标签
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake( (Main_Width - size1.width) * 0.5, MaxY(moneyImage) + widget_height(30), size1.width, size1.height)];
    [self setLabelStatus:balanceLabel WithTitle:string1 withFont:13 color:UIColorFromRGB(0x4b4a4a)];
    [self.view addSubview:balanceLabel];
    //余额内容标签
    UILabel *retainLabel = [[UILabel alloc] initWithFrame:CGRectMake((Main_Width - size2.width) * 0.5, MaxY(balanceLabel) + widget_height(30), size2.width, size2.height)];
    [self setLabelStatus:retainLabel WithTitle:string2 withFont:35 color:UIColorFromRGB(0x4b4a4a)];
    [self.view addSubview:retainLabel];
    //充值按钮
    UIButton *rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake((Main_Width - widget_width(580)) * 0.5, MaxY(retainLabel) + widget_height(48), widget_width(580), widget_height(80))];
    [self setBtnStatus:rechargeBtn WithBackColor:UIColorFromRGB(0xff6949) withTitle:@"充值" withTitleColor:[UIColor whiteColor] withFont:15];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    //提现按钮
    UIButton *cashBtn = [[UIButton alloc] initWithFrame:CGRectMake((Main_Width - widget_width(580)) * 0.5, MaxY(rechargeBtn) + widget_height(30), widget_width(580), widget_height(80))];
    [self setBtnStatus:cashBtn WithBackColor:[UIColor whiteColor] withTitle:@"提现" withTitleColor:UIColorFromRGB(0x5e5e5e) withFont:15];
    [cashBtn addTarget:self action:@selector(cashBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cashBtn];
}

- (void)setLabelStatus:(UILabel *)label WithTitle:(NSString *)title withFont:(NSInteger)t color:(UIColor *)color
{
    label.text = title;
    label.font = [UIFont systemFontOfSize:t];
    label.textColor = color;
    [self.view addSubview:label];
}

- (void)setBtnStatus:(UIButton *)btn WithBackColor:(UIColor *)backcolor withTitle:(NSString *)title withTitleColor:(UIColor *)titlecolor withFont:(NSInteger)fontsize
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:backcolor];
    [btn setTitleFont:[UIFont systemFontOfSize:fontsize]];
    btn.layer.cornerRadius = 12;
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
}

- (void)rechargeBtnClicked
{
    NSLog(@"点击了充值按钮");
    RechargeViewController *recharge = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:recharge animated:YES];
}

- (void)cashBtnClicked
{
    NSLog(@"点击了提现按钮");
    CashViewContriller *cash = [[CashViewContriller alloc] init];
    [self.navigationController pushViewController:cash animated:YES];
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
