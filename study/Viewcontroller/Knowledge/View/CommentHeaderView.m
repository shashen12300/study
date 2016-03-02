//
//  commentHeaderView.m
//  study
//
//  Created by mijibao on 16/1/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CommentHeaderView.h"
#import "CommentModel.h"
#import "LectureNetCore.h"
#import <UIImageView+AFNetworking.h>
#import <Masonry.h>
#import "ALMoviePlayerController.h"
#import "UMSocial.h"
#import "KnowledgeDetailViewController.h"

@interface CommentHeaderView()<LectureNetCoreDelegate,ALMoviePlayerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView; //视频
@property (weak, nonatomic) IBOutlet UILabel *contentLabel; //内容简介
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;  //点赞
@property (weak, nonatomic) IBOutlet UIButton *transmitBtn; //转发
@property (weak, nonatomic) IBOutlet UIButton *shareBtn; //分享
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight; //内容简介高度
@property (nonatomic, strong) LectureNetCore *lectureNetCore; //网络请求
@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;  //视频播放器
@property (nonatomic, strong) NSString *praiseId; //点赞ID
@property (nonatomic, strong) UIView *shelterView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) NSArray *shareArray;
@property (nonatomic, strong) KnowledgeDetailViewController *viewController;

@end

@implementation CommentHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KView" owner:self options:nil]objectAtIndex:3];
        self.frame = frame;
        [self setupMoviewplayer];
    }
    return self;
}

//model 赋值
- (void)setDetailModel:(LectureDetailModel *)detailModel {
    //
//    if (![JZCommon isBlankString:detailModel.picurl]) {
//        [_videoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,detailModel.picurl]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
//    }
    //播放器
    if (![JZCommon isBlankString:detailModel.url]) {
        [_videoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,detailModel.picurl]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //视频资源
        NSURL *videoFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,detailModel.url]];
        [self.moviePlayer setContentURL:videoFileURL];
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [self configureViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
            [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
                self.moviePlayer.view.alpha = 1.f;
            } completion:^(BOOL finished) {
//                self.navigationItem.leftBarButtonItem.enabled = YES;
//                self.navigationItem.rightBarButtonItem.enabled = YES;
            }];
        });
    }
    //内容简介
    if (![JZCommon isBlankString:detailModel.content]) {
        _contentLabel.text = detailModel.content;
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGRect frame = [_contentLabel.text boundingRectWithSize:CGSizeMake(WIDTH(_contentLabel), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        _contentHeight.constant = CGRectGetHeight(frame) + 13;
        CGRect newFrame = self.frame;
        newFrame.size.height = 270 + _contentHeight.constant;
        self.frame = newFrame;
    }
    //
}

#pragma mark --- 自定义播放器
-(void)setupMoviewplayer
{
    self.moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, Main_Width - 20, 207)];
    self.moviePlayer.view.alpha = 0.f;
    [_videoImageView addSubview:self.moviePlayer.view];
    self.moviePlayer.delegate = self;
    [_moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(_videoImageView);
    }];
    //控制面板
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleDefault];
    [movieControls setBarColor:[UIColor blackColor]];
    [movieControls setTimeRemainingDecrements:NO];
//    [movieControls setFadeDelay:2.0];
    [movieControls setBarHeight:52 / 2.f];
    //[movieControls setSeekRate:2.f];
    //assign controls
    [self.moviePlayer setControls:movieControls];
}

// 功能按钮
- (IBAction)functionBtnClick:(UIButton *)sender {
    //NSLog(@"分享按钮点击~~");
    
    if(!_lectureNetCore) {
        _lectureNetCore = [[LectureNetCore alloc] init];
        _lectureNetCore.del = self;
    }
    if (sender.tag == 10) {  //点赞
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!_praiseId) {
            [_lectureNetCore requestPraiseWithFeedId:self.lecrureid withUserId:[UserInfoList loginUserId]];
        }else {
            [_lectureNetCore requestDelPraiseId:_praiseId];
        }

        });
    }else if (sender.tag == 11) {  //转发
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前不支持转发" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }else { //分享
        [self shareFunctionClick];
    }
    
//    if (_lecrureid != nil) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [_lectureNetCore requestBigLessonWithShare:@{@"userId":[UserInfoList loginUserId],@"lecrureId":_lecrureid,@"picurl":_detailModel.picurl,@"duration":_detailModel.duration,@"content":@"分享今日大课视频",@"subject":_detailModel.subject,@"grade":_detailModel.grade,@"visibleRange":@"G",@"addtimeB":_detailModel.addtime,@"titleB":_titleName}];
//        });
//    }
}

- (void)setLecrureid:(NSString *)lecrureid {
    _lecrureid = lecrureid;
}

#pragma -mark  ALMoviePlayerControllerDelegate
- (void)moviePlayerWillMoveFromWindow
{
    if (![_videoImageView.subviews containsObject:self.moviePlayer.view])
        [_videoImageView addSubview:self.moviePlayer.view];
    
    [self.moviePlayer setFrame:CGRectMake(0, 0, WIDTH(_videoImageView), HEIGHT(_videoImageView))];  //scc
}

- (void)movieTimedOut {
    NSLog(@"MOVIE TIMED OUT");
}

#pragma -mark LectureNetCoreDelegate
//点赞
- (void)postBigLessonPraise:(NSString *)praiseId isSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        _praiseBtn.selected = YES;
        _praiseId = praiseId;
    }else {
        _praiseBtn.selected = NO;
    }
    
}

//取消点赞
- (void)postBigLessonDelPraise:(BOOL)isSuccess {
    if (isSuccess) {
        _praiseBtn.selected = NO;
        _praiseId = nil;
    }else {
        _praiseBtn.selected  = YES;
    }
    
}

// 转发分享
- (void)shareFunctionClick {
    _shelterView = [[UIView alloc] initWithFrame:self.window.bounds];
    _shelterView.backgroundColor = [UIColor blackColor];
    _shelterView.alpha = 0.5;
    [self.window addSubview:_shelterView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearShelterView)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.numberOfTouchesRequired = 1;
    [_shelterView addGestureRecognizer:gestureRecognizer];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height - 155 , Main_Width, 155)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:whiteView];
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
//    //转发
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(0, 105, Main_Width, 45);
//    [shareBtn setTitle:@"转发到伙伴圈" forState:UIControlStateNormal];
//    shareBtn.backgroundColor = lightColor;
//    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [whiteView addSubview:shareBtn];
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, Main_Width, 5)];
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
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:shareText image:shareImage location:nil urlResource:nil presentedController:self.viewController completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        } else if(response.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (KnowledgeDetailViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[KnowledgeDetailViewController class]]) {
            return (KnowledgeDetailViewController*)nextResponder;
        }
    }
    return nil;
}

//取消遮挡层
- (void)clearShelterView {
    [_shelterView removeFromSuperview];
    [_whiteView removeFromSuperview];
}

@end
