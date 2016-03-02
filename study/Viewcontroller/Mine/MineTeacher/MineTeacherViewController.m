//
//  MineTeacherViewController.m
//  study
//
//  Created by mijibao on 16/2/2.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MineTeacherViewController.h"
#import "MinePartnerTableViewCell.h"
#import "MinePartnerManager.h"
#import "MinePartnerModel.h"
#import "ImageRequestCore.h"
#import "PartnerInfoViewController.h"
#import "MyFriendSorted.h"
#import "MinePartnerCore.h"

@interface MineTeacherViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MinePartnerCoreDelegate>

@end

static NSString *_sectionIdentifier = @"_sectionIdentifier";

@implementation MineTeacherViewController
{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    NSMutableArray *_partnerArray;//我的伙伴数据
    NSMutableDictionary *_sorteDictionary;//按首字母分类汇总后的伙伴信息
    NSMutableArray *_searchArray;//搜索后的数据
    MBProgressHUD *_hud;//菊花
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的人";
    //从数据库读取数据
    _partnerArray = [[NSMutableArray alloc] initWithArray:[[MinePartnerManager shareInstance] gainDataArray]];
    if (_partnerArray.count == 0) {
        [self creatHudWithText:@"加载中..."];
    }
    [self creatUI];
    [self getMinePartnerData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatUI
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 40)];
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(_searchBar), Main_Width, Main_Height - 64)style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_tableView registerClass:[MinePartnerTableViewCell class] forCellReuseIdentifier:_sectionIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sorteDictionary allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self contactsArrayForSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MinePartnerTableViewCell *cell = (MinePartnerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_sectionIdentifier];
    if (cell == nil)
    {
        cell = [[MinePartnerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_sectionIdentifier];
    }
    NSMutableArray *array = [self contactsArrayForSection:indexPath.section];
    MinePartnerModel *model = array[indexPath.row];
    [ImageRequestCore requestImageWithPath:model.photo withImageView:cell.cellImageView placeholderImage:[UIImage imageNamed: @"Mine_Syshead"]];
    cell.cellLabel.text = model.nickname;
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arry = [self sortContactKey];
    NSString *headString = [arry objectAtIndex:section];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 15)];
    headView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 15)];
    keyLabel.text = headString;
    keyLabel.font = [UIFont systemFontOfSize:9];
    keyLabel.textColor = UIColorFromRGB(0xaaaaaa);
    keyLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:keyLabel];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [self contactsArrayForSection:indexPath.section];
    MinePartnerModel *model = array[indexPath.row];
    PartnerInfoViewController *infoView = [[PartnerInfoViewController alloc] init];
    infoView.partnerId = model.userId;
    infoView.partnerType = model.type;
    [self.navigationController pushViewController:infoView animated:YES];
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{//搜索框代理事件，根据搜索框内容刷新列表
    _searchArray = [[NSMutableArray alloc] init];
    if ([JZCommon isBlankString:searchText])
    {//如果搜索框内容为空，显示全部数据
        _searchArray = [[NSMutableArray alloc] initWithArray:_partnerArray];
    }else
    {//如果搜索框数据不为空，根据搜索框输入的内容刷新列表
        for (MinePartnerModel *model in _partnerArray) {
            NSString *spelling = [JZCommon getChineseSpelling:model.nickname];
            if ([spelling containsString:searchText] || [model.nickname containsString:searchText]) {
                [_searchArray addObject:model];
            }
        }
    }
    MyFriendSorted *sorted = [[MyFriendSorted alloc]init];
    _sorteDictionary = [sorted classifyContacts:_searchArray];
    [_tableView reloadData];
}

#pragma mark 从服务器获取伙伴数据
- (void)getMinePartnerData
{
    MinePartnerCore *core = [[MinePartnerCore alloc] init];
    core.delegate = self;
    [core requestPartnerWithUserId:[UserInfoList loginUserId]];
}

#pragma mark MinePartnerCoreDelegate（网络请求回调）
- (void)passRequstResult:(BOOL)result infomation:(NSMutableArray *)array
{
    if (!result) {
        [self showMessage:@"请求失败"];
    }else{
        [_partnerArray removeAllObjects];
        _partnerArray = [NSMutableArray arrayWithArray:array];
        MyFriendSorted *sorted = [[MyFriendSorted alloc]init];
        _sorteDictionary = [sorted classifyContacts:_partnerArray];
        [_tableView reloadData];
        [self stopHud];
    }
}

#pragma mark 对我的伙伴昵称首字母进行排序
- (NSArray *)sortContactKey
{
    //对首字母进行排序
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_sorteDictionary];
    [dic removeObjectForKey:@"#"];
    NSArray *keyArray = [dic allKeys];
    NSArray *sortedArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
    NSMutableArray *needSortedArray = [NSMutableArray arrayWithArray:sortedArray];
    NSString *string = @"#";
    [needSortedArray addObject:string];
    return needSortedArray;
}

- (NSMutableArray *)contactsArrayForSection:(NSInteger)section
{
    //获取某一个首字母下所有的伙伴信息
    NSArray *keys = [self sortContactKey];
    NSString *key = keys[section];
    return (NSMutableArray *)_sorteDictionary[key];
}

#pragma mark 加载菊花
- (void)creatHudWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = text;
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelColor = [UIColor whiteColor];
    });
}

- (void)stopHud {
    [_hud hide:YES];
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
