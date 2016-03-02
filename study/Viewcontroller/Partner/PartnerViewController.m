//
//  PartnerViewController.m
//  study
//
//  Created by mijibao on 15/8/26.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PartnerViewController.h"
#import "PersonHistoryViewController.h"  //个人发布历史页
#import "PartnerViewCell.h"
#import "PartnerCore.h"
#import "PartnerKeyboardView.h"
#import "FaceView.h"
#import "PartnerAllModel.h"
#import "PartnerCommentModel.h"
#import "PartnerPraiseModel.h"
#import "XHImageViewer.h"
#import "UIImageView+XHURLDownload.h"
#import "PartnerHeaderView.h"
#import "SeletPicViewController.h"
#import "UploadFileCore.h"
#import "PartnerPublishViewController.h"
#import "PartnerManaer.h"
#import "PartnerPraiseManager.h"
#import "PartnerCommentManager.h"
#import "PartnerFirstHeaderView.h"
#import "MJRefresh.h"
#import "MiddleAlertViewController.h"
#import "BottomAlertViewController.h"
#import "SeletPicViewController.h"

#define UIColorFromRGBPar(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:0.96]


@interface PartnerViewController ()<PartnerPublishViewControllerDelegate, PartnerViewCellDelegate, PartnerCoreDelegate, PartnerKeyboardViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XHImageViewerDelegate, PartnerHeaderViewDelegate, UploadDelegate, UIScrollViewDelegate, PartnerFirstHeaderViewDelegate, SeletPicViewControllerDelegate>

@property (nonatomic, strong) PartnerFirstHeaderView *firstheaderView; // 第一个headerview
@property (nonatomic, strong) UITableView *tableView;                  // tableview
@property (nonatomic, strong) PartnerKeyboardView *keyboardView;       // 键盘view
@property (nonatomic, strong) FaceView *emojiView;                     // 表情view
@property (nonatomic, strong) NSMutableArray *dataArray;               // 数据数组
@property (nonatomic, strong) NSMutableArray *isShowAllContentArray;   // 内容是否展开  1:展开   0:未展开
@property (nonatomic, strong) NSIndexPath *existingIndexPath;          // 记录被点击评论的位置
@property (nonatomic, strong) XHImageViewer *imageViewer;              // 点击展示图片view
@property (nonatomic, assign) BOOL isPopup;                            // 是否弹出键盘
@property (nonatomic, assign) BOOL isChangeBackImage;                  // 是否更换背景

@end

@implementation PartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.isShowAllContentArray = [NSMutableArray new];
    
    self.dataArray = [[NSMutableArray alloc] initWithArray:[[PartnerManaer shareInstance] gainDataArray]];
    for (int i = 0; i < self.dataArray.count; i ++) {
        [self.isShowAllContentArray addObject:@"0"];
    }

    if (self.dataArray.count == 0) {
        [self creatHudWithText:@"加载中..."];
    }
    [self setupSubviews];
    [self setupNav];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = NO;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - inner methods
// 导航栏设置
- (void)setupNav {
    [self setNavigationTitle:@"伙伴圈"];
    
    UIBarButtonItem *rightBarButton = [self addItemWithTitle:@"" imageName:@"partner_takePhoto" target:self action:@selector(handleRightBarButton)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
}

- (void)handleRightBarButton {
    [self resignResponder];
    
    BottomAlertViewController *alert = [[BottomAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.tabBarController.view];
    [alert addActionWithString:@"拍照"];
    [alert addActionWithString:@"发表文字"];
    [alert addActionWithString:@"从本地相册选择"];
    [self presentViewController:alert animated:NO completion:NULL];
    
    __weak PartnerViewController *partnerVC = self;
    alert.tapBlock = ^(NSInteger section){
        switch (section) {
            case 100:
            {
                __strong __typeof(partnerVC)strongSelf = partnerVC;
                strongSelf.isChangeBackImage = NO;
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = YES;
                    imagePicker.delegate = partnerVC;
                    
                    [partnerVC presentViewController:imagePicker animated:YES completion:NULL];
                }else {
                    PromptMessage(@"相机不能用");
                }
            }
                break;
            case 101:
            {
                PartnerPublishViewController *writeVC = [[PartnerPublishViewController alloc] init];
                writeVC.imageArray = [NSMutableArray new];
                writeVC.delegate = partnerVC;
                [partnerVC.navigationController pushViewController:writeVC animated:NO];
            }
                break;
            case 102:
            {
                SeletPicViewController *picVC = [[SeletPicViewController alloc] init];
                picVC.delegate = partnerVC;
                picVC.maxSelext = 9;
                [partnerVC.navigationController pushViewController:picVC animated:YES];
            }
                break;
            default:
                break;
        }
    };
}

// 视图
- (void)setupSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    
    PartnerCore *core = [[PartnerCore alloc] init];
    core.delegate = self;
    [core partnerUserId:[[UserInfoList loginUserId] integerValue] FeedId:0 tag:@"0" type:@"A" withFeedRefresh:FeedRefreshNone];
    
    //表情
    self.emojiView = [[FaceView alloc] initWithFrame:CGRectMake(0, Main_Height - 110, Main_Width, 110)];
    [self.view addSubview:self.emojiView];
    self.emojiView.hidden = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addHeader)];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(addFooter)];
}

- (void)addHeader {
    PartnerCore *core = [PartnerCore new];
    core.delegate = self;
    [core partnerUserId:[[UserInfoList loginUserId] integerValue] FeedId:0 tag:@"0" type:@"A" withFeedRefresh:FeedRefreshUp];
}

- (void)addFooter {
    PartnerAllModel *model = [self.dataArray lastObject];
    PartnerCore *core = [PartnerCore new];
    core.delegate = self;
    [core partnerUserId:[[UserInfoList loginUserId] integerValue] FeedId:model.model.feedId tag:@"D" type:@"A" withFeedRefresh:FeedRefreshDown];
}

// 键盘
- (void)setupKeyboard {
    self.keyboardView = [[PartnerKeyboardView alloc] initWithFrame:CGRectMake(0, Main_Height - widget_width(100), Main_Width, widget_width(100))];
    self.keyboardView.delegate = self;
    [self.view addSubview:self.keyboardView];
    self.isPopup = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardView.frame = CGRectMake(0, Main_Height - widget_width(100), Main_Width, widget_width(100));
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGRect toolViewRect = self.keyboardView.frame;
    toolViewRect.origin.y -= keyboardEndFrame.size.height;
    
    __weak PartnerViewController *selfWeak = self;
    [UIView animateWithDuration:animationDuration animations:^{
        if (selfWeak) {
            [selfWeak.keyboardView setFrame:toolViewRect];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tabBarController.tabBar.hidden = NO;
    self.emojiView.hidden = YES;
    self.keyboardView.frame = CGRectMake(0, Main_Height - widget_width(100), Main_Width, widget_width(100));
}

- (NSString *)sd_commentedId:(NSInteger)Cid withArray:(NSMutableArray *)array {
    NSString *HFnick = [[NSString alloc] init];
    for (PartnerCommentModel *model in array) {
        if (model.commentId == Cid) {
            if (model.userId == [[UserInfoList loginUserId] integerValue]) {
                model.nickname = [UserInfoList loginUserNickname];
            }
            HFnick = model.nickname;
        }
    }
    return HFnick;
}

// 隐藏键盘
- (void)resignResponder {
    [self.keyboardView.inputText resignFirstResponder];
    self.emojiView.hidden = YES;
    self.keyboardView.hidden = YES;
    self.isPopup = NO;
    self.keyboardView.inputText.text = @"";
    self.tabBarController.tabBar.hidden = NO;
    
    [self.keyboardView removeFromSuperview];
}

// 展示键盘
- (void)becomeResponder {
    [self setupKeyboard];
    self.keyboardView.hidden = NO;
    self.emojiView.hidden = YES;
    [self.keyboardView.inputText becomeFirstResponder];
    self.keyboardView.inputText.text = @"";
    self.tabBarController.tabBar.hidden = YES;
}

// 跳到动态界面
- (void)pushToHistoryWithModel:(PartnerAllModel *)model {
    if (model.model.userId == [[UserInfoList loginUserId] intValue]) {
        [self pushMyself];
    }else {
        PersonHistoryViewController *personVC = [[PersonHistoryViewController alloc] initWithPerson:NO];
        personVC.userId = model.model.userId;
        personVC.nickname = model.model.nickname;
        personVC.photo = model.model.photo;
        personVC.picture = model.model.picture;
        personVC.signature = model.model.signature;
        
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

// 跳到动态界面(自己)
- (void)pushMyself {
    PersonHistoryViewController *personVC = [[PersonHistoryViewController alloc] initWithPerson:YES];
    personVC.userId = [[UserInfoList loginUserId] integerValue];
    personVC.nickname = [UserInfoList loginUserNickname];
    personVC.photo = [UserInfoList loginUserPhoto];
    personVC.signature = [UserInfoList loginUserSignature];
    personVC.picture = [UserInfoList loginUserPicture];
    [self.navigationController pushViewController:personVC animated:YES];
}
// 截取当前屏幕图片
- (UIImage*)screenView:(UIView *)view{
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - SeletPicViewControllerDelegate
- (void)selectPicWithImages:(NSArray *)imageArr {
    PartnerPublishViewController *writeVC = [[PartnerPublishViewController alloc] init];
    writeVC.imageArray = (NSMutableArray *)imageArr;
    writeVC.delegate = self;
    [self.navigationController pushViewController:writeVC animated:NO];
}

#pragma mark - PartnerKeyboardViewDelegate
- (void)clickSendButton:(NSString *)text {
    [self resignResponder];
    
    PartnerCore *core = [[PartnerCore alloc] init];
    core.delegate = self;
    
    if (self.existingIndexPath) {
        PartnerAllModel *allModel = self.dataArray[self.existingIndexPath.section - 1];
        if (self.existingIndexPath.row == -1) {
            [core commentId:0 withFeedId:allModel.model.feedId withCommentedId:0 withCommentDetail:text withIndexPath:self.existingIndexPath];
        }else {
            PartnerCommentModel *model = allModel.userComment[self.existingIndexPath.row];
            [core commentId:0 withFeedId:allModel.model.feedId withCommentedId:model.commentId withCommentDetail:text withIndexPath:self.existingIndexPath];
        }
    }
}

- (void)showEmojiView:(BOOL)toShowEmojiView {
    self.emojiView.hidden = !toShowEmojiView;
    if (toShowEmojiView == YES) {
        self.keyboardView.frame = CGRectMake(0, Main_Height - widget_width(100) - 110, Main_Width, widget_width(100));
        self.tabBarController.tabBar.hidden = YES;
    }
}

#pragma mark - PartnerHeaderViewDelegate
- (void)showDelImageSyntonyWithSection:(NSInteger)section {
    [self resignResponder];
    
    MiddleAlertViewController *alert = [[MiddleAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.tabBarController.view];
    [alert reloadTitle:@"确定删除" leftMessage:@"取消" rightMessage:@"确定"];
    [self presentViewController:alert animated:NO completion:NULL];
    
    __weak PartnerViewController *partnerVC = self;
    alert.tapBlock = ^{
        PartnerAllModel *model = self.dataArray[section];
        PartnerCore *core = [[PartnerCore alloc] init];
        core.delegate = partnerVC;
        [core deleteUserFeed:model.model.feedId];
        partnerVC.existingIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    };
}

- (void)pushPersonalHistorySyntonyWithSection:(NSInteger)section {
    [self resignResponder];
    
    [self pushToHistoryWithModel:self.dataArray[section]];
}

- (void)handleShowAllContentSyntonyWithSection:(NSInteger)section {
    [self resignResponder];
    
    if ([self.isShowAllContentArray[section] integerValue] == 0) {
        [self.isShowAllContentArray replaceObjectAtIndex:section withObject:@"1"];
    }else {
        [self.isShowAllContentArray replaceObjectAtIndex:section withObject:@"0"];
    }
    [self.tableView reloadData];
}

- (void)handleCommentSyntonyWithSection:(NSInteger)section withEvent:(UIEvent *)event withBut:(UIButton *)but {
    if (!self.isPopup) {
        [self becomeResponder];
        self.keyboardView.placeholderLabel.text = @"我要说...";
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:section + 1];
        self.existingIndexPath = indexPath;
        
        UITouch* touch = [[event touchesForView:but] anyObject];
        CGPoint rootViewLocation = [touch locationInView:self.view];
        
        CGPoint size = self.tableView.contentOffset;
        
        int height = 0;
        if (size.y + (rootViewLocation.y - CGRectGetMinY(self.keyboardView.frame)) - widget_width(100) + 64 > 0) {
            height = size.y + (rootViewLocation.y - CGRectGetMinY(self.keyboardView.frame)) - widget_width(100) + 64;
        }
        
        __weak PartnerViewController *selfWeak = self;
        [UIView animateWithDuration:0.3 animations:^{
            if (selfWeak) {
                selfWeak.tableView.contentOffset = CGPointMake(size.x, height);
            }
        }];
        self.isPopup = YES;
    }else {
        [self resignResponder];
    }
}

- (void)handlePraiseSyntonyWithSection:(NSInteger)section {
    [self resignResponder];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    PartnerCore *core = [[PartnerCore alloc] init];
    core.delegate = self;
    
    PartnerAllModel *model = self.dataArray[section];
    
    if (model.userPraise.count == 0) {
        [core praiseId:0 withFeedId:model.model.feedId withPraiseType:FeedPraiseAdd withIndexPath:indexPath];
        return;
    }
    
    for (PartnerPraiseModel *praiseModel in model.userPraise) {
        if (praiseModel.userId == [[UserInfoList loginUserId] integerValue]) {
            [core praiseId:praiseModel.praiseId withFeedId:praiseModel.feedId withPraiseType:FeedPraiseDelete withIndexPath:indexPath];
            return;
        }
    }
    
    [core praiseId:0 withFeedId:model.model.feedId withPraiseType:FeedPraiseAdd withIndexPath:indexPath];
}

- (void)showImagesWithImageViews:(NSArray *)imageArr selectedView:(UIImageView *)imageView {
    [self resignResponder];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.imageViewer = [[XHImageViewer alloc] initWithImageViews:imageArr selectedView:imageView];
    self.imageViewer.delegate = self;
    
}
- (void)playWithLectureId:(NSString *)lectureId {
    [self resignResponder];
    NSLog(@"play");
}


#pragma mark - PartnerCoreDelegate
- (void)recomposeImageResult:(BOOL)result {
    [self stopHud];
    if (result) {
        PromptMessage(@"修改成功");
    }else {
        PromptMessage(@"修改失败");
    }
    [self.tableView reloadData];
}

- (void)gainPartnerResult:(BOOL)result withResultArray:(NSArray *)resultArray withFeedRefresh:(FeedRefresh)feedRefresh {
    if (result) {
        switch (feedRefresh) {
            case FeedRefreshNone:
            {
                // 刚进来网络请求时,如果有数据 那么就是缓存数据,网络请求后要被移除
                [self.dataArray removeAllObjects];
                [self.isShowAllContentArray removeAllObjects];
                
                [self.dataArray addObjectsFromArray:resultArray];
                for (int i = 0; i < resultArray.count; i ++) {
                    [self.isShowAllContentArray addObject:@"0"];
                }
            }
                break;
            case FeedRefreshDown:
            {
                if (resultArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.dataArray addObjectsFromArray:resultArray];
                for (int i = 0; i < resultArray.count; i ++) {
                    [self.isShowAllContentArray addObject:@"0"];
                }
            }
                break;
            case FeedRefreshUp:
            {
                if (self.dataArray.count == 0) {
                    [self.dataArray addObjectsFromArray:resultArray];
                    
                    for (int i = 0; i < self.dataArray.count; i ++) {
                        [self.isShowAllContentArray addObject:@"0"];
                    }
                }else {
                    PartnerAllModel *model2 = self.dataArray[0];
                    
                    int number = 0;
                    for (int i = 0; i < resultArray.count; i ++) {
                        PartnerAllModel *model = resultArray[i];
                        
                        if (model.model.feedId == model2.model.feedId) {
                            number = i;
                            break;
                        }
                    }
                    
                    if (number == 0) {
                        [self.tableView.mj_header endRefreshing];
                        [self.tableView.mj_footer endRefreshing];
                        return;
                    }
                    
                    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, number)];
                    
                    NSMutableArray *array = [NSMutableArray new];
                    for (int i = 0; i < number; i ++) {
                        [array addObject:resultArray[i]];
                    }
                    [self.dataArray insertObjects:array atIndexes:set];
                    
                    for (int i = 0; i < number; i ++) {
                        [self.isShowAllContentArray insertObject:@"0" atIndex:0];
                    }
                }
            }
                break;
                
            default:
                break;
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self stopHud];
    }
}

- (void)delPartnerResult:(BOOL)result withFeedId:(NSInteger)feedId {
    if (result) {
        [self.isShowAllContentArray removeObjectAtIndex:self.existingIndexPath.section];
        [self.dataArray removeObjectAtIndex:self.existingIndexPath.section];
        
        [self.tableView reloadData];
        
        [[PartnerManaer shareInstance] delFeedId:feedId];
    }else {
        // 请求出错
        PromptMessage(@"删除失败");
    }
}

- (void)addCommentResult:(BOOL)result withCommentId:(NSInteger)commentId withFeedId:(NSInteger)feedId withCommentedId:(NSInteger)commentedId withCommentDetail:(NSString *)commentDetail withIndexPath:(NSIndexPath *)indexPath {
    if (result) {
        PartnerAllModel *allModel = self.dataArray[indexPath.section - 1];
        
        PartnerCommentModel *model = [[PartnerCommentModel alloc] init];
        model.commentId = commentId;
        model.feedId = feedId;
        model.commentedId = commentedId;
        model.commentDetail = commentDetail;
        model.userId = [[UserInfoList loginUserId] integerValue];
        model.nickname = [UserInfoList loginUserNickname];
        
        // 时间格式 2016-01-05 09:55:13
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *locationString = [dateformatter stringFromDate:senddate];
        model.addTime = locationString;
        
        if (indexPath.row != -1) {
            [allModel.userComment insertObject:model atIndex:indexPath.row + 1];
        }else {
            [allModel.userComment addObject:model];
        }
        
        [[PartnerCommentManager shareInstence] insertWithModel:model];
        
        [self.tableView reloadData];
    }else {
        // 请求出错
        PromptMessage(@"评论失败");
    }
}

- (void)delCommentResult:(BOOL)result withCommentId:(NSInteger)commentId withIndexPath:(NSIndexPath *)indexPath {
    if (result) {
        NSMutableArray *commentArray = [NSMutableArray new];
        NSMutableArray *removeArray = [NSMutableArray new];
        
        PartnerAllModel *allModel = self.dataArray[indexPath.section-1];
        PartnerCommentModel *comModel = allModel.userComment[indexPath.row];
        [commentArray addObject:[NSString stringWithFormat:@"%ld",(long)comModel.commentId]];
        
        [allModel.userComment removeObjectAtIndex:indexPath.row];
        
        for (int i = 0; i < allModel.userComment.count; i ++) {
            PartnerCommentModel *model = allModel.userComment[i];
            
            NSMutableArray *array = [NSMutableArray new];
            for (NSString *str in commentArray) {
                if ([str integerValue] == model.commentedId) {
                    [array addObject:[NSString stringWithFormat:@"%ld",(long)model.commentId]];
                    [removeArray insertObject:[NSString stringWithFormat:@"%d",i] atIndex:0];
                }
            }
            [commentArray addObjectsFromArray:array];
        }
        
        for (int i = 0; i < removeArray.count; i ++) {
            [allModel.userComment removeObjectAtIndex:[removeArray[i] integerValue]];
        }
        
        for (NSString *str in commentArray) {
            [[PartnerCommentManager shareInstence] delCommentId:[str integerValue]];
        }
        
        [self.tableView reloadData];
    }else {
        // 请求出错
        PromptMessage(@"删除评论失败");
    }
    
}

- (void)praiseResult:(BOOL)result withPraiseId:(NSInteger)praiseId withPraiseType:(FeedPraise)praiseType withIndexPath:(NSIndexPath *)indexPath {
    if (result) {
        PartnerAllModel *model = self.dataArray[indexPath.section];
        
        if (praiseType == FeedPraiseAdd) {
            PartnerPraiseModel *praiseModel = [[PartnerPraiseModel alloc] init];
            praiseModel.praiseId = praiseId;
            praiseModel.userId = [[UserInfoList loginUserId] integerValue];
            praiseModel.feedId = model.model.feedId;
            praiseModel.nickname = [UserInfoList loginUserNickname];
            
            // 时间格式 2016-01-05 09:55:13
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString *locationString = [dateformatter stringFromDate:senddate];
            praiseModel.addTime = locationString;
            
            [model.userPraise addObject:praiseModel];
            
            [[PartnerPraiseManager shareInstence] insertWithModel:praiseModel];
        }else if (praiseType == FeedPraiseDelete) {
            for (PartnerPraiseModel *praiseModel in model.userPraise) {
                if (praiseModel.userId == [[UserInfoList loginUserId] integerValue]) {
                    [model.userPraise removeObject:praiseModel];
                    
                    [[PartnerPraiseManager shareInstence] delPraiseId:praiseId];
                }
            }
        }
        
        [self.tableView reloadData];
    }else {
        // 请求出错
        PromptMessage(@"赞失败");
    }
    
    PartnerHeaderView *partnerView = (PartnerHeaderView *)[self.tableView viewWithTag:indexPath.section + 500];
    partnerView.praiseBut.userInteractionEnabled = YES;
}

#pragma mark - PartnerViewCellDelegate
- (void)pushToHistoryWithFeedId:(NSInteger)feedId {
    [self resignResponder];
    
    for (PartnerAllModel *model in self.dataArray) {
        if (model.model.feedId == feedId) {
            [self pushToHistoryWithModel:model];
        }
    }
}

- (void)tapIndexPath:(NSIndexPath *)indexPath withEvent:(UIEvent *)event withLabel:(MLEmojiLabel *)label {
    if (!self.isPopup) {
        [self becomeResponder];
        
        PartnerAllModel *allModel = self.dataArray[indexPath.section - 1];
        PartnerCommentModel *model = allModel.userComment[indexPath.row];
        
        if (model.userId == [[UserInfoList loginUserId] integerValue]) {
            model.nickname = [UserInfoList loginUserNickname];
        }
        
        self.existingIndexPath = indexPath;
        
        self.keyboardView.placeholderLabel.text = [NSString stringWithFormat:@"回复:%@",model.nickname];
        
        UITouch* touch = [[event touchesForView:label] anyObject];
        CGPoint rootViewLocation = [touch locationInView:self.view];
        CGPoint size = self.tableView.contentOffset;
        
        int height = 0;
        if (size.y + (rootViewLocation.y - CGRectGetMinY(self.keyboardView.frame)) - widget_width(100) + 64 > 0) {
            height = size.y + (rootViewLocation.y - CGRectGetMinY(self.keyboardView.frame)) - widget_width(100) + 64;
        }
        
        __weak PartnerViewController *selfWeak = self;
        [UIView animateWithDuration:0.3 animations:^{
            if (selfWeak) {
                selfWeak.tableView.contentOffset = CGPointMake(size.x, height);
            }
        }];
        
        self.isPopup = YES;
    }else {
        [self resignResponder];
    }
}

- (void)tapWithPartnerCommentModel:(PartnerCommentModel *)model withIndexPath:(NSIndexPath *)indexPath {
    [self resignResponder];
    
    MiddleAlertViewController *alert = [[MiddleAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.tabBarController.view];
    [alert reloadTitle:@"删除评论" leftMessage:@"取消" rightMessage:@"确定"];
    [self presentViewController:alert animated:NO completion:NULL];
    
    __weak PartnerViewController *partnerVC = self;
    alert.tapBlock = ^{
        PartnerCore *core = [[PartnerCore alloc] init];
        core.delegate = partnerVC;
        [core commentId:model.commentId withFeedId:model.feedId withCommentedId:model.commentedId withCommentDetail:model.commentDetail withIndexPath:indexPath];
    };
}

#pragma mark - PartnerPublishViewControllerDelegate
- (void)writeDynamic {
    PartnerCore *core = [PartnerCore new];
    core.delegate = self;
    [core partnerUserId:[[UserInfoList loginUserId] integerValue] FeedId:0 tag:@"0" type:@"A" withFeedRefresh:FeedRefreshUp];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isPopup == YES) {
        [self resignResponder];
    }
    
//    CGPoint size = self.tableView.contentOffset;
//    
//    CGFloat floatValue = size.y;
//
//    CGSize imageSize = CGSizeMake(50, 50);
//    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
//    [UIColorFromRGB(0xffffff) set];
//    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
//    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [self.navigationController.navigationBar setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsCompact];
//    self.navigationController.navigationBar.shadowImage = pressedColorImg;
}

///**
// * 绘制背景色渐变的矩形，p_colors渐变颜色设置，集合中存储UIColor对象（创建Color时一定用三原色来创建）
// **/
//- (void)drawGradientColor:(CGContextRef)p_context
//                      rect:(CGRect)p_clipRect
//                   options:(CGGradientDrawingOptions)p_options
//                    colors:(NSArray *)p_colors {
//    CGContextSaveGState(p_context);// 保持住现在的context
//    CGContextClipToRect(p_context, p_clipRect);// 截取对应的context
//    NSInteger colorCount = p_colors.count;
//    int numOfComponents = 4;
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colorComponents[colorCount * numOfComponents];
//    for (int i = 0; i < colorCount; i++) {
//        UIColor *color = p_colors[i];
//        CGColorRef temcolorRef = color.CGColor;
//        const CGFloat *components = CGColorGetComponents(temcolorRef);
//        for (int j = 0; j < numOfComponents; ++j) {
//            colorComponents[i * numOfComponents + j] = components[j];
//        }
//    }
//    
//    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, colorCount);
//    CGColorSpaceRelease(rgb);
//    CGPoint startPoint = p_clipRect.origin;
//    CGPoint endPoint = CGPointMake(CGRectGetMinX(p_clipRect), CGRectGetMaxY(p_clipRect));
//    CGContextDrawLinearGradient(p_context, gradient, startPoint, endPoint, p_options);
//    CGGradientRelease(gradient);
//    CGContextRestoreGState(p_context);// 恢复到之前的context
//}

#pragma mark - UITableDataSource / UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    PartnerAllModel *model = self.dataArray[section - 1];
    
    return model.userComment.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PDCell = @"PartnerCellIdentifier";
    PartnerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PDCell];
    if(cell == nil)
    {
        cell = [[PartnerViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PDCell];
        cell.delegate = self;
    }
    
    if (indexPath.section != 0) {
        PartnerAllModel *model = self.dataArray[indexPath.section - 1];
        
        cell.commentArray = model.userComment;
        cell.model = model.userComment[indexPath.row];
        cell.indexPath = indexPath;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self resignResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0;
    }
    
    PartnerAllModel *allModel = self.dataArray[indexPath.section - 1];
    PartnerCommentModel *model = allModel.userComment[indexPath.row];
    
    if (model.userId == [[UserInfoList loginUserId] integerValue]) {
        model.nickname = [UserInfoList loginUserNickname];
    }
    
    CGFloat height = 0;
    
    if (model.commentedId == 0) {
        NSString *string = [NSString stringWithFormat:@"%@ : %@",model.nickname,model.commentDetail];
        height = [PartnerViewCell descHeight:string descWidth:Main_Width - widget_width(274)];
    }else {
        NSString *str = [self sd_commentedId:model.commentedId withArray:allModel.userComment];
        NSString *string = [NSString stringWithFormat:@"%@回复%@ : %@",model.nickname,str,model.commentDetail];
        height = [PartnerViewCell descHeight:string descWidth:Main_Width - widget_width(274)];
    }
    
    return height + widget_width(10);
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(20))];
    view.backgroundColor = UIColorFromRGB(0xe1e3ea);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return widget_width(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return widget_width(400);
    }
    
    CGFloat height = [PartnerHeaderView viewHeight:self.dataArray[section - 1] withShowAllContent:[self.isShowAllContentArray[section - 1] integerValue] == 0 ? NO : YES];
    
    return height + widget_width(16);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (!self.firstheaderView) {
            self.firstheaderView = [[PartnerFirstHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(400))];
            self.firstheaderView.delegate = self;
        }
        self.firstheaderView.userId = [[UserInfoList loginUserId] integerValue];
        self.firstheaderView.nickname = [UserInfoList loginUserNickname];
        self.firstheaderView.photo = [UserInfoList loginUserPhoto];
        self.firstheaderView.picture = [UserInfoList loginUserPicture];
        
        [self.firstheaderView reloadValue];
        
        return self.firstheaderView;
    }
    
    PartnerAllModel *model = self.dataArray[section -1];
    PartnerHeaderView *partnerView = [[PartnerHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(600))];
    partnerView.model = model;
    partnerView.delegate = self;
    partnerView.section = section - 1;
    
    if ([self.isShowAllContentArray[section - 1] integerValue] == 0) {
        partnerView.isAllContent = NO;
        partnerView.allContentLabel.text = @"展开";
    }else {
        partnerView.isAllContent = YES;
        partnerView.allContentLabel.text = @"收回";
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
    [partnerView addGestureRecognizer:tap];
    
    return partnerView;
}

#pragma mark - PartnerFirstHeaderViewDelegate
- (void)pushToHistry {
    [self pushMyself];
}

- (void)changeBackgroundView {
    [self resignResponder];
    
    BottomAlertViewController *alert = [[BottomAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.tabBarController.view];
    [alert addActionWithString:@"拍一张"];
    [alert addActionWithString:@"从本地相册选择"];
    [self presentViewController:alert animated:NO completion:NULL];
    
    __weak PartnerViewController *partnerVC = self;
    alert.tapBlock = ^(NSInteger section){
        switch (section) {
            case 100:
            {
                __strong __typeof(partnerVC)strongSelf = partnerVC;
                strongSelf.isChangeBackImage = YES;
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = YES;
                    imagePicker.delegate = partnerVC;
                    
                    [partnerVC presentViewController:imagePicker animated:YES completion:NULL];
                }else {
                    PromptMessage(@"相机不能用");
                }
            }
                break;
            case 101:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                // 绘制图片
                CGSize imageSize = CGSizeMake(50, 50);
                UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
                [UIColorFromRGBPar(0x21252e) set];
                UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
                UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [picker.navigationBar setBackgroundImage:pressedColorImg forBarMetrics:(UIBarMetricsDefault)];     // 给导航栏自定义图片
                [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = partnerVC;
                //设置选择后的图片可被编辑
                picker.allowsEditing = YES;
                [partnerVC presentViewController:picker animated:YES completion:NULL];
            }
                break;
                
            default:

                break;
        }
    };
}

#pragma mark - image picker delegte - 调用系统相机
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if (!self.isChangeBackImage) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:image,@"image", nil];
        [dic setValue:@"photo" forKey:@"photo"];
        NSArray *array = [NSArray arrayWithObject:dic];
        
        PartnerPublishViewController *writeVC = [[PartnerPublishViewController alloc] init];
        writeVC.imageArray = (NSMutableArray *)array;
        writeVC.delegate = self;
        [self.navigationController pushViewController:writeVC animated:NO];
    }else {
        [self creatHudWithText:@"正在更换背景...."];

        UploadFileCore *uploadFileCore = [[UploadFileCore alloc]init];
        uploadFileCore.delegate = self;
        NSData *imageData = UIImageJPEGRepresentation(image,1.0);
        [uploadFileCore uploadFileArray:@[imageData] lastIsAudio:NO];
    }
}

#pragma mark - UploadDelegate
- (void)uploadResultByArray:(NSArray *)returnPath {
    if (returnPath.count != 1) {
        [self stopHud];
        PromptMessage(@"图片上传失败");
    }else {
        PartnerCore *core = [[PartnerCore alloc] init];
        core.delegate = self;
        [core replaceBackImageWithUserId:[[UserInfoList loginUserId] integerValue] picture:returnPath.lastObject];
    }
}

#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.imageViewer = nil;
}

- (void)imageViewer:(XHImageViewer *)imageViewer withWillSaveImage:(UIImage *)image {
    BottomAlertViewController *alert = [[BottomAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.imageViewer];
    [alert addActionWithString:@"发送给伙伴"];
    [alert addActionWithString:@"保存图片"];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:alert.view];
    
    __weak PartnerViewController *partnerVC = self;
    __weak BottomAlertViewController *bottom = alert;
    alert.tapBlock = ^(NSInteger section){
        bottom.view = nil;
        
        switch (section) {
            case 100:
            {
                
            }
                break;
            case 101:
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImageWriteToSavedPhotosAlbum(image, partnerVC, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                });
            }
                break;
            
            default:
                
                break;
        }
    };
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (error) {
        PromptMessage(@"保存失败");
        [window addSubview:hud];
    } else {
        PromptMessage(@"成功保存到手机");
        [window addSubview:hud];
    }
}

@end
