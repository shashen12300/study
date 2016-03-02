//
//  AddPartnerViewController.m
//  study
//
//  Created by mijibao on 16/2/17.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AddPartnerViewController.h"

@interface AddPartnerViewController ()<UISearchBarDelegate>

@end

@implementation AddPartnerViewController
{
    UISearchBar *_searchBar;//搜索框
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加伙伴";
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 40)];
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.placeholder = @"手机号/微信号/QQ号/新浪微博";
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
    [self.view addSubview:_searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searString = [NSString stringWithFormat:@"正在搜索%@", searchBar.text];
    [self creatHudWithText:searString];
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
