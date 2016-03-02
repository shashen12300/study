//
//  MyBankViewController.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MyBankViewController.h"
#import "MyBankTableViewCell.h"
#import "AddCardViewController.h"

static NSString *_cellIdentifier = @"cellIdentifier";

@interface MyBankViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MyBankViewController
{
    UITableView *_tableView;
    NSArray *_myBankArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行";
    [self setRightBarButtonItemImage:@"Account_AddBank"];
//    _myBankArray = @[@{@"name":@"中国工商银行",@"type":@"储蓄卡", @"num":@"6217222233452134898"}, @{@"name":@"中国建设银行",@"type":@"信用卡", @"num":@"6217222233452137777"}, @{@"name":@"中国建设银行",@"type":@"储蓄卡", @"num":@"6217222233452136666"}];
    [self addTableview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     _myBankArray = [[NSUserDefaults standardUserDefaults] objectForKey:[AccountManeger loginUserBackCard]];
}

- (void)addTableview{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(widget_width(36), 0, Main_Width - widget_width(72), Main_Height - 64)];
    _tableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    [_tableView registerClass:[MyBankTableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myBankArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return widget_height(170);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return widget_height(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBankTableViewCell *cell = (MyBankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (cell == nil)
    {
        cell = [[MyBankTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_cellIdentifier];
    }
    NSDictionary *dic = _myBankArray[indexPath.section];
    if ([dic[@"name"] isEqualToString:@"中国工商银行"]) {
        cell.backgroundColor = UIColorFromRGB(0xda3c43);
        [cell.signImage setImage:[UIImage imageNamed:@"工商"]];
    }else if([dic[@"name"] isEqualToString:@"中国建设银行"])
    {
        cell.backgroundColor = UIColorFromRGB(0x3689c3);
        [cell.signImage setImage:[UIImage imageNamed:@"建设"]];
    }
    cell.nameLabel.text = dic[@"name"];
    cell.typeLabel.text = dic[@"type"];
    NSString *string = [dic[@"num"] substringWithRange:NSMakeRange([dic[@"num"] length] - 4, 4)];
    cell.cardLabel.text = [NSString stringWithFormat:@"**** **** **** %@", string];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.layer.cornerRadius = 12;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _myBankArray[indexPath.section];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kCurrentBankCard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBankCard{
    NSLog(@"添加银行卡号");
    AddCardViewController *card = [[AddCardViewController alloc] init];
    [self.navigationController pushViewController:card animated:YES];
}
- (void)setRightBarButtonItemImage:(NSString *)imageName{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(addBankCard)];
    self.navigationItem.rightBarButtonItem = item;
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
