//
//  SeletPlaceViewController.m
//  study
//
//  Created by mijibao on 15/8/29.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "SeletPlaceViewController.h"
#import "PlaceTableViewCell.h"
#import <BaiduMapAPI/BMapKit.h>

@interface SeletPlaceViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKPoiSearchDelegate, CLLocationManagerDelegate>
{
    BMKLocationService  *_locationService;
    
    BMKPointAnnotation  *_pointAnnotation;
    BMKGeoCodeSearch *_geocodeSearch;//地理编码检索对象
    BMKReverseGeoCodeOption *_reverseGeoCodeSearchOption;
    
    //tableView的数据源
    NSMutableArray *_dataArray;
    
    //经纬度
    CLLocationCoordinate2D _coodinate;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SeletPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNavigationTitle:@"我的位置"];
    [self setBackBarButtonItemTitle:@""];
    
    [self loadBaiduMap];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _locationService.delegate = nil;
    _geocodeSearch.delegate = nil;
}
//将要出现的时候
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _locationService.delegate = self;
    _geocodeSearch.delegate = self;
}

- (void)loadBaiduMap {
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    //启动LocationService
    [_locationService startUserLocationService];
    
    _geocodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geocodeSearch.delegate = self;
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    _pointAnnotation.title = @"当前位置";
    
    //调用反向地理编码
    [self initReverseGeoCode:coor];
}
#pragma mark - 发起反向编码
- (void)initReverseGeoCode:(CLLocationCoordinate2D)coordinate {
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){coordinate.latitude, coordinate.longitude};
    
    if (_reverseGeoCodeSearchOption == nil) {
        _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    
    _reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
    
    if (flag){
        NSLog(@"反geo检索发送成功");
    }else
        NSLog(@"反geo检索发送失败");
}

#pragma mark - 接受反向编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在这里处理正常的结果
        [_dataArray removeAllObjects];
        _dataArray = [NSMutableArray arrayWithArray:result.poiList];
        
        [self.tableView reloadData];
    }else{
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *PlaceCancleCell = @"PlaceCancleCellIdentifier";
        PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceCancleCell];
        if (cell == nil) {
            cell = [[PlaceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaceCancleCell];
        }
        
        return cell;
    }
    
    static NSString *PlaceCell = @"PlaceCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaceCell];
    }
    
    BMKPoiInfo *info = _dataArray[indexPath.row - 1];
    cell.textLabel.text = info.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return widget_width(80);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(110))];
    view.backgroundColor = UIColorFromRGB(0xe2e2e2);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(widget_width(20), widget_height(20), Main_Width - widget_width(20)*2, widget_height(70))];
    textField.placeholder = @"填写地点";
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = UIColorFromRGB(0xffffff);
    [view addSubview:textField];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return widget_width(110);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(2))];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return widget_width(2);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    BMKPoiInfo *info = _dataArray[indexPath.row - 1];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:info.name,@"name", nil];
    
    if ([self.delegate respondsToSelector:@selector(selectPlace:)]) {
        [self.delegate selectPlace:dic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
