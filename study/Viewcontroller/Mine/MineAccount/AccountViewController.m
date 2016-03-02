//
//  AccountViewController.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AccountViewController.h"
#import "DetailViewController.h"
#import "BalanceViewController.h"
#import "RechargeViewController.h"
#import "CashViewContriller.h"
#import "MyBankViewController.h"

static NSString *_cellIdentifier = @"cellIdentifier";

@interface AccountViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AccountViewController
{
    UITableView *_tableView;
    NSArray *_signArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _signArray = @[@"收支明细", @"我的余额", @"充值", @"提现", @"我的银行卡"];
    [self creatNavgation];
    [self addTableview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatNavgation
{
    self.title = @"我的账户";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)addTableview{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, Main_Width, 200)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.scrollEnabled = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
    cell.textLabel.text = _signArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = UIColorFromRGB(0x656565);
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{//点击的是收支明细
            DetailViewController *detail = [[DetailViewController alloc] init];
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 1:{//点击的是我的余额
            BalanceViewController *balance = [[BalanceViewController alloc] init];
            [self.navigationController pushViewController:balance animated:YES];
        }
            break;
        case 2:{//点击的是充值
            RechargeViewController *rechage = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:rechage animated:YES];
        }
            break;
        case 3:{//点击的是提现
            CashViewContriller *cash = [[CashViewContriller alloc] init];
            [self.navigationController pushViewController:cash animated:YES];
        }
            break;
        case 4:{//点击的是我的银行卡
            MyBankViewController *bank = [[MyBankViewController alloc] init];
            [self.navigationController pushViewController:bank animated:YES];
        }
            break;
        default:
            break;
    }
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
