//
//  SettingsViewController.m
//  study
//
//  Created by mijibao on 16/2/1.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserInfoManager.h"
#import "CollectionManager.h"
#import "MinePartnerManager.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@end

static NSString *_cellIdentifier = @"cellIdentifier";

@implementation SettingsViewController
{
    UITableView *_tableView;
    NSArray *_signArray;
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

- (void)creatNavgation
{
    self.title = @"设置";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatUI{
    _signArray = @[@"消息推送", @"意见反馈", @"关于我们", @"打赏好评"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, Main_Width, 160)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.scrollEnabled = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];
    
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MaxY(_tableView) + 10, Main_Width, 40)];
    [self setBtnStatus:exitBtn WithBackColor:[UIColor whiteColor] withTitle:@"退出登录" withTitleColor:UIColorFromRGB(0xff6949) withFont:13];
    [exitBtn addTarget:self action:@selector(exitSystem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
    if (indexPath.row == 0) {
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(Main_Width - 60, 5, 30, 15)];
        switchBtn.transform = CGAffineTransformMakeScale(0.75, 0.75);
        [switchBtn setOn:YES];
        [switchBtn addTarget:self action:@selector(swichAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchBtn];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{//点击的是收支明细
        
        }
            break;
        case 1:{//点击的是我的余额
           
        }
            break;
        case 2:{//点击的是充值
           
        }
            break;
        case 3:{//点击的是提现
           
        }
            break;
        default:
            break;
    }
}

- (void)exitSystem
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出应用吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


- (void)setBtnStatus:(UIButton *)btn WithBackColor:(UIColor *)backcolor withTitle:(NSString *)title withTitleColor:(UIColor *)titlecolor withFont:(NSInteger)fontsize
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:backcolor];
    [btn setTitleFont:[UIFont systemFontOfSize:fontsize]];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了取消按钮");
    }else{//确认退出
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //清除数据
        [defaults setObject:nil forKey:[AccountManeger loginUserAge]];
        [defaults setObject:nil forKey:[AccountManeger loginUserCity]];
        [defaults setObject:nil forKey:[AccountManeger loginUserGender]];
        [defaults setObject:nil forKey:[AccountManeger loginUserGrade]];
        [defaults setObject:nil forKey:[AccountManeger loginUserId]];
        [defaults setObject:nil forKey:[AccountManeger loginUserNickname]];
        [defaults setObject:nil forKey:[AccountManeger loginUserPassword]];
        [defaults setObject:nil forKey:[AccountManeger loginUserPhone]];
        [defaults setObject:nil forKey:[AccountManeger loginUserPhoto]];
        [defaults setObject:nil forKey:[AccountManeger loginUserPicture]];
        [defaults setObject:nil forKey:[AccountManeger loginUserProvince]];
        [defaults setObject:nil forKey:[AccountManeger loginUserSignature]];
        [defaults setObject:nil forKey:[AccountManeger loginUserSchool]];
        [defaults setObject:nil forKey:[AccountManeger loginUserSubject]];
        [defaults setObject:nil forKey:[AccountManeger loginUserHonors]];
        [defaults setBool:NO forKey:[AccountManeger loginSfStatus]];
        [defaults setObject:nil forKey:[AccountManeger loginSftype]];
        //清空数据库
//        [self clearDocumentData];
        [defaults setBool:NO forKey:[AccountManeger loginStatus]];
        [[NSNotificationCenter defaultCenter]postNotificationName:KChangeRootView object:nil userInfo:nil];
    }
}

- (void)clearDocumentData
{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"study.sqlite"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:dbPath];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:dbPath error:&err];
    }
}

- (void)swichAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    if ([switchButton isOn]) {
        NSLog(@"开启消息推送");
    }else{
        NSLog(@"关闭消息推送");
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
