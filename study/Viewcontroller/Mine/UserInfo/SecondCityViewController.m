//
//  SecondCityViewController.m
//  study
//
//  Created by mijibao on 16/1/20.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "SecondCityViewController.h"
#import "UserInfoCore.h"
#import "UserInfoViewController.h"

@interface SecondCityViewController ()<UserInfoCoreDelegate>

@end

@implementation SecondCityViewController
{
    UITableView *_tableView;
    NSString *_sectionIdentifier;
    NSDictionary *_locationDic;//当前所选一级地名的下属信息
    NSMutableArray *_cityArray;//二级地名
    NSMutableArray *_countArray;//三级地名
    NSMutableArray *_showArray;//最终显示的地名（如果一级地名是省，显示市名，如果是直辖市，显示区名）
}

- (instancetype)init
{
    if (self = [super init]) {
        _cityArray = [NSMutableArray arrayWithCapacity:0];
        _countArray = [NSMutableArray arrayWithCapacity:0];
        _sectionIdentifier = @"_sectionIdentifier";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
    [self getCityInfomation];
    [self creatTabelView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 解析全国省县信息
- (void)getCityInfomation{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //解析数据
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvinceCityDistrict" ofType:@".plist"]];
        for (NSDictionary *dic in array) {
            for (NSString *akey in dic) {
                if ([akey isEqualToString:_provinceString]) {
                    _locationDic = dic[akey];
                }
            }
        }
        for (NSString *city in _locationDic) {
            NSDictionary *cityDic = _locationDic[city];
            for (NSString *cityKey in cityDic) {
                [_cityArray addObject:cityKey];
                _countArray = cityDic[cityKey];
                NSLog(@"adasdad");
            }
        }
        if (_cityArray.count < 2) {
            _showArray = [NSMutableArray arrayWithArray:_countArray];
        }else{
            _showArray = [NSMutableArray arrayWithArray:_cityArray];
        }
    });
    [_tableView reloadData];
}

- (void)creatTabelView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height - 64)style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_sectionIdentifier];
    cell.textLabel.text = _showArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityString = _showArray[indexPath.row];
    UserInfoCore *core = [[UserInfoCore alloc] init];
    core.delegate = self;
    [core changeUserLocationWithUserId:[UserInfoList loginUserId] withProvince:self.provinceString andCity:cityString];
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
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    }];
}

- (void)delaySeconds:(float)seconds perform:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
@end
