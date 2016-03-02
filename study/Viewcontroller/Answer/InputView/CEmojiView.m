//
//  CEmojiView.m
//  study
//
//  Created by jzkj on 15/10/14.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "CEmojiView.h"
#import "CInputView.h"
@interface CEmojiView ()
{
    UIScrollView *myScrollView; //表情分页容器scrollview
    UIPageControl *pageControl; //切换页面pagecontrol
    BOOL pageControlIsChanging; //标示pageControl已经变化
}

//初始化组件
- (void)initControls;

@end

@implementation CEmojiView
//初始化
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.faceArray = [[ NSMutableArray alloc] init];
        self.imageArray = [[NSMutableArray alloc] init];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
        NSArray  *face = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in face) {
            [self.faceArray addObject:[dict objectForKey:@"cht"]];
            [self.imageArray addObject:[dict objectForKey:@"png"]];
        }
        
        [self initControls];
    }
    return self;
}
//初始化组件
- (void)initControls {
    //scrollview初始化
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, self.frame.size.height - 20)];
    myScrollView.contentSize = CGSizeMake(Main_Width * 5, self.frame.size.height - 20);
    myScrollView.pagingEnabled = YES;
    myScrollView.scrollEnabled = YES;
    myScrollView.delegate = self;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.userInteractionEnabled = YES;
    myScrollView.minimumZoomScale = 1;
    myScrollView.maximumZoomScale = 1;
    myScrollView.decelerationRate = 0.01f;
    myScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:myScrollView];
    
    CGFloat vSpace = (self.frame.size.height - 20 - 90)/4; // 垂直间隔
    CGFloat  hSpace = (Main_Width - 210) / 8; // 水平间隔
    
    int index = 0; //当前位置
    NSString *imagePath = @"";
    
    for(int i = 0; i < 5; i++) {
        int x = Main_Width * i, y = 0;
        
        for(int j = 0; j < 21; j++){
            if(index >= [_faceArray count] + 1)
                break;
            UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            faceButton.frame = CGRectMake(x + hSpace, y + vSpace, 30.0f, 30.0f);
            faceButton.tag = index;
            //添加删除按钮
            if((i < 4 && j == 20) || (i == 4 && j == 20)){
                faceButton.frame = CGRectMake(x + hSpace, y + vSpace + 3, 30.0f, 24.0f);
                [faceButton addTarget:self action:@selector(actionDelete:)forControlEvents:UIControlEventTouchUpInside];
                [faceButton setBackgroundImage:[UIImage imageNamed:@"del_btn_press.png"] forState:UIControlStateNormal];
            }
            //添加表情按钮
            else if ((i < 4 && j < 21) || (i == 4 && j < 20)){
                imagePath = [self.imageArray objectAtIndex:index];
                [faceButton addTarget:self action:@selector(actionSelect:)forControlEvents:UIControlEventTouchUpInside];
                index++;
                if(fmod(i * 21 + j + 1, 7) == 0.0f && j >= 6){
                    x = Main_Width * i;
                    y += (30 + vSpace / 2);
                }else
                    x += 30 + hSpace;
                
                [faceButton setBackgroundImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
            }
            [myScrollView addSubview:faceButton];
        }
    }
    
    //初始化pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((Main_Width - 120) / 2, self.frame.size.height - 30, 120, 30)];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor greenColor]];
    pageControl.numberOfPages  = 5;
    [pageControl addTarget:self action:@selector(actionPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pageControl];
}

//表情按钮触发方法
- (void)actionSelect:(UIButton *)sender {
    NSString *faceName = [self.faceArray objectAtIndex:sender.tag];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(appendEmojiString:)]) {
        [self.delegate appendEmojiString:faceName];
    }
}
// 删除表情按钮触发方法
- (void)actionDelete:(UIView*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteEmojiString)]) {
        [self.delegate deleteEmojiString];
    }
}
//
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / Main_Width;
    int mod = fmod(scrollView.contentOffset.x, Main_Width);
    if( mod >= 160)
        index++;
    pageControl.currentPage = index;
}

//切换滑动视图
- (void) setPage {
    myScrollView.contentOffset = CGPointMake(Main_Width * pageControl.currentPage, 0.0f);
    [pageControl setNeedsDisplay];
}
//切换滑动视图
-(void)actionPage {
    [self setPage];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
