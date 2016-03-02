//
//  KnowledgeViewController.m
//  study
//
//  Created by mijibao on 16/1/15.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "SearchViewController.h"
#import "JZLSegmentControl.h"
#import "GradeAndSubjectModel.h"
#import "PopMenuView.h"
#import <MJRefresh.h>
#import "LectureModel.h"
#import "LectureNetCore.h"
#import "Lecture_saveModel.h"
#import "LXActionSheet.h"
#import "KnowledgeCollectionViewCell.h"
#import "KnowledgeDetailViewController.h"
#import "UploadViewController.h"
#import "OnlinePaymentViewController.h"
#import <Masonry.h>

static CGFloat CELL_ROW = 2;
static CGFloat CELL_MARGIN = 11;
static NSString *const _cellIdentifier = @"cell";

@interface KnowledgeViewController ()<JZLSegmentControlDelegate,PopMenuViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,LectureNetCoreDelegate,LXActionSheetDelegate,UISearchBarDelegate,SearchViewControllerDelegate>
{
    NSString *_tempGrade;//年级
    NSString *_tempObject;//课程
    UICollectionView *_collectionView;  //collection
    NSMutableArray *_dataArray;
    NSMutableArray *_sourceArray;  //数据

}

@property (nonatomic, strong) JZLSegmentControl *segmentControl;  //分段控制器
@property (nonatomic, strong) PopMenuView *popMenuView;           //二级控制器
@property (nonatomic, strong) NSMutableArray *gradeList;          // 年级列表
@property (nonatomic, strong) NSMutableDictionary *subjectList;   // 课程列表
@property (nonatomic, strong) UIView *shelterView;                //遮挡层
@property (nonatomic, strong) LXActionSheet *actionSheet;          //弹窗
@property (nonatomic, assign) BOOL refresh;  //更新


@end

@implementation KnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatViewUI];
}

- (instancetype)init
{
    if (self = [super init]) {
        // 获取年级和课程列表
        for (GradeAndSubjectModel *model in [[SharedObject sharedObject] GradeAndSubjectList]) {
            [self.gradeList addObject:model.gradeStr];
            [self.subjectList setObject:model forKey:model.gradeStr];
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self creatNavigationUI];
    self.tabBarController.tabBar.hidden = NO;
    if (_refresh) {
        _refresh = NO;
        return;
    }
    [_collectionView.mj_header beginRefreshing];
    if ([self isBlankString:_tempGrade]&&[self isBlankString:_tempObject]) {
        [self requestAllClass];
    }else{
        [self requestData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if ([_collectionView.mj_header state] == MJRefreshStateRefreshing) {
        [_collectionView.mj_header endRefreshing];
    }
    
}

//导航栏设置
- (void)creatNavigationUI {
    self.title = @"重点知识";
    //设置导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //设置导航栏按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置导航栏背景
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    //设置导航栏右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtnClick)];
    //设置导航栏左按钮
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(-10, 0, 30, 32);
    [uploadBtn setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *uploadButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uploadBtn];
    self.navigationItem.leftBarButtonItem = uploadButtonItem;
    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -10;
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, uploadButtonItem, nil];
}

//创建视图UI
- (void)creatViewUI {
    [self setupSelectView];
    [self createContent];

}

//分段选择器
- (void)setupSelectView{
    JZLSegmentControl *segmentControl = [[JZLSegmentControl alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 42) titles:@[@"年级",@"学科",@"智能排序",@"筛选"]];
    segmentControl.segmentDelegate = self;
    [self.view addSubview:segmentControl];
    _segmentControl = segmentControl;
}

//课程列表
-(void)createContent
{
    CGFloat cellW = (Main_Width - CELL_MARGIN * (CELL_ROW +1)) / CELL_ROW;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, 95);
    layout.minimumInteritemSpacing = CELL_MARGIN;
    layout.minimumLineSpacing = CELL_MARGIN;
    layout.sectionInset = UIEdgeInsetsMake(11, 11, 11, 11);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MaxY(_segmentControl), Main_Width, Main_Height) collectionViewLayout:layout];
    _collectionView.backgroundColor = RGBVCOLOR(0xdcdcdc);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[KnowledgeCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadData)];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_segmentControl.bottom);
        make.bottom.mas_equalTo(-44);
    }];
    _dataArray = [[NSMutableArray alloc]init];
}

#pragma -mark UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_sourceArray.count == 0) {
        return nil;
    }
    LectureModel *aLectureModel = [_sourceArray objectAtIndex:indexPath.row];
    KnowledgeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"创建Cell");
        cell = [[KnowledgeCollectionViewCell alloc] init];
    }
    [cell configLectrueTableViewCell:aLectureModel];
    return cell;
}

#pragma -mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LectureModel *model = [_sourceArray objectAtIndex:indexPath.row];
    
    if ([model.clickcount integerValue]>0) {
        NSLog(@"支付");
        OnlinePaymentViewController *opVc = [[OnlinePaymentViewController alloc] init];
        opVc.costMoney = model.clickcount;
        [self.navigationController pushViewController:opVc animated:YES];
    }else {
    
    KnowledgeDetailViewController *knowledgeDetailVC = [[KnowledgeDetailViewController alloc] init];
        
        if (model.lecrureid) {
            knowledgeDetailVC.lecrureid = model.lecrureid;
            knowledgeDetailVC.titleName = model.title;
            [self.navigationController pushViewController:knowledgeDetailVC animated:YES];
        }
    }
}

#pragma mark - JZLSegmentControlDelegate Methods
- (void)segmentControl:(JZLSegmentControl *)segmentControl button:(UIButton *)button {
    NSArray *popList = self.gradeList;
    NSString *gradeName = _tempGrade;
    if (button.tag == baseTag + 1) {
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
        [self.view addSubview:popMenuView];
        _popMenuView = popMenuView;
        
    }
    [_popMenuView popMenuViewWithButton:button popList:popList];
    if (button.selected) {
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
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
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
////弃用
//- (void)segmentControl:(JZLSegmentControl *)segmentControl didselected:(NSString *)title isSelected:(BOOL)selected{
//    NSArray *popList = self.gradeList;
//    NSString *gradeName = _tempGrade;
//    if ([title isEqualToString:@"学科"]) {
//        if (gradeName) { // 年级
//            popList = [[self.subjectList objectForKey:gradeName] subjects];
//        } else {
//            segmentControl.selectedButton.selected = NO;
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择\n年级" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertView show];
//            return;
//        }
//    }
//    
//    //弹出列表菜单
//    if (!_popMenuView) {
//        PopMenuView *popMenuView = [[PopMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentControl.frame)+1, Main_Width,148)];
//        popMenuView.delegate = self;
//        [self.view addSubview:popMenuView];
//        _popMenuView = popMenuView;
//
//    }
//    [_popMenuView popMenuViewWithTitle:title popList:popList];
//    if (selected) {
//        _popMenuView.hidden = NO;
//        [_shelterView removeFromSuperview];
//        //创建遮挡层
//        UIView *shelterView = [[UIView alloc] init];
//        shelterView.backgroundColor = [UIColor blackColor];
//        shelterView.alpha = 0.5;
//        shelterView.tag = 10;
//        _shelterView = shelterView;
//        [self.view.window addSubview:shelterView];
//        __weak __typeof(self)weakSelf  = self;
//        [_shelterView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(weakSelf.popMenuView.mas_bottom);
//            make.left.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//        }];
//        //添加手势
//        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
//        singleRecognizer.numberOfTapsRequired = 1;
//        singleRecognizer.numberOfTouchesRequired = 1;
//        [_shelterView addGestureRecognizer:singleRecognizer];
//        
//
//    }else {
//        _popMenuView.hidden = YES;
//        if (_shelterView) {
//            [_shelterView removeFromSuperview];
//        }
//    }
//}

//刷新
- (void)refreshLoadData
{
    if (![self isBlankString:_tempGrade] || ![self isBlankString:_tempObject]) {
        [self requestData];
    }else{
        [self requestAllClass];
    }
}

//根据年级查询所有科目信息
-(void)requestData
{
    if ([_collectionView.mj_header state]== MJRefreshStateRefreshing) {
        [_collectionView.mj_header endRefreshing];
    }
    if ([_tempGrade isEqualToString:@""] || _tempGrade == nil) {
        return;
    }
    
    if ([_tempObject isEqualToString:@""] || _tempObject == nil ||[_tempGrade isEqualToString:@""] || _tempGrade == nil) {
        [self filtrateWithGradeAndObject];
        [_collectionView reloadData];
        return;
    }else{
        [_sourceArray removeAllObjects];
        [_collectionView reloadData];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LectureNetCore *core = [[LectureNetCore alloc] init];
        core.del = self;
        [core requestBigLessonWithGrade:_tempGrade withSubject:_tempObject];
    });
}

//请求所有的课程
- (void)requestAllClass
{
    if ([_collectionView.mj_header state]== MJRefreshStateRefreshing) {
        [_collectionView.mj_header endRefreshing];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LectureNetCore *core = [[LectureNetCore alloc] init];
        core.del = self;
        [core requestBigLessonAction];
    });
}

//筛选课程
- (void)filtrateWithGradeAndObject
{
    [_sourceArray removeAllObjects];
    
    if (![self isBlankString:_tempGrade]) {
        if (![self isBlankString:_tempObject]) {
            for (NSInteger i = 0; i < _dataArray.count; i ++) {
                LectureModel *model = _dataArray[i];
                if ([model.grade isEqualToString:_tempGrade] && [model.subject isEqualToString:_tempObject]) {
                    [_sourceArray addObject:model];
                }
            }
        }else{
            for (NSInteger i = 0; i < _dataArray.count; i ++) {
                LectureModel *model = _dataArray[i];
                if ([model.grade isEqualToString:_tempGrade]) {
                    [_sourceArray addObject:model];
                }
            }
        }
    }else{
        for (NSInteger i = 0; i < _dataArray.count; i ++) {
            LectureModel *model = _dataArray[i];
            [_sourceArray addObject:model];
        }
    }
    if (_sourceArray.count==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不存在所选课程" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
        [_collectionView reloadData];

}
//搜索课程
- (void)searchLecture:(NSString *)title {
    [_sourceArray removeAllObjects];
    if (![self isBlankString:_tempGrade]) {
        if (![self isBlankString:_tempObject]) {
            for (NSInteger i = 0; i < _dataArray.count; i ++) {
                LectureModel *model = _dataArray[i];
                if ([model.grade isEqualToString:_tempGrade] && [model.subject isEqualToString:_tempObject]) {
                    //判断roadTitleLab.text 是否含有qingjoin
                    [self lectureModel:model containString:title];
                }
            }
        }else {
            for (NSInteger i = 0; i < _dataArray.count; i ++) {
                LectureModel *model = _dataArray[i];
                if ([model.grade isEqualToString:_tempGrade]) {
                    //判断roadTitleLab.text 是否含有qingjoin
                    [self lectureModel:model containString:title];
                }
            }
        }
        
    }else{
        for (NSInteger i = 0; i < _dataArray.count; i ++) {
            LectureModel *model = _dataArray[i];
            //判断roadTitleLab.text 是否含有qingjoin
            [self lectureModel:model containString:title];
        }
    }
    
    [_collectionView reloadData];
}

- (void)lectureModel:(LectureModel *)model containString:(NSString *)string {
    //判断roadTitleLab.text 是否含有qingjoin
    if ([self isBlankString:model.title] ) {
        return;
    }
    if([model.title rangeOfString:string].location !=NSNotFound)
    {
        NSLog(@"yes");
        [_sourceArray addObject:model];
        
    }
    else
    {
        NSLog(@"no");
    }

}

// 单击遮挡层触发事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender {
    [_shelterView removeFromSuperview];
    _popMenuView.hidden = YES;
    _segmentControl.selectedButton.selected = NO;
    NSLog(@"请求刷新");
//    [self requestData];
    [self filtrateWithGradeAndObject];//筛选排序
}

#pragma -mark PopMenuViewDelegate
- (void)popMenuView:(PopMenuView *)popMenuView didSelected:(NSString *)title popButton:(UIButton *)button {
    button.titleLabel.text = title;
    NSArray *popTitles = @[@"年级",@"学科",@"智能排序",@"筛选"];
    if (button.tag == 10) {
        _tempGrade = title;
    }else if (button.tag == 11) {
        _tempObject = title;
    }

    if ([self isBlankString:title]) {
        title = popTitles[button.tag - 10];
    }
    
    if (title.length>4) {
        title = [title substringToIndex:4];
    }
    [button setTitle:title forState:UIControlStateNormal];
    CGFloat imageWidth = button.imageView.frame.size.width;
    CGFloat labelWidth = button.titleLabel.frame.size.width;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 7, 0, -labelWidth);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - 7, 0, imageWidth);

}
//弃用
//- (void)popMenuView:(PopMenuView *)popMenuView didSelected:(NSString *)title popTitle:(NSString *)popTitle {
//    if ([popTitle isEqualToString:@"年级"]) {
//        _tempGrade = title;
//    }
//    else if ([popTitle isEqualToString:@"学科"]) {
//        _tempObject = title;
//    }
//}

#pragma mark- LectureNetCoreDelegate
- (void)postBigLessonArray:(NSMutableArray *)mArray withRequest:(BOOL)isSuccess
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestBackWithArray:mArray withIsSuccess:isSuccess isA:YES];
    });
}

- (void)postBigLessonGradeBackSubject:(NSMutableArray *)mArray withRequest:(BOOL)isSuccess
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestBackWithArray:mArray withIsSuccess:isSuccess isA:NO];
    });
}

//array model数组；isSuccess 是否请求成功,isA是不是请求的全部课程
- (void)requestBackWithArray:(NSMutableArray *)array withIsSuccess:(BOOL)isSuccess isA:(BOOL)a
{
    [_collectionView.mj_header endRefreshing];
    if (!isSuccess) {
        //[self promptMessage:@"请检查你的网络状况"];
        return;
    }
    
    if (array.count != 0) {
        if (_dataArray != nil && _dataArray.count != 0) {
            [_dataArray removeAllObjects];
        }
        if (a) {
            _dataArray = [NSMutableArray arrayWithArray:array];
        }
        _sourceArray = [NSMutableArray arrayWithArray:array];
        [_collectionView reloadData];
    }else{
        [self promptMessage:@"抱歉,该课程还未开通"];
    }
}

// 上传
- (void)uploadBtnClick {
    NSLog(@"上传");
    //判断分栏选择器是否展开
    if (_segmentControl.selectedButton.selected) {
        [_shelterView removeFromSuperview];
        _popMenuView.hidden = YES;
        _segmentControl.selectedButton.selected = NO;
    }
    LXActionSheet *myActionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"上传视频",@"上传文档"]];
    [myActionSheet showInView:self.view];
}

// 搜索
- (void)searchBtnClick {
    SearchViewController *sVc = [[SearchViewController alloc] init];
    sVc.delegate = self;
    sVc.dataArray = _sourceArray;
    [self.navigationController pushViewController:sVc animated:YES];
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Width - 70, 30)];
//    searchBar.placeholder = @"搜索";
//    searchBar.delegate = self;
//    searchBar.keyboardType = UIKeyboardTypeWebSearch;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
//    UIButton *rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 35, 30);
//    [rightBtn setTitleColor:lightColor forState:UIControlStateNormal];
//    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [rightBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.title = @"";

}
// 取消
- (void)cancelBtnClick {
    [self creatNavigationUI];
}

#pragma -mark SearchViewControllerDelegate
- (void)searchLectureTitle:(NSString *)title {
    _refresh = YES;
    [self searchLecture:title];
}

#pragma -mark search
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [searchBar resignFirstResponder];
    }
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self searchLecture:searchBar.text];
}

#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)lxactionSheet didClickOnButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",(int)buttonIndex);
        switch (buttonIndex)
        {
            case 0:
            {
                UploadViewController *uvc = [[UploadViewController alloc] init];
                [self.navigationController pushViewController:uvc animated:YES];
            }
                break;
            case 1:  //打开本地相册
//                [self JumpToGallery:PickerViewShowStatusSavePhotos];
                
                break;
        }

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
