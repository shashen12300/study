//
//  MoreView.m
//  study
//
//  Created by jzkj on 15/10/14.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "MoreView.h"

@implementation MoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"Immediate_Move"] forState:UIControlStateNormal];
    [photoButton setFrame:CGRectMake(20, 20, 70, 70)];
    photoButton.backgroundColor = [UIColor clearColor];
    photoButton.tag = MoreViewActionPhoto;
    [photoButton addTarget:self action:@selector(moreViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photoButton];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(photoButton.frame) + 10, 70, 30)];
    photoLabel.text = @"相册";
    photoLabel.backgroundColor = [UIColor clearColor];
    photoLabel.textColor = [UIColor blackColor];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:photoLabel];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"Immediate_Photo"] forState:UIControlStateNormal];
    [cameraButton setFrame:CGRectMake(110, 20, 70, 70)];
    cameraButton.backgroundColor = [UIColor clearColor];
    cameraButton.tag = MoreViewActionCamera;
    [cameraButton addTarget:self action:@selector(moreViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraButton];
    
    UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, CGRectGetMaxY(cameraButton.frame) + 10, 70, 30)];
    cameraLabel.text = @"拍摄";
    cameraLabel.backgroundColor = [UIColor clearColor];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.textColor = [UIColor blackColor];
    [self addSubview:cameraLabel];
}

- (void)moreViewAction:(UIButton *)sender
{
    MoreViewActionType type = sender.tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(receiveMoreViewAction:)]) {
        [self.delegate receiveMoreViewAction:type];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

