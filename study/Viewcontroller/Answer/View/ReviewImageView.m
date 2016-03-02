//
//  ReviewImageView.m
//  study
//
//  Created by jzkj on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "ReviewImageView.h"
#import "UIImageView+MJWebCache.h"
#import "JHAudioManager.h"
@interface ReviewImageView ()<UIScrollViewDelegate>{
    UIScrollView *_imageScrollView;
    UIImageView *_imageView;//图片
}

@end

@implementation ReviewImageView
- (instancetype)initWithFrame:(CGRect)frame message:(ChatMsgDTO *)msg{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutViewsWith:msg];
    }
    return self;
}
- (void)layoutViewsWith:(ChatMsgDTO *)msg{
    _imageScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _imageScrollView.backgroundColor = [UIColor blackColor];
    _imageScrollView.delegate = self;
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = self.bounds;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[JZCommon getFileDownloadPath:msg.url]]];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageScrollView addSubview:_imageView];
    _imageScrollView.maximumZoomScale = 2;
    _imageScrollView.minimumZoomScale = 1;
    _imageScrollView.showsHorizontalScrollIndicator=NO;
    _imageScrollView.showsVerticalScrollIndicator=NO;
    _imageScrollView.zoomScale=1;
    _imageScrollView.bounces=YES;
    //添加手势
    UITapGestureRecognizer *blackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideScrollView)];
    [_imageScrollView addGestureRecognizer:blackTap];
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    videoBtn.frame = CGRectMake(Main_Width/2 - 15, Main_Height - 50, 30, 30);
    [videoBtn setImage:[UIImage imageNamed:@"chatShowImage"] forState:UIControlStateNormal];
    [videoBtn addTarget:self action:@selector(VideoAction) forControlEvents:UIControlEventTouchDown];
    [videoBtn addTarget:self action:@selector(VideoEnd) forControlEvents:UIControlEventTouchUpInside];
    [videoBtn addTarget:self action:@selector(VideoCancel) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:_imageScrollView];
    [self addSubview:videoBtn];
}
//开始录音
- (void)VideoAction{
    [[JHAudioManager sharedInstance]recordStart:[UserInfoList loginUserId] target:self];
}
//完成录音
- (void)VideoEnd{
    NSMutableDictionary *recordDic = [[JHAudioManager sharedInstance]recordStop];
    self.recordVideo(recordDic);
}
//取消录音
- (void)VideoCancel{
    [[JHAudioManager sharedInstance] recordCancel];
}
//退出查看图片模式
- (void)hideScrollView{
    [self removeFromSuperview];
}
#pragma mark scrollView 代理
//指定缩放的视图
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
