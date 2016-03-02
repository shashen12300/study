//
//  PartnerInfoViewController.m
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PartnerInfoViewController.h"
#import "ImageRequestCore.h"
#import "UserInfoManager.h"
#import "MinePartnerCore.h"
#import "PartnerInfoOneTableViewCell.h"
#import "XMPPManager.h"

@interface PartnerInfoViewController ()<UITextViewDelegate, MinePartnerCoreDelegate>

@end

static NSString *_sectionIdentifier = @"_sectionIdentifier";

@implementation PartnerInfoViewController
{
    UITableView *_tableView;
    NSArray *_signArray;
    NSMutableArray *_userInfoArray;
    NSMutableDictionary *_userInfoDic;
    NSString *_honors;
    NSIndexPath *_indexPath;
    NSArray *_sectionOneArray;
    NSArray *_photoUrlArray;
    NSArray *_videoUrlArray;
    NSArray *_choseArray;
    NSArray *_answerArray;
    CGFloat _headViewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情信息";
    _userInfoArray = [[UserInfoManager shareInstance] gainDataArrayWithUserId:self.partnerId];
    [self initTabelViewData];
    if (!_userInfoDic[@"id"]) {
        _tableView.hidden = YES;
        [self creatHudWithText:@"加载中..."];
    }
    [self creatUI];
    [self getUserInfomation];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [UIColorFromRGB(0xffffff) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.shadowImage = pressedColorImg;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.clipsToBounds = YES;   // 去掉黑线方法
}

- (void)creatUI{
    //个人动态
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height)style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    [_tableView registerClass:[PartnerInfoOneTableViewCell class] forCellReuseIdentifier:_sectionIdentifier];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 + _choseArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PartnerInfoOneTableViewCell *cell = (PartnerInfoOneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_sectionIdentifier];
    if (cell == nil)
    {
        cell = [[PartnerInfoOneTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_sectionIdentifier];
    }
    if (indexPath.section == 0) {
        [cell drawLabelFrame:_signArray[indexPath.row] cellHeight:widget_height(70) contentHeight:[self getTextHeigh:_sectionOneArray[indexPath.row]]];
        if (indexPath.row <= 1) {
            [cell.contentText removeFromSuperview];
            cell.contentLabel.text = _sectionOneArray[indexPath.row];
        }else{
            [cell.contentLabel removeFromSuperview];
            cell.contentText.attributedText = [[NSAttributedString alloc] initWithString:[self saveInfomation:_sectionOneArray[indexPath.row]] attributes:[self setTextSpcacing]];
            cell.contentText.delegate = self;
            cell.contentText.textColor = UIColorFromRGB(0x8e8e8e);
        }
        [cell.collection removeFromSuperview];
         cell.signLabel.text = _signArray[indexPath.row];
    }else if (indexPath.section == 1 || indexPath.section == 2){
        [cell.contentLabel removeFromSuperview];
        [cell.contentText removeFromSuperview];
        [cell drawLabelFrame:_signArray[indexPath.section + 2] cellHeight:widget_height(126) contentHeight:[self getTextHeigh:_sectionOneArray[indexPath.row]]];
        cell.signLabel.text = _signArray[indexPath.section + 2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 1) {
            [cell reloadDataofCollectionView:_photoUrlArray];
        }else{
            [cell reloadDataofCollectionView:_videoUrlArray];
        }
    }else{
        [cell.contentLabel removeFromSuperview];
        [cell.contentText removeFromSuperview];
        [cell.collection removeFromSuperview];
        [cell.signLabel removeFromSuperview];
        [cell drawSignLabelFrame];
        cell.signLabel.text = _choseArray[indexPath.row];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2)
        {
           return [self getTextHeigh:_sectionOneArray[2]];
        }else{
            return widget_height(70);
        }
    }else if(indexPath.section == 1|| indexPath.section == 2){
        return widget_height(126);
    }else{
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return _headViewHeight;
    }else{
        return widget_height(20);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, _headViewHeight)];
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_height(460))];
        [ImageRequestCore requestImageWithPath:[self saveInfomation:_userInfoDic[@"picture"]] withImageView:backImageView placeholderImage:[UIImage imageNamed:@"partner_ default"]];
        [headView addSubview:backImageView];
        //头像及背景图
        UIView *headBottom = [[UIView alloc] initWithFrame:CGRectMake((Main_Width - widget_width(168)) * 0.5, 71, widget_height(168), widget_height(168))];
        headBottom.layer.masksToBounds = YES;
        headBottom.layer.cornerRadius = widget_height(168)/2;
        headBottom.backgroundColor = UIColorFromRGB(0xff7f00);
        [backImageView addSubview:headBottom];
        UIImageView *userHead = [[UIImageView alloc] initWithFrame:CGRectMake(widget_height(4), widget_height(4), widget_height(160), widget_height(160))];
        userHead.layer.masksToBounds = YES;
        userHead.layer.cornerRadius = widget_height(160)/2;
        userHead.backgroundColor = [UIColor clearColor];
        [ImageRequestCore requestImageWithPath:[self saveInfomation:_userInfoDic[@"photo"]] withImageView:userHead placeholderImage:[UIImage imageNamed: @"Mine_Syshead"]];
        [headBottom addSubview:userHead];
        //昵称
        UILabel *nicknemeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, MaxY(headBottom) + widget_height(26), Main_Width, 18)];
        nicknemeLabel.font = [UIFont boldSystemFontOfSize:16];
        nicknemeLabel.textColor = [UIColor whiteColor];
        nicknemeLabel.textAlignment = NSTextAlignmentCenter;
        nicknemeLabel.layer.shadowOpacity = 1.0;
        nicknemeLabel.layer.shadowRadius = 0.0;
        nicknemeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        nicknemeLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        nicknemeLabel.text = [self saveInfomation:_userInfoDic[@"nickname"]];
        [headView addSubview:nicknemeLabel];
        if ([self.partnerType isEqualToString:@"T"]) {
            //教龄
            UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(nicknemeLabel), Main_Width, 16)];
            ageLabel.font = [UIFont boldSystemFontOfSize:12];
            ageLabel.textColor = [UIColor whiteColor];
            ageLabel.textAlignment = NSTextAlignmentCenter;
            ageLabel.layer.shadowOpacity = 1.0;
            ageLabel.layer.shadowRadius = 0.0;
            ageLabel.layer.shadowColor = [UIColor blackColor].CGColor;
            ageLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            ageLabel.text = [NSString stringWithFormat:@"教龄：%@", [self saveInfomation:_userInfoDic[@"age"]]];
            [headView addSubview:ageLabel];
            for (int i = 0; i < 2; i ++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * ( Main_Width * 0.5 + 0.5), MaxY(backImageView), Main_Width * 0.5 - 0.5, widget_height(80))];
                label.text = _answerArray[i];
                label.backgroundColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                [headView addSubview:label];
            }
        }
        return headView;
    }else{
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_height(20))];
        return headView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSLog(@"点击了个人动态");
    }else if (indexPath.section == 2){
        NSLog(@"点击了教学课程");
    }else if (indexPath.section == 3){
        if ([_userInfoDic[@"isfriend"] isEqualToString:@"Y"])
        {//xmpp添加好友
            [[XMPPManager sharedManager] XMPPAddFriendSubscribe:_userInfoDic[@"phone"] nickName:_userInfoDic[@"nickname"]];
        }else{
            NSLog(@"点击的是添加伙伴");
        }
    }else if (indexPath.section == 4){
        if ([_userInfoDic[@"isattention"] isEqualToString:@"Y"])
        {
            NSLog(@"点击的是取消关注");
        }else{
            NSLog(@"点击的是关注老师");
        }
    }else if (indexPath.section == 5){
        NSLog(@"点击的是我要提问");
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

#pragma mark 网络请求
- (void)getUserInfomation{
    NSString *anotherId = [NSString stringWithFormat:@"%ld", (long)_partnerId];
    MinePartnerCore *core = [[MinePartnerCore alloc] init];
    core.delegate = self;
    [core requestUseInfomationWithMineId:[UserInfoList loginUserId] anotherId:anotherId];
}

#pragma mark 网络请求回调
- (void)passRequstResult:(BOOL)result infomation:(NSMutableArray *)array
{
    [self stopHud];
    if (!result) {
        [self showMessage:@"获取信息失败！"];
    }else{
        _userInfoArray = array;
        _honors = _userInfoArray[0][@"honors"];
        [self initTabelViewData];
        [_tableView reloadData];
    }
}

#pragma mark 获取荣誉列的高度
- (CGFloat)getTextHeigh:(NSString *)string
{
    CGFloat height;
    if (string && string.length != 0) {
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGSize honorSize = [string sizeWithAttributes:dic];
        CGFloat t = honorSize.width / (Main_Width -  widget_width(280));
        NSInteger num = floor(t);
        if (num >= 3) {
            height = 80;
        }else{
            height = (num + 1) * 33;
        }
    }else{
        height = widget_height(70);
    }
    return height;
}

- (NSString *)saveInfomation:(id)saveObjec
{
    NSString *saveString = (saveObjec == [NSNull null] || saveObjec == nil) ? @"" : saveObjec;
    return saveString;
}

#pragma mark 限定TextView的行间距
- (NSDictionary *)setTextSpcacing{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSString *string = @"地区：";
    CGSize size = [string sizeWithAttributes:dic];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = (33 - size.height) * 0.5;//行间距
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:13], NSParagraphStyleAttributeName:paragraphStyle};
    return attributes;
}

- (void)initTabelViewData
{
    _userInfoDic = _userInfoArray[0];
    _videoUrlArray = @[[self saveInfomation:_userInfoDic[@"video1"]],[self saveInfomation:_userInfoDic[@"video2"]],[self saveInfomation:_userInfoDic[@"video3"]],[self saveInfomation:_userInfoDic[@"video4"]]];
    _photoUrlArray = @[[self saveInfomation:_userInfoDic[@"photourl1"]], [self saveInfomation:_userInfoDic[@"photourl2"]], [self saveInfomation:_userInfoDic[@"photourl3"]],[self saveInfomation:_userInfoDic[@"photourl4"]]];
    if ([self.partnerType isEqualToString:@"T"]) {
        if ([_userInfoDic[@"isfriend"] isEqualToString:@"Y"]) {
            _choseArray = @[@"发送消息"];
        }else{
            _choseArray = @[@"加为伙伴"];
        }
        _answerArray = @[[NSString stringWithFormat:@"好评率：%@", [self saveInfomation:_userInfoDic[@"rate"]]], [NSString stringWithFormat:@"答题数：%@", [self saveInfomation:_userInfoDic[@"instantanswerCount"]]]];
        _headViewHeight = widget_height(540);
        _signArray = @[@"地区：", @"擅长科目：", @"所获荣誉：", @"个人发布：", @"教学课件："];
        _sectionOneArray = @[[NSString stringWithFormat:@"%@ %@", [self saveInfomation:_userInfoDic[@"province"]],[self saveInfomation:_userInfoDic[@"city"]]], [self saveInfomation:_userInfoDic[@"subject"]], [self saveInfomation:_honors] ];
    }else{
        if ([_userInfoDic[@"isfriend"] isEqualToString:@"Y"]) {
            _choseArray = @[@"发送消息"];
        }else{
            if ([_userInfoDic[@"isattention"] isEqualToString:@"Y"]){
                _choseArray = @[@"加为伙伴", @"取消关注", @"我要提问"];
            }else{
                _choseArray = @[@"加为伙伴", @"关注老师", @"我要提问"];
            }
        }
        _headViewHeight = widget_height(460);
        _signArray = @[@"地区：", @"年级：", @"个性签名：", @"个人发布：", @"教学课件："];
        _sectionOneArray = @[[NSString stringWithFormat:@"%@ %@", [self saveInfomation:_userInfoDic[@"province"]],[self saveInfomation:_userInfoDic[@"city"]]], [self saveInfomation:_userInfoDic[@"grade"]], [self saveInfomation:_userInfoDic[@"signature"]]];
    }
}
@end
