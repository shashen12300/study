//
//  ProblemDetailViewController.m
//  study
//
//  Created by jzkj on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "ProblemDetailViewController.h"
#import <Masonry/Masonry.h>
#import "MyCustomView.h"
#import "CInputView.h"
#import "ChatMsgDTO.h"
#import "JHFacePlist.h"
#import "ChatMsgListManage.h"
#import "MsgSummaryManage.h"
#import "MsgListTableViewCell.h"
#import "UploadFileCore.h"
#import "JHAudioManager.h"
#import "JHCacheManager.h"
#import "HJAlertView.h"
#import "ReviewImageView.h"
#import "VideoPlayViewController.h"
#import "RelayViewController.h"
#import "CommentViewController.h"
#import "MessageModel.h"
#import "MsgSummaryManage.h"
#import <MJRefresh/MJRefresh.h>
#import "QuestionModel.h"
#define maxChatWidth 200
#define maximgWidth 113
#define maximgHeight 120
#define vedioimgWidth 110
#define vedioimgHeight 120

@interface ProblemDetailViewController ()<UITableViewDataSource,UITableViewDelegate,InputViewDelegate,MsgListTableViewCellDelegate,xmppDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JZUploadFileDelegate,UploadDelegate>{
    UILabel *_submitLab;//提交问题
    UIView *_backview;//遮挡视图
    UIView *_avdioView;//录音遮挡图
    BOOL _backisShow;//遮挡视图隐藏
    UploadFileCore *_uploadData;//上传消息附件
    NSTimer *_audioTime;//录音播放计时器
    ChatMsgDTO *_selectedMsg;//长按选中的消息
    BOOL _isTeacher;//是否为老师  no 学生
    UIBarButtonItem *_rightBarButton;//右侧itembar
    NSTimer *_reviewTime;//审题倒计时
    NSInteger _timeCount;//时间
    NSString *_userServerId;//服务器用户id
}
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) CInputView *chatInputView;  //键盘
@property (nonatomic, strong) NSMutableArray *dataArray;//聊天数据

//消息重复
@property(nonatomic,strong)UIActivityIndicatorView *sendMsgAgain;

@end

@implementation ProblemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userServerId = [UserInfoList loginUserId];
    self.dataArray = [@[] mutableCopy];
    _timeCount = 60;
    if ([self.questionId isEqualToString:@"100"]) {
        self.questionType = QuestionTypeSubmit;
    }
    self.userId = [UserInfoList loginUserPhone];
    if (!self.chatId) {
        self.chatId = self.userId;
    }
    if ([[UserInfoList loginUserType] isEqualToString:@"S"]){
        _isTeacher = NO;
    }else
        _isTeacher = YES;
    [XMPPManager sharedManager].delegate = self;
    //消息上传
    _uploadData = [[UploadFileCore alloc] init];
    _uploadData.delegate = self;
    //消息列表
    if (_isTeacher ) {
        
        self.dataArray = [self getMessageArrWithMsgData:self.questionData];
    }
    NSArray *dataArr = [[ChatMsgListManage shareInstance]readChatMsgList:self.chatId :self.userId :0 :0];
    for (ChatMsgDTO *msg in dataArr) {
        if ([msg.questionID isEqualToString:self.questionId]) {
            [self.dataArray addObject:msg];
        }
    }
    [self layoutNavigation];
    [self layoutTableView];
    // Do any additional setup after loading the view.
    //新消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReload:) name:kNewMessageNotification object:nil];
    //问题被抢答
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionToResponder:) name:kResponderNotification object:nil];
    if (self.dataArray.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }
    [self hiddenInputviewWithQustiontype];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_reviewTime setFireDate:[NSDate distantFuture]];
    _reviewTime = nil;
}
- (void)layoutNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publemLeftBar"] style:UIBarButtonItemStylePlain target:self action:@selector(backTolistView)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    _rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publemRightBar"] style:UIBarButtonItemStylePlain target:self action:@selector(showBarMenu)];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
    if (!_isTeacher && self.questionType == QuestionTypeSubmit) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.navigationItem.title = @"问题详情";
}
- (void)layoutTableView{
    self.chatTableView = [[UITableView alloc] init];
    [self.view addSubview:self.chatTableView];
    self.chatTableView.frame = CGRectMake(0, 0, Main_Width, Main_Screen_Height - 44 - 64);
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
    self.chatInputView = [[CInputView alloc] init];
    [self.view addSubview:_chatInputView];
    self.chatInputView.frame = CGRectMake(0, Main_Screen_Height - 44 - 64, Main_Width, 194);
    [self.chatInputView layoutViews];
    self.chatInputView.delegate = self;
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = [UIColor whiteColor];
    submitBtn.layer.cornerRadius = 5;
    [submitBtn addTarget:self action:@selector(submitQuestionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@-5);
        make.height.equalTo(@45);
        make.width.equalTo(@136);
    }];
    _submitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 136, 40)];
    _submitLab.textAlignment = NSTextAlignmentCenter;
    _submitLab.attributedText = [self getSubmitBtnTitle];
    _submitLab.numberOfLines = 2;
    [submitBtn addSubview:_submitLab];
}
//右上角菜单
- (void)showBarMenu{
    if (!_backview) {
        _backisShow = YES;
        _backview = [UIView new];
        UITapGestureRecognizer *backtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapHiddeView)];
        [_backview addGestureRecognizer:backtapGesture];
        [self.view addSubview:_backview];
        [_backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        _backview.backgroundColor = [UIColor clearColor];
        UIImageView *backImage = [UIImageView new];
        if (_isTeacher) {
            backImage.image = [UIImage imageNamed:@"imBarstuimgT"];
        }else
         backImage.image = [UIImage imageNamed:@"imBarstuimg"];
        [_backview addSubview:backImage];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backview).offset(7);
            make.right.equalTo(_backview).offset(-10);
            make.width.equalTo(@90);
            if (_isTeacher) {
                make.height.equalTo(@45);
            }else
             make.height.equalTo(@85);
        }];
        UIButton *changeTea = [self creatImageBtnWithTitlt:@"更换老师" titCloro:[UIColor whiteColor] leftImage:@"imChangeTea"];
        changeTea.tag = 1801;
        [_backview addSubview:changeTea];
        [changeTea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12);
            make.right.equalTo(backImage);
            make.width.equalTo(@90);
            make.height.equalTo(@40);
        }];
        if (!_isTeacher) {
            UIButton *showTeacher = [self creatImageBtnWithTitlt:@"老师详情" titCloro:[UIColor whiteColor] leftImage:@"imShowTeaDea"];
            [_backview addSubview:showTeacher];
            showTeacher.tag = 1802;
            [showTeacher mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@52);
                make.right.equalTo(backImage);
                make.width.equalTo(@90);
                make.height.equalTo(@40);
            }];
            [changeTea addTarget:self action:@selector(naviBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [showTeacher addTarget:self action:@selector(naviBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(2, 45, 86, 1)];
            lineview.backgroundColor = RGBCOLOR(64, 64, 64);
            [backImage addSubview:lineview];
        }
    }
    [self hiddenBackView];
}
- (void)backTapHiddeView{
    _backview.hidden = YES;
    _backisShow = YES;
}
- (void)naviBarBtnClick:(UIButton *)btn{
    _backview.hidden = YES;
    _backisShow = YES;
    if (btn.tag == 1801){
        //更换老师
        self.questionType = QuestionTypeCancel;
        _submitLab.attributedText = [self getSubmitBtnTitle];
        [[[HJAlertView alloc] init] showAlertViewWithContent:@"正在为您更换老师" cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:NO selectBlock:nil];
        
    }else {
        //老师详情
    }
}
//隐藏back视图
- (void)hiddenBackView{
    if (_backisShow) {
        _backview.hidden = NO;
        _backisShow = NO;
    }else{
        _backview.hidden = YES;
        _backisShow = YES;
    }
}
#pragma mark - 新消息处理
// 接收到新消息通知
- (void)newMessageReload:(NSNotification *)notification{
    
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_async(queue, ^{
        ChatMsgDTO *model = [[notification userInfo] objectForKey:@"newMessage"];
        if (![model.questionID isEqualToString:self.questionId]) {
            return ;
        }
        [self.dataArray addObject:model];
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        NSMutableArray * array1 = [[NSMutableArray alloc] init];
        [array1 addObject:path];
        [self.chatTableView insertRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationBottom];
        [self.chatTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
    
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
    MsgListTableViewCell *cell = (MsgListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cllID];
    if (cell) {
        cell.timeLable = nil;
        NSArray *contentArray = cell.contentView.subviews;
        for (UIView *subview in contentArray) {
            [subview removeFromSuperview];
        }
//        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (!cell){
        cell = [[MsgListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cllID];
    }
    cell.isShowTime = isShowTime;
    //    cell.emojiDic=emojiDic;
    cell.msgDto = msgDto;
    cell.isShowName = isShowName;
    //cell布局并赋值
    [cell initcellView];
    //设置长按事件
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
    //longPress.delegate = self;
    longPress.minimumPressDuration = 1.0;
    longPress.allowableMovement = 30;
    //将长按手势添加到需要实现长按操作的视图里
    [cell.chatMsgBg addGestureRecognizer:longPress];
    cell.chatMsgBg.tag = indexPath.row;
    cell.delegate = self;
    cell.tag = 40000 + indexPath.row;
    //为发送失败按钮增加重新发送事件
    if(0 == msgDto.success){
        self.sendMsgAgain = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.sendMsgAgain.frame = CGRectMake(cell.successViewButton.frame.origin.x, cell.successViewButton.frame.origin.y, cell.successViewButton.frame.size.width, cell.successViewButton.frame.size.height);
        [cell addSubview:self.sendMsgAgain];
        [cell.successViewButton addTarget:self action:@selector(clickSuccessViewButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.successViewButton.tag = indexPath.row;
    }
    else if(msgDto.success == 3)
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
        //视频 初始化上传
//        if (!cell.uploadFile) {
//            cell.uploadFile = [[JZUploadFile alloc] initHost:[OperatePlist HTTPServerAddress] port:10000];
//            cell.uploadFile.delegate = self;
//        }
//        if (!msgDto.url) {
//            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//            NSString * toMp4Path = [cachPath stringByAppendingFormat:@"/output-%@.mp4", msgDto.msgid];
//            [cell.uploadFile uploadFilePath:toMp4Path fileName:msgDto.msgid];
//            [cell.uploadFile startUpload];
//        }
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
//        if (!msgDto.url) {
//            [uploadData uplaodChatMessage:msgDto];
//        }
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
            height = [[MsgListTableViewCell new] heightForMessageContent:msgDto.content].height;
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
    [self inputViewHeightChanged:0 duration:0.1];
}
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - 语音播放 cell代理
-(void)playVoiceMessage:(MsgListTableViewCell *)cell {
    
//    if ([self appDelegate].isHasBackgroundMusic) {
//        //程序进入后台音乐开启
//        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
//        MPMusicPlaybackState playbackState = musicPlayer.playbackState;
//        if (playbackState == MPMusicPlaybackStatePlaying) {
//            [musicPlayer pause];
//        }
//    }
    [[JHAudioManager sharedInstance] audioStop];
    for (int i = 0; i < self.dataArray.count ; i++) {   //循环一次
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MsgListTableViewCell *testCell = (MsgListTableViewCell *)[self.chatTableView  cellForRowAtIndexPath:indexPath];
        if (testCell.msgDto.filetype == 1 && testCell.msgDto.msgid != cell.msgDto.msgid) {
            if ([testCell.soundImageView isAnimating]) {
                [testCell.soundImageView stopAnimating];
            }
        }
    }
    
    ChatMsgDTO *msg = cell.msgDto;
    if ([cell.soundImageView isAnimating]) {  // 判断是否正在播放
        [cell.soundImageView stopAnimating];
    } else {
        [JHAudioManager sharedInstance].Cancelblock = ^{
            //时间倒计时
            _audioTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishi:) userInfo:cell repeats:YES];
        };
        [[JHAudioManager sharedInstance] changeMode];
        [[JHAudioManager sharedInstance] recordPlayChatMessage:msg];
        //如果标记为未读，则更改状态为已读
        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",cell.msgDto.isread]]) {
            cell.msgDto.isread = @"1";
            [[ChatMsgListManage shareInstance]saveSendMsgRead:cell.msgDto];
            [cell hideReddot];
        }
        [cell.soundImageView startAnimating];
        [NSTimer scheduledTimerWithTimeInterval:[msg.duration floatValue] target:self selector:@selector(stopPlayingAnimating:) userInfo:cell.soundImageView repeats:NO];
    }
    
}
- (void)daojishi:(NSTimer*)time{
    MsgListTableViewCell *cell = (MsgListTableViewCell*) time.userInfo;
    NSString *str = cell.audioTimeLengthLabel.text;
    NSInteger strtime = [[str substringToIndex:str.length-1] integerValue];
    [cell audioTimeLengthLabel].text = [NSString stringWithFormat:@"%ld ''",(long)strtime-1];
    if (strtime <= 1) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
        [cell audioTimeLengthLabel].text = [NSString stringWithFormat:@"%ld ''",(long)[cell.msgDto.duration integerValue]];
        [_audioTime invalidate];
        _audioTime = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        return;
    }
}
- (void)stopPlayingAnimating:(NSTimer *)time {
    
    [time.userInfo stopAnimating];
}

#pragma mark 展示照片 加载完成
- (void)reloadImageInLoadSuccess{
    CGPoint point = self.chatTableView.contentOffset;
    [self.chatTableView reloadData];
    self.chatTableView.contentOffset = point;
}
#pragma mark 视频播放
//下载视频
- (void)DownLoadVideoInMsgListTableViewCell:(MsgListTableViewCell *)cell{
    VideoPlayViewController *videoPlayViewController=[[VideoPlayViewController alloc]init];
    videoPlayViewController.msg=cell.msgDto;
    [self.navigationController pushViewController:videoPlayViewController animated:YES];
}
#pragma mark - CInputView delegate
//0.25 语音  0.1回收键盘
- (void)inputViewHeightChanged:(CGFloat)height duration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        CGRect tableframe  = _chatTableView.frame;
        tableframe.size.height = Main_Screen_Height - 108 - height;
        _chatTableView.frame = tableframe;
        CGRect inputframe = _chatInputView.frame;
        inputframe.origin.y = Main_Screen_Height - 64 - _chatInputView.frame.size.height + 150 - height;
        _chatInputView.frame = inputframe;
        if (height == 0 && duration == 0.25) {
            _chatInputView.frame = CGRectMake(0, Main_Screen_Height - 44 - 64, Main_Width, 194);
            _chatInputView.inputText.frame = CGRectMake(50, 7, Main_Width - 150, 30);
            _chatInputView.inputText.text = @"";
        }
    }];
    if (_chatTableView.contentSize.height + 64 > _chatInputView.frame.origin.y) {
//        _chatTableView.contentOffset = CGPointMake(0, - (_chatTableView.contentSize.height - _chatInputView.frame.origin.y));
         [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)changeToolViewHeige:(CGFloat)height{
    CGRect tableframe  = _chatTableView.frame;
    tableframe.size.height -= height;
    _chatTableView.frame = tableframe;
    CGRect inputframe = _chatInputView.frame;
    inputframe.origin.y -= height;
    inputframe.size.height += height;
    _chatInputView.frame = inputframe;
    CGRect frame = _chatInputView.inputText.frame;
    frame.size.height += height;
    _chatInputView.inputText.frame = frame;
    if (_chatTableView.contentSize.height +64 > _chatInputView.frame.origin.y) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
    }
}
- (void)recoverToolViewFrame{
    CGFloat height = self.chatInputView.inputText.frame.size.height - 30;
    CGRect tableframe  = _chatTableView.frame;
    tableframe.size.height += height;
    _chatTableView.frame = tableframe;
    CGRect inputframe = _chatInputView.frame;
    inputframe.origin.y += height;
    inputframe.size.height -= height;
    _chatInputView.frame = inputframe;
    CGRect frame = _chatInputView.inputText.frame;
    frame.size.height -= height;
    _chatInputView.inputText.frame = frame;
}

//  录音动画
- (void)showRecordAnimation{
    if(!_avdioView){
        _avdioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height-44)];
        UIImageView *audioBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"chat_recording_back"]];
        audioBackImage.size = (CGSize){100 , 80};
        UIImageView *audioImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"chat_recording"]];
        audioImage.size = (CGSize){69 * (50 / 107.0),50};
        audioImage.center = audioBackImage.center = _avdioView.center;
        [_avdioView addSubview:audioBackImage];
        [_avdioView addSubview:audioImage];
        [[self appDelegate].window addSubview:_avdioView];
    }
}
- (void)stopRecordAnimation{
    [_avdioView removeFromSuperview];
    
}
#pragma mark - 录音完成 + 更多按钮
- (void)postSoundWithUrlString:(NSString *)localpath andRecordTime:(NSString *)duration withRecordData:(NSData *)recData{
    [self stopRecordAnimation];
    ChatMsgDTO *msg = [[ChatMsgDTO alloc] init];
    msg.filetype = 1;
    msg.localpath=localpath;
    msg.fromuid=self.userId;
//    msg.sendName = sendname;
//    msg.receiverName = chatname;
    msg.touid=self.chatId;
    msg.sendtime=[JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
    msg.sendtype=0;
    msg.msgid=[JZCommon GUID];
    msg.duration = duration;
    msg.success =3;
    msg.questionID = self.questionId;
    msg.grade = self.tempGrade;
    msg.subjects = self.tempObject;
    msg.teacherID = _teacherId;
    if (self.questionType == QuestionTypeSubmit) {
        msg.success = 1;
    }
    //保存本地数据
    [self savechatMsg:msg];
    //上传至文件服务器
    [_uploadData uplaodChatMessage:msg];
}

//  更多代理
- (void)moveViewActionWithType:(MoreViewActionType)type{ //0 相册 1视频
    UIImagePickerController *controller=[[UIImagePickerController alloc]init];
    controller.delegate=self;
    NSArray *titlesArr = @[];
    if (type == MoreViewActionPhoto) {
        titlesArr = @[@"拍照",@"相册"];
    }else{
        titlesArr = @[@"录像",@"视频库"];
    }
    [[[HJAlertView alloc] init]showBottomAlertViewWithTitles:titlesArr ClickBtn:^(NSInteger index) {
        if (type == MoreViewActionPhoto) {
            if (index == 0) {
                BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
                if (!isCamera) {
                    NSLog(@"没有摄像头");
                    return ;
                }
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                //拒绝访问相机弹出提示框
                if(authStatus == AVAuthorizationStatusDenied){
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"开启摄像头出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return ;
                }
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
            }else{
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
            }
        }else{
            if (index == 0) {
                BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
                if (!isCamera) {
                    NSLog(@"没有摄像头");
                    return ;
                }
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                //拒绝访问相机弹出提示框
                if(authStatus == AVAuthorizationStatusDenied){
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"开启摄像头出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return ;
                }
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                //设置图像选取控制器的类型为动态图像
                controller.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeMovie, nil];
                //设置摄像图像品质
                controller.videoQuality = UIImagePickerControllerQualityTypeMedium;
            }else{
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeMovie];
                controller.mediaTypes = mediaTypes;
            }
        }
        [self presentViewController:controller animated:YES completion:^(void){
            //NSLog(@"Picker View Controller is presented");
        }];
    }];
}
#pragma mark - 查看图片
- (void)showImageInMsgListTableViewCell:(MsgListTableViewCell *)cell{
    ReviewImageView *showImageview = [[ReviewImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height) message:cell.msgDto];
    showImageview.recordVideo = ^(NSDictionary *dic){
        [self postSoundWithUrlString:dic[@"localPath"] andRecordTime:dic[@"recordTime"] withRecordData:dic[@"recordData"]];

    };
    [[self appDelegate].window addSubview:showImageview];
}

#pragma mark - 相机选择完成的回调    图片和视频的发送
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak ProblemDetailViewController* weakSelf = self;
    //ios7相册和相机都是从这里取照片
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]){
        UIImage *uploadImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        uploadImage=[image fixOrientation];
        ChatMsgDTO *msg=[[ChatMsgDTO alloc]init];
        msg.msgid=[JZCommon GUID];
        
        //保存缓存
//        UIImage *ThumbnailImage=[self imageWithImage:uploadImage scaledToSize:CGSizeMake(uploadImage.size.width/3, uploadImage.size.height/3)];
//        NSString *ThumbnailStr=[[JHCacheManager sharedInstance] saveImage:ThumbnailImage imageName:[CommonCore GUID] userid:self.userId];
        //保存本地消息
        msg.filetype = 2;
        msg.localpath = [[JHCacheManager sharedInstance] saveImage:uploadImage imageName:[JZCommon GUID] userid:self.userId];
        msg.thumbnail = msg.localpath;
        msg.fromuid = self.userId;
        msg.touid = self.chatId;
        msg.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        msg.sendtype = 0;
        msg.chatType = 0;
        
        msg.isread=@"1";
        msg.success=3;
        msg.questionID = self.questionId;
        msg.grade = self.tempGrade;
        msg.subjects = self.tempObject;
        msg.teacherID = _teacherId;
        if (self.questionType == QuestionTypeSubmit) {
            msg.success = 1;
        }
        //保存本地数据
        [self savechatMsg:msg];
        [_uploadData uplaodChatMessage:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            //关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:^{
            }];
        });
    }
    //视频
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        //视频地址
        NSURL *videoURL=info[UIImagePickerControllerMediaURL];
        NSData *videoData=[NSData dataWithContentsOfURL:videoURL];
        //得到MP4第一帧
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = self.view.frame.size;
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
        UIImage *VideoImg=[UIImage imageWithCGImage:img];
        //图片本地路径
        NSString *VideoImgStr = [[JHCacheManager sharedInstance] saveImage:VideoImg imageName:[JZCommon GUID] userid:self.userId];
        NSString *msgid = [JZCommon GUID];
        //保存本地消息
        ChatMsgDTO *msg = [[ChatMsgDTO alloc]init];
        msg.filetype = 3;
        msg.fromuid = self.userId;
        msg.touid = self.chatId;
        msg.thumbnail = VideoImgStr;//本地缩略图
        msg.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
        msg.sendtype = 0;
        msg.chatType = 0;
        msg.msgid = msgid;
        msg.isread = @"1";
        msg.success = 3;
        //断网显示红点
        Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        if ([r currentReachabilityStatus] == NotReachable) {
            msg.success = 0;
            //提示用户;
        }
        //            //更新本地消息
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString * toMp4Path = [cachPath stringByAppendingFormat:@"/output-%@.mp4", msg.msgid];
        
        [videoData writeToFile:toMp4Path atomically:YES];
        //            [NSString stringWithFormat:@"%dKB",[msgDto.totalsize intValue]/1024]
        NSInteger mp4size = [self getFileSize:toMp4Path];
        NSString *fileSize = @"";
        NSString *videoLen = @"";
        if (mp4size > 1024 * 1024) {
            fileSize = [NSString stringWithFormat:@"%.1fMB", mp4size / (1024 * 1024.0)];
        }else if (mp4size > 1024){
            fileSize = [NSString stringWithFormat:@"%ldKB", (long)(mp4size / 1024)];
        }else{
            fileSize = [NSString stringWithFormat:@"%ldB", (long)mp4size];
        }
        videoLen = [NSString stringWithFormat:@"%.0f",[self getVideoDuration:[NSURL fileURLWithPath:toMp4Path]]];//毫秒上传
        msg.totalsize = fileSize;
        msg.duration = videoLen;
        msg.localpath = toMp4Path;
        msg.content = toMp4Path;//解码后的路径
        msg.questionID = self.questionId;
        msg.grade = self.tempGrade;
        msg.subjects = self.tempObject;
        msg.teacherID = _teacherId;
        if (self.questionType == QuestionTypeSubmit) {
            msg.success = 1;
        }
        //保存本地数据
        [self savechatMsg:msg];
        [_uploadData uplaodChatMessage:msg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:^{
            }];
//            [self.inputTool initInputTextState];
        });
    }
}



#pragma mark - 发送文字消息及消息上传
- (void)sendMessageToChat:(NSString *)text {
    
    NSString *content = [[JHFacePlist sharedInstance]formatMsgText:text];
    ChatMsgDTO *msg = [[ChatMsgDTO alloc]init];
    msg.content = content;
    msg.filetype = 0;
    msg.url = nil;
    msg.fromuid = self.userId;
    msg.touid = self.chatId;
    msg.sendtype = 0;
    msg.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
    msg.msgid = [JZCommon GUID];
    msg.localpath = nil;
    msg.chatType = 0;
    msg.success = 3;
    msg.questionID = self.questionId;
    msg.grade = self.tempGrade;
    msg.subjects = self.tempObject;
    msg.teacherID = _teacherId;
    if (self.questionType == QuestionTypeSubmit) {
        msg.success = 1;
        //本地保存
        [self savechatMsg:msg];
    }else{
        //本地保存
        [self savechatMsg:msg];
        //发送文本消息
        [self sendContent:msg];
    }
    [self recoverToolViewFrame];
}
#pragma mark---公共方法 保存数据 上传文件代理

//保存消息
- (void)savechatMsg:(ChatMsgDTO *)msg {
    //聊天记录进入后,按正常的聊天
    //    self.searchType=0;
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [self.dataArray addObject:msg];
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        NSMutableArray * array1 = [[NSMutableArray alloc] init];
        [array1 addObject:path];
        [self.chatTableView insertRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationBottom];
        [self.chatTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
    //子线程保存数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //保存消息表
        [[ChatMsgListManage shareInstance]saveChatMsg:msg];
        //保存消息汇总信息
        [[MsgSummaryManage shareInstance] dealMsgSummary:msg :self.chatId];
        
    });
    
    //设置为有新消息
    //    [self appDelegate].isHaveNewMsg=YES;
    
}

#pragma mark - 发送消息

//发送消息内容   判断有没网
- (void)sendContent:(ChatMsgDTO *)msg {
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == NotReachable){
        //更新消息发送状态
        msg.success=0;
//        [self reloadCell:msg.msgid];
        //子线程保存数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[ChatMsgListManage shareInstance] saveSendMsgSuccess:msg];
        });
    }
    else{
        //子线程保存数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[XMPPManager sharedManager] sendMessage:msg];
        });
        
    }
}
#pragma mark - 发送成功代理
- (void)sendMessageIsSuccess:(XMPPMessage *)message{
    //    NSString *msg = [[message elementForName:@"body"] stringValue];
    //    NSString *type = [[message elementForName:@"messageType"] stringValue];
    if (message.isErrorMessage) {
        return;
    }
    if ([[[message elementForName:@"messageIsSuccess"] stringValue] integerValue] == 1){
        NSString *msgid = [[message attributeForName:@"id"] stringValue]; //huizhi
        for (ChatMsgDTO * chatmsg in self.dataArray) {
            if ([chatmsg.msgid isEqualToString:msgid]) {
                chatmsg.success = 1;
                NSInteger indexcell = [self.dataArray indexOfObject:chatmsg];
                //            将收到消息更新到数据库
                [[ChatMsgListManage shareInstance] saveSendMsgSuccess:chatmsg];
                MsgListTableViewCell *cell = (MsgListTableViewCell*)[self.chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexcell inSection:0]];
                [cell.avi stopAnimating];
                return;
                
            }
        }
    }else{
        NSString *msgid = [[message attributeForName:@"id"] stringValue]; 
        for (ChatMsgDTO * chatmsg in self.dataArray) {
            if ([chatmsg.msgid isEqualToString:msgid]) {
                chatmsg.success = 0;
                NSInteger indexcell = [self.dataArray indexOfObject:chatmsg];
                //            将收到消息更新到数据库
                [[ChatMsgListManage shareInstance] saveSendMsgSuccess:chatmsg];
                MsgListTableViewCell *cell = (MsgListTableViewCell*)[self.chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexcell inSection:0]];
                [cell.avi stopAnimating];
                if (!cell.successViewButton) {
                    cell.successViewButton=[[UIButton alloc]initWithFrame:CGRectMake(cell.chatMsgBg.frame.origin.x-20, cell.chatMsgBg.frame.origin.y+(cell.chatMsgBg.frame.size.height-20)/2, 20, 20)];
                    [cell.successViewButton setBackgroundImage:[UIImage imageNamed:@"ic_send_fail.png"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:cell.successViewButton];
                }
                else {
                    [cell.successViewButton setFrame:CGRectMake(cell.chatMsgBg.frame.origin.x-20, cell.chatMsgBg.frame.origin.y+(cell.chatMsgBg.frame.size.height-20)/2, 20, 20)];
                    [cell.successViewButton setBackgroundImage:[UIImage imageNamed:@"ic_send_fail.png"] forState:UIControlStateNormal];
                }
                if (cell.msgDto.filetype == 1) {
                    CGRect btnframe = cell.successViewButton.frame;
                    btnframe.origin.x -= 35;
                    cell.successViewButton.frame = btnframe;
                }
                [cell.successViewButton addTarget:self action:@selector(clickSuccessViewButton:) forControlEvents:UIControlEventTouchUpInside];
                cell.successViewButton.tag=indexcell;
                return;
                
            }
        }
    }
}

- (void)clickSuccessViewButton:(UIButton *)btn{
    
}
#pragma mark - 消息转发、收藏
- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        UIButton *cellMesBtn = (UIButton *)[gesture view];
        [self becomeFirstResponder];
        MsgListTableViewCell *cell = (MsgListTableViewCell *)[_chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellMesBtn.tag inSection:0]];
        [cell becomeFirstResponder];
        _selectedMsg = cell.msgDto;
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage)];
        if (_selectedMsg.filetype == 1) {
            menuItem1 = [[UIMenuItem alloc] initWithTitle:@"使用听筒播放" action:@selector(copyMessage)];
        }
        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(collectMessage)];
        UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"更多" action:@selector(otherMessage)];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (_selectedMsg.filetype == 1 || _selectedMsg.filetype == 0) {
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,menuItem3,nil]];
        }else{
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem2,menuItem3,nil]];
        }
        [menuController setTargetRect:cell.frame inView:self.chatTableView];
        [menuController setMenuVisible:YES animated:YES];

    }
}
-(void)showMenu:(CGPoint)point message:(ChatMsgDTO *)message{
    
    
}
//复制
- (void)copyMessage{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _selectedMsg.content;
}
//转发
- (void)collectMessage{
    //跳转至转发界面
}
//更多
- (void)otherMessage{
    RelayViewController *relayVC = [[RelayViewController alloc] init];
    relayVC.chatId = self.chatId;
    relayVC.deleteMessageBlock = ^(){
        self.dataArray = [[ChatMsgListManage shareInstance]readChatMsgList:self.chatId :self.userId :0 :0];
        [self.chatTableView reloadData];
        if (self.dataArray.count > 0) {
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];
        }
    };
    [self.navigationController pushViewController:relayVC animated:YES];
}


#pragma mark -跳转操作
- (void)backTolistView{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 创建button方法
- (UIButton *)creatImageBtnWithTitlt:(NSString *)title titCloro:(UIColor *)color leftImage:(NSString *)imagename{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 70)];
    return btn;
    
}
#pragma mark - 视频工具类
//获取视频时长
- (CGFloat)getVideoDuration:(NSURL *)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}
//获取视频大小
- (NSInteger)getFileSize:(NSString *)path {
    NSFileManager * filemanager=[[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
        return -1;
}
#pragma mark - 隐藏输入框
- (void)hiddenInputviewWithQustiontype{
    self.chatInputView.userInteractionEnabled = YES;
    switch (self.questionType) {
        case QuestionTypeCancel:{
            //添加一个view 点击手势
//            [[HJAlertView new] showAlertViewWithContent:@"当前状态禁止输入" cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:YES selectBlock:nil];
            self.chatInputView.userInteractionEnabled = NO;
        }
            break;
        case QuestionTypeReview:{
            self.chatInputView.userInteractionEnabled = NO;
        }
            break;
        case QuestionTypeEnd:{
            if ([self.chatId isEqualToString:self.userId]) {
                self.chatInputView.userInteractionEnabled = NO;
            }
        }
            break;
//        case <#constant#>:
//            <#statements#>
//            break;
//        case <#constant#>:
//            <#statements#>
//            break;
//        case <#constant#>:
//            <#statements#>
//            break;
        default:
            break;
    }
}
#pragma mark - 问题相关操作
//提交问题按钮
- (NSAttributedString *)getSubmitBtnTitle{
    NSMutableAttributedString *attributestr = nil;
    switch (self.questionType) {
        case QuestionTypeSubmit:{
            attributestr = [[NSMutableAttributedString alloc] initWithString:@"提交问题\n(限时免费)"];
            [attributestr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff7949), NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 4)];
            [attributestr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xbcbcbc), NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(5, 6)];
        }
            break;
        case QuestionTypeEnd:{
            attributestr = [[NSMutableAttributedString alloc] initWithString:@"完成问题"];
            [attributestr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff7949), NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 4)];
        }
            break;
        case QuestionTypeCancel:{
            attributestr = [[NSMutableAttributedString alloc] initWithString:@"取消问题\n正在为你匹配老师..."];
            [attributestr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff7949), NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 4)];
            [attributestr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xbcbcbc), NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(5, 11)];
        }
            break;
        case QuestionTypeReview:{
            if (!_reviewTime) {
                [[HJAlertView new] showAlertViewWithContent:@"您有60秒的时间审题" cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:YES selectBlock:nil];
                _reviewTime = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changeReviewTime) userInfo:nil repeats:YES];
                NSRunLoop * main=[NSRunLoop currentRunLoop];
                [main addTimer:_reviewTime forMode:NSRunLoopCommonModes];
                [_reviewTime fire];
            }
            NSString *timestr = [NSString stringWithFormat:@"抢答问题\n%ld秒",(long)_timeCount];
            attributestr = [[NSMutableAttributedString alloc] initWithString:timestr];
            [attributestr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff7949), NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, 4)];
            [attributestr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xbcbcbc), NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(5, timestr.length - 5)];
        }
            break;
            
        default:
            break;
    }
    return attributestr;
}

- (void)changeReviewTime{
    if (_timeCount > 0) {
        _timeCount -= 1;
        _submitLab.attributedText = [self getSubmitBtnTitle];
    }else{
        [_reviewTime setFireDate:[NSDate distantFuture]];
        _reviewTime = nil;
        [[HJAlertView new] showAlertViewWithContent:@"您的审题时间已用完，请问是否答题？" cancelBtnTitle:@"去答题" otherBtnTitle:@"放弃" isAutoHidden:NO selectBlock:^(NSInteger index) {
            if (index == 0) {
                [self teacherRequestResponderQuestion];
            }
        }];
    }
}
#pragma mark - 抢答问题
- (void)teacherRequestResponderQuestion{
    NSString *requestURL = [NSString stringWithFormat:@"http://%@:%@/studyManager/instantAnswerAction/firstAnswer.action",[OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort]];
    NSDictionary *dic = @{@"id":self.questionId,@"userId":self.studyID,@"teacherId":[JZCommon queryLoginUserId]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:requestURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"success"]) {
            self.answerSuccess();
            [[HJAlertView new] showAlertViewWithContent:@"抢答成功" cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:YES selectBlock:nil];
            [self teacherResponderQuestion];
        }else {
            [[HJAlertView new] showAlertViewWithContent:@"抢答失败" cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:YES selectBlock:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)teacherResponderQuestion{
    ChatMsgDTO *msg = [[ChatMsgDTO alloc]init];
    msg.content = _userServerId;
    msg.filetype = 7;
    msg.url = nil;
    msg.fromuid = self.userId;
    msg.touid = self.chatId;
    msg.sendtype = 0;
    msg.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
    msg.msgid = [JZCommon GUID];
    msg.localpath = nil;
    msg.chatType = 0;
    msg.success = 3;
    msg.questionID = self.questionId;
    [self sendContent:msg];

}
#pragma mark - 提交问题  解析问题
- (void)submitQuestionBtn:(UIButton *)btn{
    switch (self.questionType) {
        case QuestionTypeSubmit:{
            if (self.dataArray.count <= 0 ) {
                [[HJAlertView new] showAlertViewWithContent:@"输入问题描述" cancelBtnTitle:@"确定" otherBtnTitle:nil isAutoHidden:YES selectBlock:nil];
            }else
                //提交问题
                [self submitQuestion];
        }
            break;
        case QuestionTypeEnd:{
            //学生跳转评价界面
            //老师弹出提示框
            if (_isTeacher) {
                [[[HJAlertView alloc] init] showAlertViewWithContent:@"恭喜您！您的答题赏金已经入账。您的好评是我们最大的动力。" cancelBtnTitle:@"下次吧" otherBtnTitle:@"去好评" isAutoHidden:NO selectBlock:^(NSInteger tag){
                    switch (tag) {
                        case 0:
                            
                            break;
                        case 1:
                            //跳转
                            break;
                        default:
                            break;
                    }
                }];
            }else{
                CommentViewController *commentView = [CommentViewController new];
                commentView.questionID = self.questionId;
                commentView.teacherID = self.teacherId;
                [self.navigationController pushViewController:commentView animated:YES];
            }
            
        }
            break;
        case QuestionTypeCancel:{
            [self backTolistView];
        }
            break;
        case QuestionTypeReview:{
            //抢答问题
            [self teacherRequestResponderQuestion];
            self.questionType = QuestionTypeEnd;
            [_reviewTime setFireDate:[NSDate distantFuture]];
            _reviewTime = nil;
            _submitLab.attributedText = [self getSubmitBtnTitle];
        }
            break;
        default:
            break;

    }
    [self hiddenInputviewWithQustiontype];
}
//提交问题
- (void)submitQuestion{
    NSString *questionContent = @"";
    ChatMsgDTO *firstMsg = (ChatMsgDTO *)self.dataArray.firstObject;
    switch ([firstMsg filetype]) {
        case 0:
            questionContent = firstMsg.content;
            break;
        case 1:
            questionContent = @"语音";
            break;
        case 2:
            questionContent = @"图片";
            break;
        case 3:
            questionContent = @"视频";
            break;
        default:
            break;
    }
    questionContent = [questionContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *questronJson = [self changeMessageToJson:self.dataArray];
    questronJson = [questronJson stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *object = [self.tempObject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *grade = [self.tempGrade stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *questionDic = @{@"userId":[UserInfoList loginUserId],@"content":questronJson,@"grade":grade,@"subject":object,@"type":@"T",@"pictureurl":questionContent};
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage GET:[NSString stringWithFormat:@"http://%@:%@/studyManager/instantAnswerAction/addInstantAnswer.action",[OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort]] parameters:questionDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *questionID = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![questionID isEqualToString:@"0"] && questionID.length > 0) {
            self.questionType = QuestionTypeEnd;
            _submitLab.attributedText = [self getSubmitBtnTitle];
            [[MsgSummaryManage shareInstance] updateMsgSummaryQuestionID:questionID :self.questionId];
            self.questionId = questionID;
            for (ChatMsgDTO *msg in self.dataArray) {
                msg.questionID = questionID;
                [[ChatMsgListManage shareInstance] updateChatMsg:msg.msgid filed:@"questionID" content:questionID];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 将消息转换为data
- (NSMutableArray *)getMessageArrWithMsgData:(NSArray *)dataArr{
    NSMutableArray *msgArr = [@[] mutableCopy];
    for (NSDictionary *dict in dataArr) {
        ChatMsgDTO *msg = [self messageFromJson:dict];
        self.chatId = msg.fromuid;
        [msgArr addObject:msg];
    }
    return msgArr;
}

- (NSString *)changeMessageToJson:(NSArray *)arr{
    NSMutableArray *jsonArr = [@[] mutableCopy];
    for (ChatMsgDTO *msg in arr) {
        NSDictionary *dic = [self MessageToJson:msg];
        [jsonArr addObject:dic];
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:&error];
//    return data;
    NSString *content = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    return content;
}
- (NSDictionary *)MessageToJson:(ChatMsgDTO *)model
{
    NSString *subject = model.touid;
    //收件人
    NSString *jidstring = [NSString stringWithFormat:@"%@@%@",model.touid,[OperatePlist OpenFireServerAddress]];
    MessageModel *msg = [[MessageModel alloc] init];
    msg.addTime = model.sendtime;
    msg.sendAddress = @"";
    msg.voiceLength = @"";
    msg.fileUrl = @"";
    msg.location = @"";
    
    if (model.filetype == 0) {
        msg.attachType = @"0";
        msg.textContent = model.content;
    } else if (model.filetype == 1) {
        msg.attachType = @"1";
        msg.fileUrl = model.url;
        msg.voiceLength = model.duration;
    } else if (model.filetype == 2) {
        msg.attachType = @"2";
        msg.fileUrl = model.url;
    } else if (model.filetype == 3) {
        msg.attachType = @"3";
        msg.fileUrl = model.url;
        msg.voiceLength = model.duration;//长度
        msg.textContent = model.content;
        msg.senderPhone = model.thumbnail;//暂时代替缩略图路径
        msg.receivePhone = model.totalsize;//视频内存
    } else if (model.filetype == 4){
        
        msg.attachType = @"4";
        msg.textContent = model.content; //手机号了
        msg.sendName = model.name; //名字片上的名字
        
        
    } else if (model.filetype == 6){
        msg.attachType = @"6";
        msg.fileUrl = model.url;
        msg.filePath = model.thumbnail;
        msg.textContent = model.content;
    }
    msg.receiveId = model.touid;
    msg.sender = model.fromuid;
    if (model.chatType == 0) {
        msg.isGroup = @"S";
        subject = model.touid;
        //收件人
        jidstring = [NSString stringWithFormat:@"%@@%@",model.touid,[OperatePlist OpenFireServerAddress]];
        
    }else{
        msg.isGroup = @"F";
    }
    msg.iD = model.msgid;
    msg.listPosition = @"";
    msg.delay = false;
    //    msg.delivery_status = 1;
    msg.direction = @"1";
    msg.hasAttach = @"0";
    msg.imageHeight = 0;
    msg.imageWidth = 0;
    msg.isCalendar = @"F";
    msg.isShowTime = @"T";
    
    return [JZCommon dictionaryWithModel:msg];
    
}
- (ChatMsgDTO *)messageFromJson:(NSDictionary *)msg
{
    ChatMsgDTO *result = [[ChatMsgDTO alloc] init];
    NSString *filetype =[NSString stringWithFormat:@"%@",[msg objectForKey:@"attachType"]];
    result.msgid = [JZCommon GUID];
    //    result.sendtime = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
    //    result.msgid = [msg objectForKey:@"iD"];//单聊先用上面
    result.sendtime = [msg objectForKey:@"addTime"];
    result.sendtype = 1;
    result.fromuid = [msg objectForKey:@"sender"];
    result.touid = [msg objectForKey:@"receiveId"];
    
    //    result.isfail = @"1";
    //    result.sender.headurl = [msg objectForKey:@"chatphoto"];
    NSString *isgroup = [msg objectForKey:@"isGroup"];
    //    result.sender = [[BuddyModelDBManager sharedManager] queryBuddyModelByUID:result.fromid];   //因为是接收到别人的信息，sender是对方fromid
    //单聊
    if ([isgroup isEqualToString:@"S"]) {
        result.chatType = 0;
    } else {
        result.chatType =1;
    }
    result.isread = @"0";
    //T文本消息，S语音消息，P图片消息
    //文本、表情
    if ([filetype isEqualToString:@"0"]) {
        result.filetype = 0;
        result.content = [msg objectForKey:@"textContent"];
    } else if ([filetype isEqualToString:@"1"]) {
        //语音
        result.filetype = 1;
        result.url = [msg objectForKey:@"fileUrl"];
        if ([[msg objectForKey:@"voiceLength"] isKindOfClass:[NSString class]]) {
            result.duration = [msg objectForKey:@"voiceLength"];
        } else {
            result.duration = [[msg objectForKey:@"voiceLength"] stringValue];
        }
        
    } else if ([filetype isEqualToString:@"2"]) {
        //图片
        result.filetype = 2;
        result.content = [msg objectForKey:@"fileUrl"];
        result.url = [msg objectForKey:@"fileUrl"];
    }else if ([filetype isEqualToString:@"3"]) {
        //视频
        result.filetype = 3;
        result.url = [msg objectForKey:@"fileUrl"];
        if ([[msg objectForKey:@"voiceLength"] isKindOfClass:[NSString class]]) {
            result.duration = [msg objectForKey:@"voiceLength"];
        } else {
            result.duration = [[msg objectForKey:@"voiceLength"] stringValue];
        }
        //        result.content = [msg objectForKey:@"textContent"];
        result.thumbnail = [msg objectForKey:@"senderPhone"];
        result.totalsize = [msg objectForKey:@"receivePhone"];
        
    } else if ([filetype isEqualToString:@"4"]) {
        
        result.filetype = 4;
        result.name =  result.name = [msg objectForKey:@"sendName"];
        result.content = [msg objectForKey:@"textContent"];
    } else if ([filetype isEqualToString:@"6"]) {
        
        result.filetype = 6;
        result.name =  result.name = [msg objectForKey:@"sendName"];
        result.url = [msg objectForKey:@"fileUrl"];
        result.thumbnail = [msg objectForKey:@"filePath"];
        result.content = [msg objectForKey:@"textContent"];
    }
    else {
        result.content = [msg objectForKey:@"textContent"];
    }
    return result;
}
#pragma mark - 老师解答问题
- (void)questionToResponder:(NSNotification *)notifi{
    ChatMsgDTO *msg = (ChatMsgDTO *)notifi.object;
    self.chatId = [NSString stringWithFormat:@"%@",msg.fromuid];
    _rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publemRightBar"] style:UIBarButtonItemStylePlain target:self action:@selector(showBarMenu)];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
    [[HJAlertView new] showAlertViewWithContent:@"匹配到老师" cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:NO selectBlock:nil];
    [self hiddenInputviewWithQustiontype];
}
- (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
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
