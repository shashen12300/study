//
//  AnswerViewController.m
//  study
//
//  Created by mijibao on 16/1/15.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AnswerViewController.h"
#import "ProblemDetailViewController.h"
#import "JZLSegmentControl.h"
#import "GradeAndSubjectModel.h"
#import "PopMenuView.h"
#import "LXActionSheet.h"
#import "AnswerTableViewCell.h"
#import <Masonry/Masonry.h>
#import "QuestionModel.h"
#import "MsgSummaryManage.h"
#import <MJRefresh/MJRefresh.h>
#import "HJAlertView.h"
@interface AnswerViewController ()<UITableViewDelegate,UITableViewDataSource,JZLSegmentControlDelegate,PopMenuViewDelegate>{
    NSString *_tempGrade;//年级
    NSString *_tempObject;//课程
    BOOL _isTeacher;//是否为老师  no 学生
}
@property (nonatomic, strong) UITableView *chatListview;//问题列表
@property (nonatomic, strong) JZLSegmentControl *segmentControl;  //分段控制器
@property (nonatomic, strong) PopMenuView *popMenuView;           //二级控制器
@property (nonatomic, strong) NSMutableArray *gradeList;          // 年级列表
@property (nonatomic, strong) NSMutableDictionary *subjectList;   // 课程列表
@property (nonatomic, strong) UIView *shelterView;                //遮挡层
@property (nonatomic, strong) LXActionSheet *actionSheet;          //弹窗
@property (nonatomic, strong) NSMutableArray *questionArray;//问题数组
@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionArray = [NSMutableArray array];
    // 获取年级和课程列表
    for (GradeAndSubjectModel *model in [[SharedObject sharedObject] GradeAndSubjectList]) {
        [self.gradeList addObject:model.gradeStr];
        [self.subjectList setObject:model forKey:model.gradeStr];
    }
    if ([[UserInfoList loginUserType] isEqualToString:@"S"]){
        _isTeacher = NO;
    }else
        _isTeacher = YES;
    [self layoutNavigation];
    [self layoutTableView];
    [self setupSelectView];
    [self.chatListview.mj_header beginRefreshing];
    
    //问题被抢答
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionToResponder:) name:kResponderNotification object:nil];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)layoutNavigation{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    if (!_isTeacher) {
        UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 18, 18);
        [btn addTarget:self action:@selector(askQuestionsToDetail) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"ask_questions"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
}
//分段选择器
- (void)setupSelectView{
    if (_isTeacher) {
        _segmentControl = [[JZLSegmentControl alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 42) titles:@[@"智能排序",@"筛选"]];
    }else{
        _segmentControl = [[JZLSegmentControl alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 42) titles:@[@"年级",@"学科"]];
    }
    _segmentControl.segmentDelegate = self;
    [self.view addSubview:_segmentControl];
}
- (void)layoutTableView{
    self.chatListview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.chatListview.delegate = self;
    self.chatListview.dataSource = self;
    self.chatListview.frame = CGRectMake(0, 42, Main_Width, Main_Height - 42 - 64);
    self.chatListview.backgroundColor = RGBCOLOR(225, 226, 234);
    self.chatListview.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_isTeacher) {
        self.chatListview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestNewquetionDataWithTag:@"D"];
        }];
        self.chatListview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            [self requestNewquetionDataWithTag:@"U"];
        }];
    }else{
        self.chatListview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.questionArray = [[MsgSummaryManage shareInstance] getMsgSummaryList:[JZCommon queryLoginUserId]];
            [self.chatListview reloadData];
            [self.chatListview.mj_header endRefreshing];
        }];
    }
    
    [self.view addSubview:self.chatListview];
}
// - getter
- (NSMutableArray *)gradeList
{
    if (!_gradeList) {
        _gradeList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _gradeList;
}

- (NSMutableDictionary *)subjectList
{
    if (!_subjectList) {
        _subjectList = [[NSMutableDictionary alloc] init];
    }
    return _subjectList;
}
//跳转至突出问题界面
- (void)askQuestionsToDetail{
    if (_tempObject) { // 学科
        _segmentControl.selectedButton.selected = NO;
        _popMenuView.hidden = YES;
        if (_shelterView) {
            [_shelterView removeFromSuperview];
        }
        ProblemDetailViewController *problemDetail = [[ProblemDetailViewController alloc] init];
        problemDetail.tempGrade = _tempGrade;
        problemDetail.tempObject = _tempObject;
        problemDetail.questionType = QuestionTypeSubmit;
        problemDetail.questionId = @"100";
        problemDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:problemDetail animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择\n年级学科" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
}
#pragma mark - tabel代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (_isTeacher) {
        QuestionModel *model = self.questionArray[indexPath.row];
        cell.contentLabel.text = [model.pictureurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIImage *cellimage = [UIImage imageNamed:model.subject];
        if (cellimage) {
            cell.iconimage.image = [UIImage imageNamed:model.subject];
        }else{
           cell.iconimage.image = [UIImage imageNamed:@"answer_icon"];
        }
    }else{
        MsgSummary *msg = self.questionArray[indexPath.row];
        cell.contentLabel.text = [msg.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.iconimage.image = [UIImage imageNamed:msg.subjects];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)questionCanAnswer:(QuestionModel *)model {
    ProblemDetailViewController *problemDetail = [[ProblemDetailViewController alloc] init];
    problemDetail.hidesBottomBarWhenPushed = YES;
    model.content = [model.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:[model.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    problemDetail.questionData = dataArr;
    problemDetail.questionType = QuestionTypeReview;
    problemDetail.questionId = [NSString stringWithFormat:@"%@",model.Id];
    problemDetail.chatId = [NSString stringWithFormat:@"%@",model.userId];
    problemDetail.studyID = [NSString stringWithFormat:@"%@",model.userId];
    problemDetail.teacherId = [NSString stringWithFormat:@"%@",model.teacherId];
    if ([model.teacherId isEqualToString:[JZCommon queryLoginUserId]]) {
        problemDetail.questionType = QuestionTypeEnd;
    }
    problemDetail.tempGrade = [model.grade stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    problemDetail.tempObject = [model.subject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    problemDetail.answerSuccess = ^{
        model.teacherId = [JZCommon queryLoginUserId];
    };
    [self.navigationController pushViewController:problemDetail animated:YES];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isTeacher) {
        QuestionModel *model = self.questionArray[indexPath.row];
        if ([model.teacherId isEqualToString:[JZCommon queryLoginUserId]]) {
            [self questionCanAnswer:model];
        }else if (model.teacherId.length == 0 ){
            //抢答
//            [[HJAlertView new] showAlertViewWithContent:@"有老师正在阅读" cancelBtnTitle:@"等待" otherBtnTitle:@"放弃" isAutoHidden:NO selectBlock:^(NSInteger index) {
//                if (index == 0) {
//                    [[HJAlertView new] showAlertViewWithContent:@"等待中..." cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:NO selectBlock:nil];
//                }else{
                    [self questionCanAnswer:model];
//                }
//            }];
        }else{
            [[HJAlertView new] showAlertViewWithContent:@"已被抢答" cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:YES selectBlock:nil];
        }
    }else{
         MsgSummary *msg = self.questionArray[indexPath.row];
        if (_tempObject || ![msg.msgid isEqualToString:@"100"]) { // 学科
            ProblemDetailViewController *problemDetail = [[ProblemDetailViewController alloc] init];
            problemDetail.hidesBottomBarWhenPushed = YES;
            problemDetail.questionType = QuestionTypeEnd;
            problemDetail.tempGrade = _tempGrade;
            problemDetail.tempObject = _tempObject;
            problemDetail.chatId = msg.chatid;
            problemDetail.teacherId = msg.teacherID;
            problemDetail.tempGrade = msg.grade;
            problemDetail.tempObject = msg.subjects;
            problemDetail.questionId = [NSString stringWithFormat:@"%@",msg.msgid];
            [self.navigationController pushViewController:problemDetail animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择\n年级学科" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
#pragma mark - JZLSegmentControlDelegate Methods
- (void)segmentControl:(JZLSegmentControl *)segmentControl didselected:(NSString *)title isSelected:(BOOL)selected{
    NSArray *popList = self.gradeList;
    NSString *gradeName = _tempGrade;
    if ([title isEqualToString:@"学科"]) {
        if (gradeName) { // 年级
            popList = [[self.subjectList objectForKey:gradeName] subjects];
        } else {
            segmentControl.selectedButton.selected = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择\n年级" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    //弹出列表菜单
    if (!_popMenuView) {
        PopMenuView *popMenuView = [[PopMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentControl.frame)+1, Main_Width,148)];
        popMenuView.delegate = self;
        popMenuView.isAnswer = YES;
        [self.view addSubview:popMenuView];
        _popMenuView = popMenuView;
        
    }
    [_popMenuView popMenuViewWithTitle:title popList:popList];
    if (selected) {
        _popMenuView.hidden = NO;
        [_shelterView removeFromSuperview];
        //创建遮挡层
        UIView *shelterView = [[UIView alloc] init];
        shelterView.backgroundColor = [UIColor blackColor];
        shelterView.alpha = 0.5;
        shelterView.tag = 10;
        _shelterView = shelterView;
        [self.view.window addSubview:shelterView];
        __weak __typeof(self)weakSelf  = self;
        [_shelterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.popMenuView.mas_bottom);
            make.left.bottom.right.mas_equalTo(0);
        }];
        //添加手势
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleRecognizer.numberOfTapsRequired = 1;
        singleRecognizer.numberOfTouchesRequired = 1;
        [_shelterView addGestureRecognizer:singleRecognizer];
        
        
    }else {
        _popMenuView.hidden = YES;
        if (_shelterView) {
            [_shelterView removeFromSuperview];
        }
    }
}

// 单击遮挡层触发事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender {
    [_shelterView removeFromSuperview];
    _popMenuView.hidden = YES;
    _segmentControl.selectedButton.selected = NO;
    NSLog(@"请求刷新");
    //    [self requestData];
//    [self filtrateWithGradeAndObject];//筛选排序
}
#pragma -mark PopMenuViewDelegate
- (void)popMenuView:(PopMenuView *)popMenuView didSelected:(NSString *)title popTitle:(NSString *)popTitle {
    if ([popTitle isEqualToString:@"年级"]) {
        _tempGrade = title;
    }
    else if ([popTitle isEqualToString:@"学科"]) {
        _tempObject = title;
    }else if ([popTitle isEqualToString:@"智能排序"]){
        
    }else if ([popTitle isEqualToString:@"筛选"]){
        
    }
}
#pragma mark - 网络请求
//刷新 D=下拉获取最新的，传入最后一条的id，U=上拉获取下一页
- (void)requestNewquetionDataWithTag:(NSString *)tag{
    NSString *questionID = @"0";
    if (self.questionArray.count > 0) {
//        questionID = 
    }else{
        tag = @"0";
    }
    NSString *result =[NSString stringWithFormat:@"http://%@:%@/studyManager/instantAnswerAction/queryAllQuestionByTC.action", [OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    [manager GET:result parameters:@{@"id":questionID,@"tag":tag} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.chatListview.mj_header endRefreshing];
        [self.chatListview.mj_footer endRefreshing];
        if ([responseObject length] > 4) {
            NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary * dic in dataArr) {
                QuestionModel *model = [QuestionModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.questionArray addObject:model];
            }
            [self.chatListview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.chatListview.mj_header endRefreshing];
        [self.chatListview.mj_footer endRefreshing];
    }];
}
#pragma mark - 老师解答问题
- (void)questionToResponder:(NSNotification *)notifi{
    ChatMsgDTO *msg = (ChatMsgDTO *)notifi.object;
    NSString *chatId = [NSString stringWithFormat:@"%@",msg.fromuid];
    for (MsgSummary *chatmsg in self.questionArray) {
        if ([chatmsg.msgid isEqualToString:msg.questionID]) {
            chatmsg.chatid = chatId;
            chatmsg.teacherID = msg.content;
        }
    }
    [[HJAlertView new] showAlertViewWithContent:@"匹配到老师" cancelBtnTitle:nil otherBtnTitle:nil isAutoHidden:NO selectBlock:nil];
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
