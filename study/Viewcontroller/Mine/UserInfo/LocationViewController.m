//
//  LocationViewController.m
//  study
//
//  Created by mijibao on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "LocationViewController.h"
#import "SecondCityViewController.h"
#import "UserInfoCore.h"


@interface LocationViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@end

@implementation LocationViewController
{
    NSString *_sectionIdentifier;
    UITableView *_tableView;//列表
    NSArray *_dataArray;//数据源
    NSMutableArray *_cityArray;//县
    NSMutableArray *_ProvinceArray;//省
    CLLocationManager *_locManager;//定位管理器
    NSString *_selectedProvince;//选中后的省份
    NSString *_locationResult;//定位后的结果
    NSString *_locaProvince;//定位后的省份
    NSString *_locaCity;//定位后的城市
}

- (instancetype)init
{
    if (self = [super init]) {
        _cityArray = [NSMutableArray arrayWithCapacity:0];
        _ProvinceArray = [NSMutableArray arrayWithCapacity:0];
        _sectionIdentifier = @"_sectionIdentifier";
        _locationResult = @"定位中...";
    }
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"地区";
    [self getLocationInfomation];
    [self createMainUI];
    [self gpsStarting];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)createMainUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height - 64)style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];
}

#pragma mark 读取全国城市列表信息
- (void)getLocationInfomation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //解析数据
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvinceCityDistrict" ofType:@".plist"]];
        for (NSDictionary *dic in array) {
            NSString *string = [[dic allKeys] firstObject];
            [_ProvinceArray addObject:string];
        }
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return _ProvinceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_sectionIdentifier];
    if (indexPath.section == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"Mine_Location"]];
        cell.textLabel.text = _locationResult;
    }else if (indexPath.section == 1){
        cell.textLabel.text = _ProvinceArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
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
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 30)];
    headView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_Width, 30)];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = UIColorFromRGB(0x999999);
    if (section == 0) {
        contentLabel.text = @"定位到的位置";
    }else{
        contentLabel.text = @"全部";
    }
    [headView addSubview:contentLabel];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//点击的是定位后的位置
        if (_locaProvince && _locaCity) {
            UserInfoCore *core = [[UserInfoCore alloc] init];
            core.delegate = self;
            [core changeUserLocationWithUserId:[UserInfoList loginUserId] withProvince:_locaProvince andCity:_locaCity];
        }
    }else{//点击的是地区列表
        SecondCityViewController *city = [[SecondCityViewController alloc] init];
        _selectedProvince = _ProvinceArray[indexPath.row];
        city.provinceString = _selectedProvince;
        [self.navigationController pushViewController:city animated:YES];
    }
}

- (void)gpsStarting
{
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        _locManager = [[CLLocationManager alloc] init];
        _locManager.delegate = self;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locManager.distanceFilter = 100.f;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE_8_0
        [_locManager requestWhenInUseAuthorization];
#endif
        //开始定位
        [_locManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    //解析地理
    CLGeocoder *geo = [CLGeocoder new];
    //开始解析
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //返回placemarks数组
        if (!error && placemarks.count != 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            NSDictionary *locDic = [placemark addressDictionary];
            _locationResult = [NSString stringWithFormat:@"%@%@", locDic[@"City"], locDic[@"SubLocality"] ];
            _locaProvince = locDic[@"City"];
            _locaCity = locDic[@"SubLocality"];
            [locDic objectForKey:@"City"];
            [_tableView reloadData];
        }
    }];
    //停止定位
    [_locManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self showMessage:@"定位失败！"];
}

#pragma mark UserInfoCoreDelegate
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
@end
