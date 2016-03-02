//
//  PersonHistoryDetailViewController.m
//  study
//
//  Created by yang on 15/9/23.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PersonHistoryDetailViewController.h"
#import "UIImageView+MJWebCache.h"
#import "PartnerViewCell.h"
#import "PartnerHeaderView.h"
#import "PartnerCommentModel.h"
#import "PartnerPraiseModel.h"
#import "PartnerCore.h"
#import "PartnerKeyboardView.h"
#import "FaceView.h"
#import "XHImageViewer.h"
#import "PartnerPraiseHistoryManager.h"
#import "PartnerCommentHistoryManager.h"
#import "PersonHistoryViewController.h"
#import "MiddleAlertViewController.h"
#import "BottomAlertViewController.h"

@interface PersonHistoryDetailViewController () <PartnerCoreDelegate, PartnerHeaderViewDelegate, PartnerKeyboardViewDelegate, PartnerViewCellDelegate, XHImageViewerDelegate>

@property (nonatomic, strong) UITableView *tableView;             // tableView
@property (nonatomic, strong) PartnerHeaderView *partnerView;     // tableView的headerView
@property (nonatomic, strong) PartnerKeyboardView *keyboardView;  // 键盘
@property (nonatomic, strong) FaceView *emojiView;                // 表情

@property (nonatomic, assign) BOOL isAllContent;                  // 内容是否展开  1:展开   0:未展开
@property (nonatomic, strong) NSIndexPath *existingIndexPath;     // 记录被点击评论的位置
@property (nonatomic, strong) XHImageViewer *imageViewer;         // 点击图片展示view
@property (nonatomic, assign) BOOL isPopup;                       // 键盘是否弹出

@end

@implementation PersonHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.isAllContent = NO;
    
    [self setupSubviews];
    [self setupNav];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor blackColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.shadowImage = pressedColorImg;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.clipsToBounds = YES;   // 去掉黑线方法
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - inner methods
- (void)setupSubviews {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, -64, Main_Width, 20)];
    v.backgroundColor = [UIColor blackColor];
    [self.view addSubview:v];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height - widget_width(100)) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //表情
    self.emojiView = [[FaceView alloc] initWithFrame:CGRectMake(0, Main_Height - 110 - 64, Main_Width, 110)];
    [self.view addSubview:self.emojiView];
    self.emojiView.hidden = YES;
    
    [self setupKeyboard];
}

// 导航栏
- (void)setupNav {
    [self setNavigationBarColor:[UIColor blackColor]];
    [self setNavigationTitle:@"详情"];
    self.navigationItem.leftBarButtonItem = [self addItemWithTitle:@"" imageName:@"partner_return" target:self action:@selector(handleLeftBarButton)];
}

- (void)handleLeftBarButton {
    [self.navigationController popViewControllerAnimated:NO];
}

// 键盘
- (void)setupKeyboard {
    self.keyboardView = [[PartnerKeyboardView alloc] initWithFrame:CGRectMake(0, Main_Height - widget_width(100) - 64, Main_Width, widget_width(100))];
    self.keyboardView.delegate = self;
    [self.view addSubview:self.keyboardView];
    self.keyboardView.hidden = NO;
    self.keyboardView.placeholderLabel.text = @"评论";
    self.isPopup = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardView.frame = CGRectMake(0, Main_Height - widget_width(100) - 64, Main_Width, widget_width(100));
    self.emojiView.hidden = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    CGRect toolViewRect = self.keyboardView.frame;
    toolViewRect.origin.y -= keyboardEndFrame.size.height;
    
    __weak PersonHistoryDetailViewController *selfWeak = self;
    [UIView animateWithDuration:animationDuration animations:^{
        if (selfWeak) {
            [selfWeak.keyboardView setFrame:toolViewRect];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardView.frame = CGRectMake(0, Main_Height - widget_width(100) - 64, Main_Width, widget_width(100));
}

// 返回查找到用户的昵称的字符串
- (NSString *)sd_commentedId:(NSInteger)Cid withArray:(NSMutableArray *)array
{
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


- (void)resignResponder {
    [self.keyboardView.inputText resignFirstResponder];
    self.emojiView.hidden = YES;
    self.keyboardView.hidden = NO;
    self.isPopup = NO;
    
    [self.keyboardView removeFromSuperview];
    [self setupKeyboard];
}

- (void)becomeResponder {
    self.keyboardView.hidden = NO;
    self.emojiView.hidden = NO;
    [self.keyboardView.inputText becomeFirstResponder];
}

// 跳到动态页
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

#pragma mark - PartnerViewCellDelegate
- (void)tapWithPartnerCommentModel:(PartnerCommentModel *)model withIndexPath:(NSIndexPath *)indexPath {
    [self resignResponder];
    
    MiddleAlertViewController *alert = [[MiddleAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.navigationController.view];
    [alert reloadTitle:@"删除评论" leftMessage:@"取消" rightMessage:@"确定"];
    [self presentViewController:alert animated:NO completion:NULL];
    
    __weak PersonHistoryDetailViewController *partnerDVC = self;
    alert.tapBlock = ^{
        PartnerCore *core = [[PartnerCore alloc] init];
        core.delegate = partnerDVC;
        [core commentId:model.commentId withFeedId:model.feedId withCommentedId:model.commentedId withCommentDetail:model.commentDetail withIndexPath:indexPath];
    };
}

- (void)tapIndexPath:(NSIndexPath *)indexPath withEvent:(UIEvent *)event withLabel:(MLEmojiLabel *)label {
    if (self.isPopup == NO) {
        [self becomeResponder];
        
        PartnerCommentModel *model = self.model.userComment[indexPath.row];
        if (model.userId == [[UserInfoList loginUserId] integerValue]) {
            model.nickname = [UserInfoList loginUserNickname];
        }
        self.existingIndexPath = indexPath;
        self.keyboardView.placeholderLabel.text = [NSString stringWithFormat:@"回复:%@",model.nickname];
        
        UITouch* touch = [[event touchesForView:label] anyObject];
        CGPoint rootViewLocation = [touch locationInView:self.view];
        CGPoint size = self.tableView.contentOffset;
        
        int height = 0;
        if (size.y + ((rootViewLocation.y + 64) - CGRectGetMinY(self.keyboardView.frame)) - widget_width(100) > 0) {
            height = size.y + ((rootViewLocation.y + 64) - CGRectGetMinY(self.keyboardView.frame)) - widget_width(100);
        }
        __weak PersonHistoryDetailViewController *selfWeak = self;
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

- (void)pushToHistoryWithFeedId:(NSInteger)feedId {
    for (PartnerAllModel *model in self.dataArray) {
        if (model.model.feedId == feedId) {
            [self pushToHistoryWithModel:model];
        }
    }
}

#pragma mark - PartnerKeyboardViewDelegate
- (void)clickSendButton:(NSString *)text {
    [self resignResponder];
    
    PartnerCore *core = [[PartnerCore alloc] init];
    core.delegate = self;
    if (self.existingIndexPath) {
        if (self.existingIndexPath.row == -1) {
            [core commentId:0 withFeedId:self.model.model.feedId withCommentedId:0 withCommentDetail:text withIndexPath:self.existingIndexPath];
        }else {
            PartnerCommentModel *model = self.model.userComment[self.existingIndexPath.row];
            [core commentId:0 withFeedId:self.model.model.feedId withCommentedId:model.commentId withCommentDetail:text withIndexPath:self.existingIndexPath];
        }
    }
}

- (void)showEmojiView:(BOOL)toShowEmojiView {
    self.emojiView.hidden = !toShowEmojiView;
    if (toShowEmojiView == YES) {
        self.keyboardView.frame = CGRectMake(0, Main_Height - widget_width(100) - 110 - 64, Main_Width, widget_width(100));
    }
}

#pragma mark - PartnerHeaderViewDelegate
- (void)pushPersonalHistorySyntonyWithSection:(NSInteger)section {
    [self resignResponder];
    [self pushToHistoryWithModel:self.model];
}

- (void)showDelImageSyntonyWithSection:(NSInteger)section {
    [self resignResponder];
    
    MiddleAlertViewController *alert = [[MiddleAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.navigationController.view];
    [alert reloadTitle:@"确定删除" leftMessage:@"取消" rightMessage:@"确定"];
    [self presentViewController:alert animated:NO completion:NULL];
    
    __weak PersonHistoryDetailViewController *partnerDVC = self;
    alert.tapBlock = ^{
        PartnerCore *core = [[PartnerCore alloc] init];
        core.delegate = partnerDVC;
        [core deleteUserFeed:partnerDVC.model.model.feedId];
    };
}

- (void)handleShowAllContentSyntonyWithSection:(NSInteger)section {
    [self resignResponder];
    self.isAllContent = !self.isAllContent;
    [self.tableView reloadData];
}

- (void)handleCommentSyntonyWithSection:(NSInteger)section withEvent:(UIEvent *)event withBut:(UIButton *)but {
    if (self.isPopup == NO) {
        [self becomeResponder];
        
        self.keyboardView.placeholderLabel.text = @"评论";
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:section + 1];
        self.existingIndexPath = indexPath;
        
        UITouch* touch = [[event touchesForView:but] anyObject];
        CGPoint rootViewLocation = [touch locationInView:self.view];
        CGPoint size = self.tableView.contentOffset;
        
        int height = 0;
        if (size.y + ((rootViewLocation.y + 64) - CGRectGetMinY(self.keyboardView.frame)) - widget_width(100) > 0) {
            height = size.y + ((rootViewLocation.y + 64) - CGRectGetMinY(self.keyboardView.frame)) - widget_width(100);
        }
        
        __weak PersonHistoryDetailViewController *selfWeak = self;
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
    if (self.model.userPraise.count == 0) {
        [core praiseId:0 withFeedId:self.model.model.feedId withPraiseType:FeedPraiseAdd withIndexPath:indexPath];
        return;
    }
    
    for (PartnerPraiseModel *model in self.model.userPraise) {
        if (model.userId == [[UserInfoList loginUserId] integerValue]) {
            [core praiseId:model.praiseId withFeedId:self.model.model.feedId withPraiseType:FeedPraiseDelete withIndexPath:indexPath];
            return;
        }
    }

    [core praiseId:0 withFeedId:self.model.model.feedId withPraiseType:FeedPraiseAdd withIndexPath:indexPath];
}

- (void)showImagesWithImageViews:(NSArray *)imageArr selectedView:(UIImageView *)imageView {
    self.navigationController.navigationBarHidden = YES;
    self.imageViewer = [[XHImageViewer alloc] initWithImageViews:imageArr selectedView:imageView];
    self.imageViewer.delegate = self;
}

- (void)playWithLectureId:(NSString *)lectureId {
    NSLog(@"play");

}

#pragma mark - PartnerCoreDelegate
- (void)delPartnerResult:(BOOL)result withFeedId:(NSInteger)feedId {
    if (result) {
        // 删除
        if ([self.delegate respondsToSelector:@selector(deleteModelWithIndexPath:)]) {
            [self.delegate deleteModelWithIndexPath:self.index];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        // 请求出错
        PromptMessage(@"删除失败");
    }
}

- (void)addCommentResult:(BOOL)result withCommentId:(NSInteger)commentId withFeedId:(NSInteger)feedId withCommentedId:(NSInteger)commentedId withCommentDetail:(NSString *)commentDetail withIndexPath:(NSIndexPath *)indexPath {
    if (result) {
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
            [self.model.userComment insertObject:model atIndex:indexPath.row + 1];
        }else {
            [self.model.userComment addObject:model];
        }
        
        [[PartnerCommentHistoryManager shareInstence] insertWithModel:model];
        
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
        
        PartnerCommentModel *comModel = self.model.userComment[indexPath.row];
        [commentArray addObject:[NSString stringWithFormat:@"%ld",(long)comModel.commentId]];
        
        [self.model.userComment removeObjectAtIndex:indexPath.row];
        
        for (int i = 0; i < self.model.userComment.count; i ++) {
            PartnerCommentModel *model = self.model.userComment[i];
            
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
            [self.model.userComment removeObjectAtIndex:[removeArray[i] integerValue]];
        }
        
        for (NSString *str in commentArray) {
            [[PartnerCommentHistoryManager shareInstence] delCommentId:[str integerValue]];
        }
        
        [self.tableView reloadData];
    }else {
        // 请求出错
        PromptMessage(@"删除评论失败");
    }
}

- (void)praiseResult:(BOOL)result withPraiseId:(NSInteger)praiseId withPraiseType:(FeedPraise)praiseType withIndexPath:(NSIndexPath *)indexPath {
    if (result) {
        if (praiseType == FeedPraiseAdd) {
            PartnerPraiseModel *model = [[PartnerPraiseModel alloc] init];
            model.praiseId = praiseId;
            model.userId = [[UserInfoList loginUserId] integerValue];
            model.feedId = self.model.model.feedId;
            model.nickname = [UserInfoList loginUserNickname];
            
            // 时间格式 2016-01-05 09:55:13
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString *locationString = [dateformatter stringFromDate:senddate];
            model.addTime = locationString;
            
            [self.model.userPraise addObject:model];
            
            [[PartnerPraiseHistoryManager shareInstence] insertWithModel:model];
        }else if (praiseType == FeedPraiseDelete) {
            for (PartnerPraiseModel *model in self.model.userPraise) {
                if (model.userId == [[UserInfoList loginUserId] integerValue]) {
                    [self.model.userPraise removeObject:model];
                    
                    [[PartnerPraiseHistoryManager shareInstence] delPraiseId:model.praiseId];
                }
            }
        }
        
        [self.tableView reloadData];
    }else {
        // 请求出错
        PromptMessage(@"赞失败");
    }
    
    self.partnerView.praiseBut.userInteractionEnabled = YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isPopup == YES) {
        [self resignResponder];
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.userComment.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PDetailCell = @"PartnerDetailCellIdentifier";
    PartnerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PDetailCell];
    if(cell == nil)
    {
        cell = [[PartnerViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PDetailCell];
        cell.delegate = self;
    }
    
    cell.commentArray = self.model.userComment;
    cell.model = self.model.userComment[indexPath.row];
    cell.indexPath = indexPath;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerCommentModel *model = self.model.userComment[indexPath.row];
    
    if (model.userId == [[UserInfoList loginUserId] integerValue]) {
        model.nickname = [UserInfoList loginUserNickname];
    }
    
    CGFloat height = 0;
    
    if (model.commentedId == 0) {
        NSString *string = [NSString stringWithFormat:@"%@ : %@",model.nickname,model.commentDetail];
        height = [PartnerViewCell descHeight:string descWidth:Main_Width - widget_width(274)];
    }else {
        NSString *str = [self sd_commentedId:model.commentedId withArray:self.model.userComment];
        NSString *string = [NSString stringWithFormat:@"%@回复%@ : %@",model.nickname,str,model.commentDetail];
        height = [PartnerViewCell descHeight:string descWidth:Main_Width - widget_width(274)];
    }
    
    return height + widget_width(10);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self resignResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = [PartnerHeaderView viewHeight:self.model withShowAllContent:self.isAllContent];
    
    return height + widget_width(16);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.partnerView = [[PartnerHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(600))];
    self.partnerView.model = self.model;
    self.partnerView.delegate = self;
    self.partnerView.section = section - 1;
    
    self.partnerView.isAllContent = self.isAllContent;
    
    if (self.isAllContent) {
        self.partnerView.allContentLabel.text = @"收回";
    }else {
        self.partnerView.allContentLabel.text = @"展开";
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
    [self.partnerView addGestureRecognizer:tap];
    
    return self.partnerView;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (error) {
        PromptMessage(@"保存失败");
        [window addSubview:hud];
    } else {
        PromptMessage(@"成功保存到手机");
        [window addSubview:hud];
    }
}

#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer withWillSaveImage:(UIImage *)image {
    BottomAlertViewController *alert = [[BottomAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.imageViewer];
    [alert addActionWithString:@"发送给伙伴"];
    [alert addActionWithString:@"保存图片"];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:alert.view];
    
    __weak PersonHistoryDetailViewController *partnerVC = self;
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

- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    self.navigationController.navigationBarHidden = NO;
    self.imageViewer = nil;
}

@end
