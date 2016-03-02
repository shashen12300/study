//
//  MessageFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-12.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "ZBMessageManagerFaceView.h"
#import "ZBExpressionSectionBar.h"


#define FaceSectionBarHeight  45   // 表情下面控件
#define FaceSectionBttonWidth 60   //控件上按钮的宽度
#define FacePageControlHeight 30  // 表情pagecontrol

#define Pages 3

#define myx [UIScreen mainScreen].bounds.size.width/375.0

@implementation ZBMessageManagerFaceView
{
    UIPageControl *pageControl;
    ZBExpressionSectionBar *_sectionBar;
    UIScrollView *_scrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f,0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)-FacePageControlHeight-FaceSectionBarHeight)];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(_scrollView.frame)*Pages,CGRectGetHeight(_scrollView.frame))];
    
    for (int i= 0;i<Pages;i++) {
        ZBFaceView *faceView = [[ZBFaceView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(self.bounds),0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(_scrollView.bounds)) forIndexPath:i];
        [_scrollView addSubview:faceView];
        faceView.delegate = self;
    }
    
    pageControl = [[UIPageControl alloc]init];
    [pageControl setFrame:CGRectMake(0,CGRectGetMaxY(_scrollView.frame),CGRectGetWidth(self.bounds),FacePageControlHeight)];
    [self addSubview:pageControl];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages = Pages;
    pageControl.currentPage   = 0;
    
    
    _sectionBar = [[ZBExpressionSectionBar alloc]initWithFrame:CGRectMake(0.0f,CGRectGetHeight(self.frame)-FaceSectionBarHeight,CGRectGetWidth(self.bounds), FaceSectionBarHeight)];
    for (int i=0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        if (i < 4) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"message%d",i+1]] forState:UIControlStateNormal];
            btn.frame = CGRectMake(i*FaceSectionBttonWidth*myx, 1, (FaceSectionBttonWidth-1)*myx, FaceSectionBarHeight);
            btn.tag = 100+i;
            [_sectionBar addSubview:btn];
        }else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4*FaceSectionBttonWidth*myx, 1, 375 - 4*FaceSectionBttonWidth, FaceSectionBarHeight)];
            view.backgroundColor = [UIColor whiteColor];
            [_sectionBar addSubview:view];
            btn.frame = CGRectMake(275*myx , 1, 100*myx, FaceSectionBarHeight);
            btn.backgroundColor = RGBCOLOR(103, 218, 206);
            btn.tag = 104;
            [btn setTitle:@"发送" forState:UIControlStateNormal];
            [btn setTitleColor:RGBCOLOR(73, 83, 81) forState:UIControlStateNormal];
            [_sectionBar addSubview:btn];
        }
        [btn addTarget:self action:@selector(faceBatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton *btn = (UIButton*)[_sectionBar viewWithTag:100];
    [btn setBackgroundImage:[UIImage imageNamed:@"message11"] forState:UIControlStateNormal];
    [self addSubview:_sectionBar];
}

- (void)faceBatBtnClick:(UIButton*)btn{
    if (btn.tag == 104) {
        if ([self.delegate respondsToSelector:@selector(SendFaceMessage)]) {
            [self.delegate SendFaceMessage];
        }
    }else{
        for (int i=0; i<4; i++) {
            UIButton *btn1 = (UIButton*)[_sectionBar viewWithTag:100+i];
            [btn1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"message%d",i+1]] forState:UIControlStateNormal];
        }
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"message%d%d",btn.tag-99,btn.tag-99]] forState:UIControlStateNormal];
        if (btn.tag == 100) {
            _scrollView.hidden = NO;
            pageControl.hidden = NO;
        }else{
            _scrollView.hidden = YES;
            pageControl.hidden = YES;
        }
    }
}

#pragma mark  scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/320;
    pageControl.currentPage = page;
    
}

#pragma mark ZBFaceView Delegate
- (void)didSelecteFace:(NSString *)faceName andIsSelecteDelete:(BOOL)del{
    if ([self.delegate respondsToSelector:@selector(SendTheFaceStr:isDelete:) ]) {
        [self.delegate SendTheFaceStr:faceName isDelete:del];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
