//
//  DetailViewController.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"

static NSString *_cellIdentifier = @"cellIdentifier";

@interface DetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DetailViewController
{
    UITableView *_tableView;
    NSArray *_detailArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailArray = @[@{@"action":@"提现", @"time":@"2016-01-06", @"retain":@"700.00", @"count":@"200"}, @{@"action":@"提现", @"time":@"2016-01-06", @"retain":@"700.00", @"count":@"200"}, @{@"action":@"充值", @"time":@"2016-01-02", @"retain":@"900.00", @"count":@"100"}, @{@"action":@"在线支付", @"time":@"2015-11-06", @"retain":@"800.00", @"count":@"200"}, @{@"action":@"在线支付", @"time":@"2016-10-26", @"retain":@"1000.00", @"count":@"200"}];
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    _tableView.scrollEnabled = YES;
    [_tableView registerClass:[DetailTableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _detailArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (cell == nil)
    {
        cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_cellIdentifier];
    }
    NSDictionary *dic = _detailArray[indexPath.row];
    cell.actionLabel.text = dic[@"action"];
    cell.retainLabel.text = dic[@"retain"];
    cell.timeLabel.text = dic[@"time"];
    cell.countLabel.text = dic[@"count"];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == _detailArray.count -1) {
        [cell.lineView removeFromSuperview];
    }
    return cell;
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
