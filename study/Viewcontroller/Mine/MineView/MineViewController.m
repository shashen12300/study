//
//  MineViewController.m
//  study
//
//  Created by mijibao on 15/9/2.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "ImageRequestCore.h"
#import "UserInfoViewController.h"
#import "MinePartnerViewController.h"
#import "CollectionViewController.h"
#import "AccountViewController.h"
#import "MineDocumentViewController.h"
#import "SettingsViewController.h"
#import "MineTeacherViewController.h"
#import "MineBuySubjectViewController.h"
#import "AttentionFromViewController.h"
#import "AttentionMessageViewController.h"
#import "NewAttentionManager.h"
#import "XMPPManager.h"

@interface MineViewController ()
{

}
@end

static NSString *_cellIdentifier = @"_cellIdentifier";

@implementation MineViewController
{
    NSArray *_tableTextArr;//表文本内容
    NSArray *_tableImageArr;//表图标名称
    UITableView *_mineTableView;//表视图
    NSNotificationCenter *_notificationCenter;//通知中心
    BOOL _attentionStatus;//有无关注通知
    NSArray *_newAttentionArray;
    NSString *_alertViewUserId;//关注提示框最新关注用户的id
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    //注册通知，用来接收新消息和好友请求
    _notificationCenter = [NSNotificationCenter defaultCenter];
    [_notificationCenter addObserver:self selector:@selector(getNewMessage:) name:kNewMessageNotification object:nil];
    [_notificationCenter addObserver:self selector:@selector(getAddMessage:) name:kaddMessageNotification object:nil];
    [self initData];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self readSqlMessageData];
    [_mineTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initData{
    _attentionStatus = NO;
    _tableTextArr = @[@"我的伙伴", @"我的收藏", @"我的账户", @"我的文件", @"我购买的课程", @"我上传的课件", @"我关注的人", @"关注我的人"];
    _tableImageArr = @[@"Mine_Partner", @"Mine_Collection", @"Mine_Account", @"Mine_Document", @"Mine_BuyCourse", @"Mine_Upload", @"Mine_AttentionTo", @"Mine_AttentionFrom"];
}

#pragma mark 创建UI
- (void)creatUI
{
    _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, Main_Width, Main_Height)style:UITableViewStyleGrouped];
    _mineTableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_mineTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    _mineTableView.delegate = self;
    _mineTableView.dataSource = self;
    _mineTableView.scrollEnabled = YES;
    _mineTableView.showsVerticalScrollIndicator = NO;
    _mineTableView.showsHorizontalScrollIndicator = NO;
    [_mineTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mineTableView];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = (MineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (cell == nil)
    {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_cellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.cellLabel.text = _tableTextArr[indexPath.row];
        UIImage *image = [UIImage imageNamed:_tableImageArr[indexPath.row]];
        cell.cellImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        [cell.cellImageView setImage:image];
        if (indexPath.row == _tableImageArr.count - 1) {
            [cell.lineView removeFromSuperview];
        }
    }else{
        cell.cellLabel.text = @"设置";
        UIImage *image = [UIImage imageNamed:@"Mine_Setting"];
        cell.cellImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        [cell.cellImageView setImage:image];
        [cell.lineView removeFromSuperview];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_tableTextArr count];
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (_attentionStatus) {
            return 255;
        }else{
            return 210;
        }
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        //膜玻璃
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
        effe.alpha = 0.5;
        effe.frame = CGRectMake(0, 0, Main_Width, 200);
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        //背景图
        UIImageView *headBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 200)];
        headBackView.backgroundColor = [UIColor clearColor];
        [headBackView addSubview:effe];
        UIImageView *headBottom = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Width - 84) * 0.5, 65, 84, 84)];
        headBottom.backgroundColor = UIColorFromRGB(0xff7949);
        headBottom.layer.masksToBounds = YES;
        headBottom.layer.cornerRadius = 42;
        if (!_attentionStatus) {
            headView.frame = CGRectMake(0, 0, Main_Width, 210);
        }else{
            headView.frame = CGRectMake(0, 0, Main_Width, 255);
            UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(( Main_Width - 150) * 0.5, MaxY(headBackView) + 10, 150, 35)];
            alertView.backgroundColor = [UIColor whiteColor];
            alertView.layer.cornerRadius = 8;
            UIImageView *alertImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2.5, 30, 30)];
            alertImage.layer.masksToBounds = YES;
            alertImage.layer.cornerRadius = 15;
            alertImage.backgroundColor = [UIColor yellowColor];
            [alertView addSubview:alertImage];
            XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _alertViewUserId,[OperatePlist OpenFireServerAddress]]];
            NSData *alertImageData = [[[XMPPManager sharedManager] avatarModule] photoDataForJID:jid];
            if (alertImageData != nil) {
                [alertImage setImage:[UIImage imageWithData:alertImageData]];
            }else{
                [alertImage setImage:[UIImage imageNamed:@"Mine_Syshead"]];
            }
//            [ImageRequestCore requestImageWithPath:[UserInfoList loginUserPhoto] withImageView:alertImage placeholderImage:[UIImage imageNamed:@"Mine_Syshead"]];
            UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(alertImage) + 5, 2.5, 100, 30)];
            alertLabel.text = [NSString stringWithFormat:@"您有%lu条新的关注", (unsigned long)_newAttentionArray.count];
            alertLabel.textColor = UIColorFromRGB(0xff6949);
            alertLabel.font = [UIFont systemFontOfSize:12];
            alertLabel.textAlignment = NSTextAlignmentLeft;
            [alertView addSubview:alertLabel];
            alertView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redAttentionMessage)];
            [alertView addGestureRecognizer:tap];
            [headView addSubview:alertView];
        }
        //我的头像
        UIImageView *userHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 80, 80)];
        userHeadView.backgroundColor = [UIColor clearColor];
        userHeadView.layer.masksToBounds = YES;
        userHeadView.layer.cornerRadius = 41;
        [headBackView addSubview:headBottom];
        [headBottom addSubview:userHeadView];
        [ImageRequestCore requestImageWithPath:[UserInfoList loginUserPhoto] withImageView:userHeadView placeholderImage:[UIImage imageNamed:@"Mine_Syshead"]];
        [ImageRequestCore requestImageWithPath:[UserInfoList loginUserPicture] withImageView:headBackView placeholderImage:[UIImage imageNamed:@"partner_ default"]];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeadImage)];
        headView.userInteractionEnabled = YES;
        headBackView.userInteractionEnabled = YES;
        headBottom.userInteractionEnabled = YES;
        userHeadView.userInteractionEnabled = YES;
        [userHeadView addGestureRecognizer:gesture];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(headBottom) + 10, Main_Width, 20)];
        nameLabel.text = [UserInfoList loginUserNickname];
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.layer.shadowOpacity = 1.0;
        nameLabel.layer.shadowRadius = 0.0;
        nameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        nameLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        [headBackView addSubview:nameLabel];
        [headView addSubview:headBackView];
        return headView;
    }else{
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 10)];
        headView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        return headView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//点击的是我的伙伴
            MinePartnerViewController *partner = [[MinePartnerViewController alloc] init];
            [self.navigationController pushViewController:partner animated:YES];
        }else if(indexPath.row == 1){//点击的是我的收藏
            CollectionViewController *collection = [[CollectionViewController alloc] init];
            [self.navigationController pushViewController:collection animated:YES];
        }else if (indexPath.row == 2){//点击的是我的账户
            AccountViewController *account = [[AccountViewController alloc] init];
            [self.navigationController pushViewController:account animated:YES];
        }else if (indexPath.row == 3){//点击的我的文件
            MineDocumentViewController *document = [[MineDocumentViewController alloc] init];
            [self.navigationController pushViewController:document animated:YES];
        }else if (indexPath.row == 4){//点击的是我购买的课程
            MineBuySubjectViewController *subject = [[MineBuySubjectViewController alloc] init];
            [self.navigationController pushViewController:subject animated:YES];
        }else if (indexPath.row == 5){//点击的是我上传的课件
        }else if (indexPath.row == 6){//点击的是我关注的人
            MineTeacherViewController *teacher = [[MineTeacherViewController alloc] init];
            [self.navigationController pushViewController:teacher animated:YES];
        }else{//点击的是关注我的人
            AttentionFromViewController *attenion = [[AttentionFromViewController alloc] init];
            [self.navigationController pushViewController:attenion animated:YES];
        }
    }else if (indexPath.section == 1){//点击的是设置
        SettingsViewController *settings = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:settings animated:YES];
    }
}

#pragma mark 点击用户头像
- (void)tapUserHeadImage{
    NSLog(@"点击用户头像");
    UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
}

#pragma mark 新消息通知
- (void)getNewMessage:(NSNotification *)notification{
    
}

#pragma mark 新关注通知
- (void)getAddMessage:(NSNotification *)notification{
    self.presenceFromUser = notification.userInfo[@"presenceFromUser"];
    _attentionStatus = YES;
    [self readSqlMessageData];
}

#pragma mark 点击新关注提示框
- (void)redAttentionMessage{
    NSLog(@"点击了新消息提示框");
    [[NewAttentionManager shareInstance] upDataReadResultWithUserId:[UserInfoList loginUserId] isRead:@"1"];
    AttentionMessageViewController *attentionMsg = [[AttentionMessageViewController alloc] init];
    [self.navigationController pushViewController:attentionMsg animated:YES];
}

#pragma mark 读取数据库数据
- (void)readSqlMessageData{
    _newAttentionArray = [[NSArray alloc] init];
    _newAttentionArray = [[NewAttentionManager shareInstance] getUnReadDataWithUserId:[UserInfoList loginUserId]];
    if (_newAttentionArray.count >= 1) {
        _attentionStatus = YES;
    }else{
        _attentionStatus = NO;
    }
    _alertViewUserId = _newAttentionArray.firstObject[@"fromid"];
    [_mineTableView reloadData];
}
@end


