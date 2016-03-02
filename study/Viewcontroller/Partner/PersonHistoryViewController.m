//
//  PersonHistoryViewController.m
//  study
//
//  Created by mijibao on 15/9/17.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PersonHistoryViewController.h"
#import "UIImageView+MJWebCache.h"
#import "PersonHistoryTableViewCell.h"
#import "PartnerCore.h"
#import "PartnerAllModel.h"
#import "PersonHistoryDetailViewController.h"
#import "XHImageViewer.h"
#import "PartnerHistoryManager.h"
#import "PartnerFirstHeaderView.h"
#import "MJRefresh.h"
#import "BottomAlertViewController.h"

@interface PersonHistoryViewController () <PartnerCoreDelegate, PartnerHistoryDelegate, XHImageViewerDelegate, PersonHistoryTableViewCellDelegate, PartnerFirstHeaderViewDelegate>

@property (nonatomic, strong) PartnerFirstHeaderView *headerView;  // headerView
@property (nonatomic, strong) XHImageViewer *imageViewer;  // 点击展示图片view
@property (nonatomic, assign) BOOL isMyself;               // YES 为自己  NO 为别人

@end

@implementation PersonHistoryViewController

- (instancetype)initWithPerson:(BOOL)isMyself {
    self = [super init];
    if (self) {
        _isMyself = isMyself;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.dataArray = [NSMutableArray new];
    
    if (self.isMyself) {
        self.dataArray = [[NSMutableArray alloc] initWithArray:[[PartnerHistoryManager shareInstance] gainDataArray]];
        
        if (self.dataArray.count == 0) {
            [self creatHudWithText:@"加载中..."];
        }
    }else
        [self creatHudWithText:@"加载中..."];
    
    
    [self setupNav];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = YES;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - inner methods
// 导航栏
- (void)setupNav {
    if (self.isMyself) {
        [self setNavigationTitle:@"我的动态"];
    }else
        [self setNavigationTitle:@"动态"];

    self.navigationItem.leftBarButtonItem = [self addItemWithTitle:@"" imageName:@"partner_return" target:self action:@selector(handleLeftBarButton)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
}

- (void)handleLeftBarButton {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setupSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator  = NO;
    
    PartnerCore *core = [[PartnerCore alloc] init];
    core.delegate = self;
    [core partnerUserId:self.userId FeedId:0 tag:@"0" type:@"M" withFeedRefresh:FeedRefreshNone];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addHeader)];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(addFooter)];
}

// 上拉刷新
- (void)addHeader {
    PartnerCore *core = [PartnerCore new];
    core.delegate = self;
    [core partnerUserId:self.userId FeedId:0 tag:@"0" type:@"M" withFeedRefresh:FeedRefreshUp];
}

// 下拉刷新
- (void)addFooter {
    PartnerAllModel *model = [self.dataArray lastObject];
    PartnerCore *core = [PartnerCore new];
    core.delegate = self;
    [core partnerUserId:self.userId FeedId:model.model.feedId tag:@"D" type:@"M" withFeedRefresh:FeedRefreshDown];
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

#pragma mark - PartnerDelegate
- (void)gainPartnerResult:(BOOL)result withResultArray:(NSArray *)resultArray withFeedRefresh:(FeedRefresh)feedRefresh {
    if (result) {
        switch (feedRefresh) {
            case FeedRefreshNone:
            {
                // 刚进来网络请求时,如果有数据 那么就是缓存数据,网络请求后要被移除
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:resultArray];
            }
                break;
            case FeedRefreshDown:
            {
                if (resultArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.dataArray addObjectsFromArray:resultArray];
            }
                break;
            case FeedRefreshUp:
            {
                if (self.dataArray.count == 0) {
                    [self.dataArray addObjectsFromArray:resultArray];
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

#pragma mark - PartnerHistoryDelegate
- (void)deleteModelWithIndexPath:(NSInteger)indexPath {
    [self.dataArray removeObjectAtIndex:indexPath];
    
    PartnerAllModel *model = self.dataArray[indexPath];
    [[PartnerHistoryManager shareInstance] delFeedId:model.model.feedId];
    [self.tableView reloadData];
}


#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PHCell = @"PHCellIdentifier";
    PersonHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PHCell];
    if(cell == nil) {
        cell = [[PersonHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PHCell];
    }
    
    PartnerAllModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    
    if (indexPath.row == 0) {
        cell.dayLabel.hidden = NO;
    }
    if (indexPath.row > 0) {
        PartnerAllModel *beginModel = [_dataArray objectAtIndex:indexPath.row - 1];
        
        NSRange ran = NSMakeRange(7, 2);
        NSString *ssDay = [model.model.addTime substringWithRange:ran];
        NSString *sDay = [beginModel.model.addTime substringWithRange:ran];
        if ([ssDay integerValue] == [sDay integerValue]) {
            cell.dayLabel.hidden = YES;
        }else {
            cell.dayLabel.hidden = NO;
        }
    }
    if (indexPath.row < _dataArray.count - 1) {
        PartnerAllModel *nextModel = [_dataArray objectAtIndex:indexPath.row + 1];
        NSRange range = NSMakeRange(5, 2);
        NSString *ssMonth = [model.model.addTime substringWithRange:range];
        NSString *sMonth = [nextModel.model.addTime substringWithRange:range];
        if ([ssMonth integerValue] != [sMonth integerValue]) {
            cell.monthLabel.hidden = NO;
        }else {
            cell.monthLabel.hidden = YES;
        }
    }
    if (indexPath.row == _dataArray.count - 1) {
        cell.monthLabel.hidden = NO;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerAllModel *model = self.dataArray[indexPath.row];
    
    return [PersonHistoryTableViewCell cellHeight:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PartnerAllModel *model = _dataArray[indexPath.row];
    
    PersonHistoryDetailViewController *detailVC = [[PersonHistoryDetailViewController alloc] init];
    detailVC.delegate = self;
    detailVC.index = indexPath.row;
    detailVC.model = model;
    detailVC.dataArray = (NSArray *)self.dataArray;
    [self.navigationController pushViewController:detailVC animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return widget_width(430);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.headerView) {
        self.headerView = [[PartnerFirstHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(430))];
        self.headerView.userId = self.userId;
        self.headerView.nickname = self.nickname;
        self.headerView.photo = self.photo;
        self.headerView.signature = self.signature;
        self.headerView.picture = self.picture;
    }
    
    [self.headerView reloadValue];
    
    return self.headerView;
}

#pragma mark - PartnerFirstHeaderViewDelegate
- (void)changeBackgroundView {
    // 空执行
}

- (void)pushToHistry {
    
}

#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    self.navigationController.navigationBarHidden = NO;
    
    for(UIView *view in [self.imageViewer subviews])
    {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.imageViewer = nil;
    [self.imageViewer removeFromSuperview];
}

- (void)imageViewer:(XHImageViewer *)imageViewer withWillSaveImage:(UIImage *)image {
    BottomAlertViewController *alert = [[BottomAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.imageViewer];
    [alert addActionWithString:@"发送给伙伴"];
    [alert addActionWithString:@"保存图片"];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:alert.view];
    
    __weak PersonHistoryViewController *partnerVC = self;
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

#pragma mark - PersonHistoryTableViewCellDelegate
- (void)showImagesWithImageViews:(NSArray *)imageArr selectedView:(UIImageView *)imageView {
    self.navigationController.navigationBarHidden = YES;
    
    self.imageViewer = [[XHImageViewer alloc] initWithImageViews:imageArr selectedView:imageView];
    self.imageViewer.delegate = self;
}

- (void)playWithLectureId:(NSString *)lectureId {
    NSLog(@"play");

}

@end
