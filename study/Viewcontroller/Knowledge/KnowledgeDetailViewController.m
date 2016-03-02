//
//  KnowledgeDetailViewController.m
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "KnowledgeDetailViewController.h"
#import "KnowledgeDetailView.h"
#import "UIViewController+KeyboardAnimation.h"
#import "LectureNetCore.h"
#import <Masonry.h>
#import "UMSocial.h"
#import "ChatToolView.h"
#import "ZBMessageManagerFaceView.h"
@interface KnowledgeDetailViewController ()<LectureNetCoreDelegate,KnowledgeDetailViewDelegate>

@property (nonatomic, strong) LectureDetailModel *detailModel;  //model
@property (nonatomic, strong) UIView *shelterView;   //遮挡层
@property (nonatomic, strong) UIView *whiteView;   //底图
@property (nonatomic, strong) NSArray *shareArray;  //分享平台
@property (nonatomic, strong) ChatToolView *chatToolView; //工具栏
@property (nonatomic,strong) ZBMessageManagerFaceView *faceView;//表情视图
@property (nonatomic,assign) CGFloat previousTextViewContentHeight;//记录textview高度
@property (nonatomic, strong) KnowledgeDetailView *knowledgeDetailView;



@end

@implementation KnowledgeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatViewUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self creatNavigationUI];
//    [self subscribeToKeyboard];

}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self an_unsubscribeKeyboard];
}
//导航栏
- (void)creatNavigationUI {
    //设置导航栏背景
    self.title = @"重点知识";
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    [rightBtn setImage:[UIImage imageNamed:@"zhuanfafenxiang"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareFunctionClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightButtonItem, nil];
}

//界面
- (void)creatViewUI {
    _knowledgeDetailView = [[KnowledgeDetailView alloc] initWithFrame:self.view.frame];
    _knowledgeDetailView.titleName = self.titleName;
    _knowledgeDetailView.lecrureid = self.lecrureid;
    _knowledgeDetailView.delegate = self;
    [self.view addSubview:_knowledgeDetailView];
    _detailModel = [[LectureDetailModel alloc] init];
}

// 转发分享
- (void)shareFunctionClick {
    _shelterView = [[UIView alloc] initWithFrame:self.view.bounds];
    _shelterView.backgroundColor = [UIColor blackColor];
    _shelterView.alpha = 0.5;
    [self.view.window addSubview:_shelterView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearShelterView)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.numberOfTouchesRequired = 1;
    [_shelterView addGestureRecognizer:gestureRecognizer];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height - 200 , Main_Width, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view.window addSubview:whiteView];
    _whiteView = whiteView;
    NSArray *shareArray = @[@"微信朋友圈",@"微信好友",@"QQ空间",@"QQ好友",@"新浪微博"];
    _shareArray = shareArray;
    CGFloat space = (Main_Width - 40 * 5) / 6;
    CGFloat width = (Main_Width - space) / 5;
    //分享平台
    for (int index = 0; index < 5; ++index) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space + index * (40 + space) , 22, 40, 40);
        btn.tag = 10 + index;
        [btn setImage:[UIImage imageNamed:shareArray[index]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space / 2 + width * index, MaxY(btn), width, 40)];
        titleLabel.text = shareArray[index];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textColor = RGBVCOLOR(0x3d3d3d);
        [whiteView addSubview:titleLabel];
    }
    //转发
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 105, Main_Width, 45);
    [shareBtn setTitle:@"转发到伙伴圈" forState:UIControlStateNormal];
    shareBtn.backgroundColor = lightColor;
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:shareBtn];
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(shareBtn), Main_Width, 5)];
    lineView.backgroundColor = basicColor;
    [whiteView addSubview:lineView];
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, MaxY(lineView), Main_Width, 45);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBVCOLOR(0x3b3b3b) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clearShelterView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:cancelBtn];

}

- (void)shareBtnClick:(UIButton *)sender {
    NSArray *array = @[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToSina];
    NSString *snsName = [NSString stringWithFormat:@"%@",array[sender.tag - 10]];
    [self clearShelterView];
    //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
//    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
    UIImage *shareImage = [UIImage imageNamed:_shareArray[sender.tag - 10]];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:shareText image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        } else if(response.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

//取消遮挡层
- (void)clearShelterView {
    [_shelterView removeFromSuperview];
    [_whiteView removeFromSuperview];
}

//键盘通知
- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        CGFloat height = keyboardRect.size.height;

        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
  
    } completion:nil];
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
