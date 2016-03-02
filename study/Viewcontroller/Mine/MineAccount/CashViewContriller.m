//
//  CashViewContriller.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CashViewContriller.h"
#import "MyBankViewController.h"

@interface CashViewContriller ()

@end

@implementation CashViewContriller

{
    UIImageView *_bankImage;//银行图标
    UILabel *_bankNameLabel;//银行名称
    UILabel *_bankCardLabel;//银行卡号
    UITextField *_moneyText;//充值金额
     NSDictionary *_bankCardInfoDic;//当前所选银行卡信息
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _bankCardInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentBankCard];
    if (_bankCardInfoDic) {
        if ([_bankCardInfoDic[@"name"] isEqualToString:@"中国工商银行"]) {
            [_bankImage setImage:[UIImage imageNamed:@"工商"]];
        }else if ([_bankCardInfoDic[@"name"] isEqualToString:@"中国建设银行"]){
            [_bankImage setImage:[UIImage imageNamed:@"建设"]];
        }
        _bankNameLabel.text = _bankCardInfoDic[@"name"];
        NSString *string = [_bankCardInfoDic[@"num"] substringWithRange:NSMakeRange([_bankCardInfoDic[@"num"] length] - 4, 4)];
        _bankCardLabel.text = [NSString stringWithFormat:@"尾号%@", string];
    }
}

- (void)creatNavgation
{
    self.title = @"提现";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatUI{
    //银行图标
    UIView *bankView = [[UIView alloc] initWithFrame:CGRectMake(0, widget_height(20), Main_Width, widget_height(140))];
    bankView.backgroundColor = [UIColor whiteColor];
    bankView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBankCardView)];
    [bankView addGestureRecognizer:gesture];
    _bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(50), widget_height(60) * 0.5, widget_height(80), widget_height(80))];
    [bankView addSubview:_bankImage];
    [self.view addSubview:bankView];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSDictionary *dic3 = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSString *string = @"收支明细";
    CGSize size1 = [string sizeWithAttributes:dic];
    CGSize size2 = [string sizeWithAttributes:dic2];
    CGSize size3 = [string sizeWithAttributes:dic3];
    //银行名称
    _bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_bankImage) + widget_width(32), widget_height(32), Main_Width - MaxX(_bankImage) - widget_width(32) - 30,size1.height)];
    [self setLabelStatus:_bankNameLabel WithTitle:nil withFont:15 color:UIColorFromRGB(0x434343)];
    [bankView addSubview:_bankNameLabel];
    //银行卡号
    _bankCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_bankImage) + widget_width(32), MaxY(_bankNameLabel) + widget_height(24), Main_Width - MaxX(_bankImage) - widget_width(32) - 30,size2.height)];
    [self setLabelStatus:_bankCardLabel WithTitle:nil withFont:13 color:UIColorFromRGB(0x7e7e7e)];
    [bankView addSubview:_bankCardLabel];
    //小箭头
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake( Main_Width - 16, (widget_height(140) - 10) * 0.5, 6, 10)];
    [arrowView setImage:[UIImage imageNamed:@"Cell_Arrow"]];
    [bankView addSubview:arrowView];
    
    UIView *cashView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(bankView) + widget_height(24), Main_Width, widget_height(80))];
    cashView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cashView];
    UILabel *cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(MinX(_bankImage), 0, size3.width, widget_height(80))];
    [self setLabelStatus:cashLabel WithTitle:@"转出金额" withFont:14 color:UIColorFromRGB(0x434343)];
    cashLabel.textAlignment = NSTextAlignmentCenter;
    [cashView addSubview:cashLabel];
    //输入金额框
    _moneyText = [[UITextField alloc] initWithFrame:CGRectMake(MaxX(cashLabel) + widget_width(10), 0, Main_Width - MaxX(cashLabel) - 30, widget_height(80))];
    _moneyText.placeholder = @"请输入充值金额";
    _moneyText.textAlignment = NSTextAlignmentLeft;
    _moneyText.font = [UIFont systemFontOfSize:12];
    _moneyText.textColor = UIColorFromRGB(0xc0c0c0);
    _moneyText.keyboardType = UIKeyboardTypeNumberPad;
    [cashView addSubview:_moneyText];
    
    //转出按钮
    UIButton *rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MaxY(cashView) + widget_height(50), Main_Width, widget_height(80))];
    [self setBtnStatus:rechargeBtn WithBackColor:UIColorFromRGB(0xff6949) withTitle:@"确认转出" withTitleColor:[UIColor whiteColor] withFont:15];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
}

- (void)rechargeBtnClicked
{
    NSLog(@"确认转出,金额为%@，卡号为%@", _moneyText.text, _bankCardInfoDic[@"num"]);
}

- (void)gotoBankCardView
{
    MyBankViewController *bank = [[MyBankViewController alloc] init];
    [self.navigationController pushViewController:bank animated:YES];
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
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
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
