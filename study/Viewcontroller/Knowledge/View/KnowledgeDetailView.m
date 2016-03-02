//
//  KnowledgeDetailView.m
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "KnowledgeDetailView.h"
#import "CommentTabelViewCell.h"
#import <Masonry.h>
#import "CommentModel.h"
#import "CommentHeaderView.h"
#import "LoginViewController.h"
#import "LectureNetCore.h"
#import "LectureDetailModel.h"
#import <UIImageView+AFNetworking.h>
#import "KnowledgeDetailViewController.h"
#import "LectureRootGroupModel.h"
#import "LectureLeafModel.h"
#import "cellHeadView.h"
#import "CellHeadViewCell.h"
#import "JHFacePlist.h"
#import "CommentInputView.h"

@interface KnowledgeDetailView()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,LectureNetCoreDelegate,CommentInputViewDelegate,CommentTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *teacherImageView; //老师头像
@property (weak, nonatomic) IBOutlet UILabel *teacherName;//老师名字
@property (weak, nonatomic) IBOutlet UILabel *releaseTime; //发布时间
@property (weak, nonatomic) IBOutlet UILabel *readCount;  //阅读数量
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn; //关注
@property (weak, nonatomic) IBOutlet UIImageView *subjectTypeImageView; //科目类型
@property (weak, nonatomic) IBOutlet UILabel *subjectTitle;//科目标题
@property (weak, nonatomic) IBOutlet UIButton *subjectCollectBtn;//收藏
@property (weak, nonatomic) IBOutlet UITableView *commentTableView; //视频和评论

@property (nonatomic, strong) CommentHeaderView *headerView;  //header
@property (nonatomic, strong) CommentModel *commentModel;  //cell数据
@property (nonatomic, strong) LectureNetCore *lectureNetCore; //网络请求
@property (nonatomic, strong) LectureDetailModel *detailModel;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat headHeight;

@property (nonatomic, strong) NSArray *lectureRootGroupArray;

@property (nonatomic, strong) NSMutableArray *sourceGroupArray;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) NSMutableArray *headViewArray;

@property (nonatomic, strong) NSArray *friendsData;
@property (nonatomic, strong) NSMutableDictionary *rootDictionary;
@property (nonatomic, assign, getter = isOnLine) BOOL onLine;
@property (nonatomic, strong) UIButton *shelterView;                //遮挡层
@property (nonatomic, strong)     CEmojiView *emojiView;
@property (nonatomic, strong) CommentInputView *inputView;


@end

@implementation KnowledgeDetailView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KView" owner:self options:nil] objectAtIndex:1];
        frame.size.height -=64;
        self.frame = frame;
        __weak __typeof(self) weakSelf = self;
        CommentInputView *inputView = [[CommentInputView alloc] init];
        [self addSubview:inputView];
        _inputView = inputView;
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.commentTableView.mas_bottom);
            make.width.equalTo(weakSelf);
            make.height.equalTo(@194);
            make.left.equalTo(weakSelf);
        }];
        [inputView layoutViews];
        inputView.delegate = self;
        [self loadData];

    }
    return self;
}

// 加载数据
- (void)loadData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"friends.plist" withExtension:nil];
    NSArray *tempArray = [NSArray arrayWithContentsOfURL:url];
    
    NSMutableArray *fgArray = [NSMutableArray array];
    for (NSDictionary *dict in tempArray) {
        LectureRootGroupModel *friendGroup = [LectureRootGroupModel cellLeafWithDict:dict];
        [fgArray addObject:friendGroup];
    }
    
    _friendsData = fgArray;
}

- (void)refreshViewUI {
    _lectureNetCore = [[LectureNetCore alloc] init];
    _lectureNetCore.del = self;
    _headerView = [[CommentHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Width-20, 370)];
    _headerView.lecrureid = self.lecrureid;
    [self.commentTableView beginUpdates];
    [self.commentTableView setTableHeaderView:_headerView];
    [self.commentTableView endUpdates];
}

- (void)setLecrureid:(NSString *)lecrureid {
    _lecrureid = lecrureid;
    [self refreshViewUI];
    [self requestData];//课程详情

}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
}

// - 数据请求
-(void)requestData
{
    //异步请求数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_lectureNetCore requestFindBidLessonDetial:_lecrureid withUserId:[UserInfoList loginStatus]?@"":[UserInfoList loginUserId]];
    });
}

// --- 功能按钮
- (IBAction)founctionBtnClick:(UIButton *)sender {
    if (![UserInfoList loginStatus]) {
        UIAlertView *waringView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲,您还未登录。请登录后在操作" delegate:self cancelButtonTitle:@"登陆" otherButtonTitles:@"取消",nil];
        [waringView show];
    }
    if (sender.tag == 10) {  //关注
        UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持关注" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aleart show];
    }else if (sender.tag == 11) {  //收藏
        NSLog(@"收藏");
        if (_lecrureid != nil) {
            if (sender.selected) { //删除收藏
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [_lectureNetCore requestBiglessonWithDelCollect:_lecrureid];
                });
            }else{
                //异步请求数据   添加收藏
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [_lectureNetCore requestBigLessonWithCollect:_lecrureid withUserId:[UserInfoList loginUserId]];
                });
            }
        }
    }
}

// 界面赋值
- (void)setDetailModel:(LectureDetailModel *)detailModel {
    //老师名字
    if (![JZCommon isBlankString:detailModel.lecturer]) {
        _teacherName.text = detailModel.lecturer;
    }
    //发布时间
    if (![JZCommon isBlankString:detailModel.addtime]) {
        NSString *timeStr = detailModel.addtime;
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"." withString:@"-"];
       _releaseTime.text = timeStr;
    }
    //头像
//    if (![JZCommon isBlankString:detailModel.picurl]) {
//        [_video setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,detailModel.picurl]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
//    }
    //课程题目
    if (![JZCommon isBlankString:self.titleName]) {
        _headerView.titleName = self.titleName;
        self.subjectTitle.text = self.titleName;
    }
    //类型图标
    if (![JZCommon isBlankString:detailModel.subject]) {
        NSString *imageName = [NSString stringWithFormat:@"默认%@",detailModel.subject];
        _subjectTypeImageView.image = [UIImage imageNamed:imageName];
    }
}


//发送文字评论
- (void)sendMessageToChat:(NSString *)text {
    
    NSString *content = [[JHFacePlist sharedInstance]formatMsgText:text];
    CommentModel *msg = [[CommentModel alloc]init];
    msg.content = content;
    msg.name = 0;
    msg.time = [JZCommon dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
    msg.image = nil;
    //发送文本消息
//    [self sendContent:msg];
    
}

- (void)inputViewHeightChanged:(CGFloat)height duration:(CGFloat)duration {
    __weak __typeof(self) weakSelf = self;
    [self setNeedsUpdateConstraints];
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(weakSelf.commentTableView.mas_bottom).offset(-height);
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
    }];
    self.shelterView.hidden = NO;
    if (height == 0) {
        self.shelterView.hidden = YES;
    }
}

#pragma -mark UIAlertViewDelegate
- (void)alertViewCancel:(UIAlertView *)alertView {
    LoginViewController *lVc = [[LoginViewController alloc] init];
    KnowledgeDetailViewController *kdVc = (KnowledgeDetailViewController *)self.superview.nextResponder;
    [kdVc.navigationController pushViewController:lVc animated:YES];
}

#pragma -mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return _cellHeight;
}

#pragma -mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell = @"CommentTabelViewCell";
    CommentTabelViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!commentCell) {
        commentCell = [[CommentTabelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        commentCell.delegate = self;
    }
    LectureRootGroupModel *rootGroup = _friendsData[indexPath.row];
    //设置数据
    _commentModel = [[CommentModel alloc] init];
    _commentModel.image = @"touxiang";
    _commentModel.name = @"宋老师";
    _commentModel.time = @"2016-01-25 12:00";
    _commentModel.content = rootGroup.name;
    _commentModel.commentArray = rootGroup.friends;
    _commentModel.indexPath = indexPath;
    _commentModel.opened = rootGroup.opened;
    commentCell.message = _commentModel;
    _cellHeight = commentCell.cellHeight;
    return commentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击cell");
}

//内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([textView.text length]>4000) {
        return NO;
    }
    if([textView.text length]==4000) {
        if(![text isEqualToString:@"\b"])
            return NO;
    }
    return YES;
}

//刷新评论
- (void)displayAllComment:(NSIndexPath *)indexPath {
    LectureRootGroupModel *rootGroup = _friendsData[indexPath.row];
    rootGroup.opened = YES;
    [_commentTableView reloadData];
    NSLog(@"重新刷新");
}

#pragma -mark LectureNetCoreDelegate
//返回课程详情数据
- (void)postBigLessonFindBigLessionDetail:(LectureDetailModel *)model isSuccess:(BOOL)isSuccess
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!isSuccess) {
            NSLog(@"获取详情失败");
            return;
        }
        
        if (model == nil) {
            NSLog(@"暂无数据");
        }else{
            self.detailModel = model;
            _headerView.detailModel = model;
            [self.commentTableView beginUpdates];
            [self.commentTableView setTableHeaderView:_headerView];
            [self.commentTableView endUpdates];
        }
    });
}

#pragma -mark LectureNetCoreDelegate
//返回收藏
- (void)postBigLessonCollectWithString:(NSString *)string isSuccess:(BOOL)isSuccess {
    
    if ([string isEqualToString:@"0"]) {
        NSLog(@"收藏失败");
    }else if ([string isEqualToString:@"2"]){
        _subjectCollectBtn.selected = YES;
        NSLog(@"该课程已收藏");
    }else{
        NSLog(@"收藏成功");
        _subjectCollectBtn.selected = YES;
    }
}

//删除收藏返回
- (void)actionBigLessonDelCollect:(BOOL)isSuccess
{
    if (isSuccess) {
        NSLog(@"删除收藏成功");
        _subjectCollectBtn.selected = NO;
    }else{
        NSLog(@"删除收藏失败");

    }
}

- (UIButton *)shelterView {
    if (!_shelterView) {
        _shelterView = [UIButton buttonWithType:UIButtonTypeCustom];
        _shelterView.frame = self.bounds;
        _shelterView.alpha = 0.5;
        _shelterView.backgroundColor = [UIColor blackColor];
        [_shelterView addTarget:self action:@selector(endTextViewEditClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_shelterView];
        [self insertSubview:_shelterView belowSubview:_inputView];
    }
    return _shelterView;
}

//取消遮挡层
- (void)endTextViewEditClick {
    __weak __typeof(self) weakSelf = self;

    _shelterView.hidden = YES;
    [_inputView.inputText resignFirstResponder];
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.commentTableView.mas_bottom);
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    }];
}


@end
