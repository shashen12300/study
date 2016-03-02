//
//  FaceView.m
//  study
//
//  Created by yang on 15/10/15.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "FaceView.h"
#import "JHFacePlist.h"

@implementation FaceView

{
    UIPageControl  *_pageControl;
    UIScrollView   *_scrollView;
    NSMutableArray *_imageViews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _scrollView.contentSize = CGSizeMake(5*CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _scrollView.backgroundColor = UIColorFromRGB(0xeeeeee);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        [self configImageViews];
        [self configScrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-50, CGRectGetHeight(self.frame)-15, 100, 10)];
        _pageControl.layer.cornerRadius = 2.5;
        _pageControl.numberOfPages = 5;
        _pageControl.backgroundColor = UIColorFromRGB(0x999999);
        _pageControl.alpha = 0.5;
        _pageControl.userInteractionEnabled = YES;
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)configImageViews
{
    _imageViews = [NSMutableArray array];
    for (NSUInteger i=1; i != 106; ++i) {
        NSString *str = [NSString stringWithFormat:@"Expression_%lu",(unsigned long)i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
        [_imageViews addObject:imgView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:gesture];
    }
}

- (void)configScrollView
{
    CGFloat gapWidth = (CGRectGetWidth(self.frame)-24*8)/9;
    UIView *contentView = nil;
    for (NSInteger index=0; index!=105; ++index) {
        if ((index%24) == 0) {
            contentView = [[UIView alloc] initWithFrame:CGRectMake((index/24) * CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame)-gapWidth, CGRectGetHeight(self.frame))];
            [_scrollView addSubview:contentView];
        }
        CGRect frame = CGRectMake(0, 0, 24, 24);
        if (index+1 <= _imageViews.count) {
            UIImageView *imageView = [_imageViews objectAtIndex:index];
            frame.origin.x = gapWidth + (gapWidth+24)*(index%8);
            frame.origin.y = 10 + 30*(index/8%3);
            imageView.frame = frame;
            [contentView addSubview:imageView];
        }
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / CGRectGetWidth(self.frame);
}

#pragma mark - 私有方法
- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    JHFacePlist *facePlist = [JHFacePlist sharedInstance];
    NSMutableString *imgName = nil;
    UIImageView *imageView = (UIImageView *)gesture.view;
    for (NSInteger index=0; index!=105; ++index) {
        if (imageView == [_imageViews objectAtIndex:index]) {
            imgName = [NSMutableString stringWithFormat:@"Expression_%ld",index+1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TYPE_INTO_TEXTVIEW" object:self userInfo:[NSDictionary dictionaryWithObject:[facePlist getFileNameWithImageName:imgName] forKey:@"faceName"]];
        }
    }
}

- (void)pageControlValueChanged:(UIControl *)control
{
    if (![control isKindOfClass:[UIPageControl class]]) {
        return  ;
    }
    UIPageControl *pageControl = (UIPageControl *)control;
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame) * pageControl.currentPage, 0);
}


@end
