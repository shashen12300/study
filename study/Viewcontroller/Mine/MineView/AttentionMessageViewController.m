//
//  AttentionMessageViewController.m
//  study
//
//  Created by mijibao on 16/2/23.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AttentionMessageViewController.h"
#import "AttentionMsgCollectionViewCell.h"
#import "XMPPManager.h"
#import "NewAttentionManager.h"

@interface AttentionMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

static NSString *_cellIdentifier = @"_cellIdentifier";

@implementation AttentionMessageViewController
{
    UITableView *_tableview;
    NSString *_relationship;//关系类型
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的粉丝";
    [self setRightBarButtonItemTitle:@"清空"];
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)creatUI{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height - 64)];
    _tableview.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_tableview registerClass:[AttentionMsgCollectionViewCell class] forCellReuseIdentifier:_cellIdentifier];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = YES;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.showsHorizontalScrollIndicator = NO;
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _attentionArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentionMsgCollectionViewCell *cell = (AttentionMsgCollectionViewCell *)[tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (cell == nil)
    {
        cell = [[AttentionMsgCollectionViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_cellIdentifier];
    }
    cell.nickNameLabel.text = _attentionArray[indexPath.row][@"fromid"];
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _attentionArray[indexPath.row][@"fromid"],[OperatePlist OpenFireServerAddress]]];
    NSData *imageData = [[[XMPPManager sharedManager] avatarModule] photoDataForJID:jid];
    NSString *string = [[XMPPManager sharedManager] vCardTempWithUserId:_attentionArray[indexPath.row][@"fromid"]].nickname;
    cell.nickNameLabel.text = string;
    if (imageData != nil) {
        cell.headView.image = [UIImage imageWithData:imageData];
    }else{
        [cell.headView setImage:[UIImage imageNamed:@"Mine_Syshead"]];
    }
    cell.attentionBtn.tag = indexPath.row;
    cell.timeLabel.text = _attentionArray[indexPath.row][@"date"];
//    cell.attentionBtn.userInteractionEnabled = YES;
    [cell.attentionBtn addTarget:self action:@selector(attentionBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)setRightBarButtonItemTitle:(NSString *)string{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(clearAttentionBtnClicked)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)clearAttentionBtnClicked{
    NSLog(@"清空关注信息");
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.attentionArray = [[NewAttentionManager shareInstance] getAllReadDataWithUserId:[UserInfoList loginUserId]];
    [_tableview reloadData];
}

- (void)attentionBtn:(UIButton *)btn{//点击关注按钮，请求关注接口，获取关系类型
    
    NSLog(@"点击了关注按钮,请求关注接口，获取到关系类型");
    //关注
    if ([_relationship isEqualToString:@"0"]) {//我关注此用户，发送xmpp添加好友请求
        
    }else if ([_relationship isEqualToString:@"1"]){//互相关注，接受xmpp好友添加请求
        
    }else{//信息错误
    }
    //取消关注
    if ([_relationship isEqualToString:@"2"]) {//我取消关注后，只剩对方关注我，通过xmpp执行删除好友操作
        
    }else if ([_relationship isEqualToString:@"3"]){//我取消关注后，成陌生人，不通过xmpp执行仍和操作
        
    }else{//信息错误
        
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
