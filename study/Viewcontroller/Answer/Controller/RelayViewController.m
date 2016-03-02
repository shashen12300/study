//
//  RelayViewController.m
//  study
//
//  Created by jzkj on 16/2/3.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "RelayViewController.h"
#import <Masonry/Masonry.h>
#import "MyCustomView.h"
#import "CInputView.h"
#import "ChatMsgDTO.h"
#import "JHFacePlist.h"
#import "ChatMsgListManage.h"
#import "MsgSummaryManage.h"
#import "RelayMessageCell.h"
#import "UploadFileCore.h"
#import "JHAudioManager.h"
#import "JHCacheManager.h"
#import "HJAlertView.h"
#import "ReviewImageView.h"
#import "VideoPlayViewController.h"
#import "MJRefresh.h"
#define maxChatWidth 200
#define maximgWidth 113
#define maximgHeight 120
#define vedioimgWidth 110
#define vedioimgHeight 120
@interface RelayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//聊天数据
@property (nonatomic, strong) NSMutableArray *selecteArr;//选中数据

@end

@implementation RelayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selecteArr = [@[] mutableCopy];
    // Do any additional setup after loading the view.
    self.userId = [UserInfoList loginUserPhone];
    //消息列表
    self.dataArray = [[ChatMsgListManage shareInstance]readChatMsgList:self.chatId :self.userId :0 :0];
    [self layoutNavigation];
    [self layoutTableView];
    // Do any additional setup after loading the view.
    if (self.dataArray.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)layoutNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publemLeftBar"] style:UIBarButtonItemStylePlain target:self action:@selector(backTolistView)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"问题详情";
}
- (void)layoutTableView{
    __weak __typeof(self) weakSelf = self;
    self.chatTableView = [[UITableView alloc] init];
    [self.view addSubview:self.chatTableView];
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.backgroundColor = RGBCOLOR(226, 226, 226);
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.chatTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSMutableArray *arr = [[ChatMsgListManage shareInstance]readChatMsgList:self.chatId :self.userId :0 :self.dataArray.count];
        if (arr.count > 0) {
            [self.dataArray insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)]];
            [_chatTableView reloadData];
        }
        if (arr.count > 9) {
            //偏移到刷新之前的cell
            [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        [_chatTableView.mj_header endRefreshing];
    }];
    //转发
    UIButton *transmit = [UIButton buttonWithType:UIButtonTypeCustom];
    transmit.backgroundColor = RGBCOLOR(246, 246, 246);
    transmit.backgroundColor = [UIColor whiteColor];
//    [transmit addTarget:self action:@selector(transmitQuestionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transmit];
    [transmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.view);
        make.height.equalTo(@40);
        make.width.equalTo(@(Main_Width / 2));
    }];
    UIImageView *transmitImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msgTransmit"]];
    [self.view addSubview:transmitImage];
    [transmitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(transmit);
        make.width.equalTo(@32);
        make.height.equalTo(@22);
    }];
    
    //删除
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor whiteColor];
    [deleteBtn addTarget:self action:@selector(deleteQuestionBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(transmit.mas_right);
        make.height.equalTo(@40);
        make.width.equalTo(@(Main_Width / 2));
    }];
    UIImageView *deletImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msgDelete"]];
    [self.view addSubview:deletImage];
    [deletImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(deleteBtn);
        make.width.equalTo(@23);
        make.height.equalTo(@22);
    }];
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(Main_Width/2, 3, 1, 34)];
    lineview.backgroundColor = RGBCOLOR(216, 216, 216);
    [self.view addSubview:lineview];
}
#pragma mark - tabel代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //查询消息发送状态
    ChatMsgDTO *msgDto = (ChatMsgDTO *)[self.dataArray objectAtIndex:indexPath.row];
    
    //3分钟内不显示时间
    BOOL isShowTime = YES;
    if(indexPath.row > 0){
        NSDate *nowMsgDate = [JZCommon stringToDate:msgDto.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        //获取上一条消息的时间
        NSDate *cellLastTime = [JZCommon stringToDate:((ChatMsgDTO *)[self.dataArray objectAtIndex:indexPath.row-1]).sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSTimeInterval cha= [ JZCommon timeDifference:cellLastTime :nowMsgDate];
        if(cha / 60 <= 3){
            isShowTime = NO;
        }
    }
    
    BOOL isShowName = NO;
    static NSString *cllID = @"chatCllID";
    RelayMessageCell *cell = (RelayMessageCell *)[tableView dequeueReusableCellWithIdentifier:cllID];
    if (!cell){
        cell = [[RelayMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cllID];
    }
    cell.isShowTime = isShowTime;
    //    cell.emojiDic=emojiDic;
    cell.msgDto = msgDto;
    cell.isShowName = isShowName;
    //cell布局并赋值
    [cell initcellView];
    cell.chatMsgBg.tag = indexPath.row;
    cell.tag = 40000 + indexPath.row;
    
    if(msgDto.success == 3)
    {
        //断网显示红点
        Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        if ([r currentReachabilityStatus] == NotReachable) {
            msgDto.success = 0;
        }
        //有网判断时间超过3分钟判定为失败
        else
        {
            NSDate *date=[JZCommon stringToDate:msgDto.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
            NSString * mm = [JZCommon dateToString:date format:@"mm"];
            NSString * HH = [JZCommon dateToString:date format:@"HH"];
            NSString * mm1 = [JZCommon dateToString:[NSDate date] format:@"mm"];
            NSString * HH1 = [JZCommon dateToString:[NSDate date] format:@"HH"];
            if (![HH1 isEqualToString:HH]) {
                msgDto.success = 0;
            }
            else if(([mm1 intValue]-[mm intValue])>3)
            {
                msgDto.success = 0;
            }
        }
    }
    
    if(msgDto.filetype==3){
        CGFloat width=cell.videoImageView.frame.size.width - 7 ;
        CGFloat height=cell.videoImageView.frame.size.height;
        CGFloat labelx = 0;
        if (msgDto.sendtype == 1) {
            labelx = 7;
        }
        UILabel *bottomLabel=[MyCustomView creatLabelWithFrame:CGRectMake(labelx, height-15, width, 20) text:nil alignment:NSTextAlignmentRight];
        bottomLabel.backgroundColor=[UIColor lightGrayColor];
        bottomLabel.alpha=0.8;
        UILabel *sizeLabel=[MyCustomView creatLabelWithFrame:CGRectMake(labelx, height-15, width, 20) text:nil alignment:NSTextAlignmentLeft];
        UILabel *longLabel=[MyCustomView creatLabelWithFrame:CGRectMake(labelx, height-15, width, 20) text:nil alignment:NSTextAlignmentRight];
        sizeLabel.font=[UIFont systemFontOfSize:11];
        longLabel.font=[UIFont systemFontOfSize:11];
        if(msgDto.duration!=nil){
            longLabel.text=[NSString stringWithFormat:@"%02d:%02d",[msgDto.duration intValue]/60,[msgDto.duration intValue]%60];
            longLabel.textColor=[UIColor whiteColor];
        }
        if(msgDto.duration!=nil){
            sizeLabel.text = msgDto.totalsize;
            sizeLabel.textColor=[UIColor whiteColor];
        }
        
        [cell.videoImageView addSubview:bottomLabel];
        [cell.videoImageView addSubview:sizeLabel];
        [cell.videoImageView addSubview:longLabel];
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled=YES;
    cell.contentView.backgroundColor = RGBCOLOR(226, 226, 226);
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //查询消息发送状态
    ChatMsgDTO *msgDto=(ChatMsgDTO *)[self.dataArray objectAtIndex:indexPath.row];
    
    //3分钟内不显示时间
    BOOL isShowTime=YES;
    if(indexPath.row>0){
        NSDate *nowMsgDate=[JZCommon stringToDate:msgDto.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        //获取上一条消息的时间
        NSDate *cellLastTime=[JZCommon stringToDate:((ChatMsgDTO *)[self.dataArray objectAtIndex:indexPath.row-1]).sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSTimeInterval cha=[JZCommon timeDifference:cellLastTime :nowMsgDate];
        if(cha/60<=3){
            isShowTime=NO;
        }
    }
    BOOL isShowName=NO;
    
    CGFloat height=0;
    
    switch (msgDto.filetype) {
            //通知
        case 99:{
            CGSize msgSize = [JZCommon getTextSize:msgDto.content textFont:14 textMaxWidth:300];
            height= msgSize.height-20;
            break;
        }
            //文本
        case 0:{
            height = [[RelayMessageCell new] heightForMessageContent:msgDto.content].height;
            break;
        }
            //语音
        case 1:
            height=20;
            break;
            //图片
        case 2:{
            CGSize maxSize = {maximgWidth,maximgHeight};
            UIImage * cacheImg = [UIImage imageWithContentsOfFile:msgDto.localpath];
            if (!cacheImg) {
                cacheImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[JZCommon getFileDownloadPath:msgDto.url]];
            }
            CGSize imageSize=cacheImg.size;
            CGSize imgSize = [JZCommon imgScaleSize:imageSize :maxSize];
            height = imgSize.height-15;
            break;
        }
            //视频
        case 3:
            height = vedioimgHeight+15;
            break;
        default:
            height = 20;
            break;
            
    }
    if(isShowTime){
        height=height+65;
    }else{
        height=height+40;
    }
    if (isShowName) {
        height=height+20;
    }
    return height;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    RelayMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.msgDto.isSelect = !cell.msgDto.isSelect;
    [cell changeCellSelectState];
    if (cell.msgDto.isSelect) {
        [self.selecteArr addObject:cell.msgDto];
    }else{
        [self.selecteArr removeObject:cell.msgDto];
    }
}
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark - 删除转发
- (void)deleteQuestionBtn{
    for (ChatMsgDTO *msg in self.selecteArr) {
        [[ChatMsgListManage shareInstance] deleteChatMsg:msg];
        NSInteger index = [self.dataArray indexOfObject:msg];
        [self.dataArray removeObject:msg];
        [self.chatTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    self.deleteMessageBlock();
    return;
}


#pragma mark -跳转操作
- (void)backTolistView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
