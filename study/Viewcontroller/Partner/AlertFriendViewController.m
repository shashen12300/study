//
//  AlertFriendViewController.m
//  study
//
//  Created by yang on 16/1/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AlertFriendViewController.h"
#import "AlertFriendTableViewCell.h"
#import "PartnerCore.h"
#import "JZAddressBookHelper.h"
#import "PartnerFriendIndoModel.h"
#import <AddressBookUI/AddressBookUI.h>

@interface AlertFriendViewController () <UITableViewDataSource, UITableViewDelegate, PartnerCoreDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;     // 所有数据
@property (nonatomic, strong) NSMutableArray *logArray;      // 记录选择状态数组
@property (nonatomic, strong) NSMutableArray *initialArray;  // 首字母
@property (nonatomic, strong) UITableView    *tableView;

@end

@implementation AlertFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusRestricted || status == kABAuthorizationStatusDenied) {
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在“设置-隐私-通讯录”选项中允许访问你的通讯录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    self.dataArray = [NSMutableArray new];
    self.initialArray = [NSMutableArray new];
    
    PartnerCore *core = [[PartnerCore alloc] init];
    core.delegate = self;
    [core gainFriendsInfoWithPhone:[[UserInfoList loginUserPhone] integerValue] userId:[[UserInfoList loginUserId] integerValue]];
    
    [self setupNav];
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfoArray:(NSArray *)infoArray {
    _infoArray = infoArray;
    
    self.logArray = [NSMutableArray arrayWithArray:infoArray];
}

#pragma mark - inner methods
- (void)setupSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)setupNav {
    [self setNavigationTitle:@"提醒朋友"];
    self.navigationItem.leftBarButtonItem = [self addItemWithTitle:@"取消" titleColor:UIColorFromRGB(0xffffff) target:self action:@selector(popToPresentationController)];
    self.navigationItem.rightBarButtonItem = [self addItemWithTitle:@"确定" titleColor:UIColorFromRGB(0xff7949) target:self action:@selector(sure)];
}

- (void)popToPresentationController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure {
    NSMutableArray *resultArr = [NSMutableArray new];
    
    for (int i = 0; i < self.logArray.count; i++) {
        NSArray *arr = self.logArray[i];
        for (int j = 0; j < arr.count; j++) {
            if ([arr[j] integerValue] == 1) {
                [resultArr addObject:self.dataArray[i][j]];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(alertFriendWithDataArray:logArray:)]) {
        [self.delegate alertFriendWithDataArray:resultArr logArray:(NSArray *)self.logArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PartnerCoreDelegate
- (void)gainFriendsArray:(NSArray *)array {
    NSDictionary *dic = (NSMutableDictionary *)[[JZAddressBookHelper new] classifyContacts:array];
    
    self.initialArray = (NSMutableArray *)[dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    
    for (int i = 0; i < self.initialArray.count; i++) {
        [self.dataArray addObject:dic[self.initialArray[i]]];
    }
    
    if (self.logArray.count == 0) {
        for (int i = 0; i < self.dataArray.count; i++) {
            NSMutableArray *arr = [NSMutableArray new];
            for (int j = 0; j < [self.dataArray[i] count]; j++) {
                [arr addObject:@"0"];
            }
            [self.logArray addObject:arr];
        }
    }
    
    [self.tableView reloadData];
}

#define mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.initialArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *alertFriend = @"AlertFriendTableViewCell";
    AlertFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:alertFriend];
    if (cell == nil) {
        cell = [[AlertFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:alertFriend];
    }
    
    NSArray *contacts = self.dataArray[indexPath.section];
    PartnerFriendIndoModel *model = contacts[indexPath.row];
    cell.model = model;
    
    if ([self.logArray[indexPath.section][indexPath.row] integerValue] == 0) {
        cell.selectedImage.hidden = YES;
    }else
        cell.selectedImage.hidden = NO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return widget_width(114);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = self.logArray[indexPath.section];
    if ([array[indexPath.row] integerValue] == 0) {
        [array replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [self.logArray replaceObjectAtIndex:indexPath.section withObject:array];
    }else {
        [array replaceObjectAtIndex:indexPath.row withObject:@"0"];
        [self.logArray replaceObjectAtIndex:indexPath.section withObject:array];
    }
    
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(30))];
    view.backgroundColor = UIColorFromRGB(0xe2e2e2);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(widget_width(20), 0, widget_width(100), widget_width(30))];
    [view addSubview:label];
    label.text = self.initialArray[section];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return widget_width(30);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(2))];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return widget_width(2);
}

@end
