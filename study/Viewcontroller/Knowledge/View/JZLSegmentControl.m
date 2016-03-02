//
//  JZLSegmentControl.m
//  study
//
//  Created by jiaozl on 15/8/28.
//  Copyright (c) 2015年 jiaozl. All rights reserved.
//

#import "JZLSegmentControl.h"
#import <Masonry.h>

@interface JZLSegmentControl()


@end

@implementation JZLSegmentControl

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        NSUInteger segmentCount = [titles count];
        float segmentWidth = (frame.size.width - segmentCount + 1) / segmentCount;//中间加线
        self.backgroundColor = [UIColor whiteColor];
        //中间线
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = RGBVCOLOR(0xdcdcdc);
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        for ( int i= 0 ; i<segmentCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button. frame = CGRectMake ((segmentWidth + 1) * i, 0, segmentWidth, frame.size.height);
            button.tag = baseTag + i;
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(segmentAction:) forControlEvents : UIControlEventTouchUpInside];
            // 文字 字号
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            // 背景图   //selectTrigon
            [button setImage:[UIImage imageNamed:@"normalTrigon"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"selectTrigon"] forState:UIControlStateSelected];
            //字体大小
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            //字体颜色
            [button setTitleColor:fontColor forState:UIControlStateNormal];
            [button setTitleColor:lightColor forState:UIControlStateSelected];
            [self addSubview:button];
            CGFloat imageWidth = button.imageView.frame.size.width;
            CGFloat labelWidth = button.titleLabel.frame.size.width;
            button.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 7, 0, -labelWidth);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - 7, 0, imageWidth);
        }
    }
    return self ;
}
//初始化上传分栏控制
- (id)initWithUploadFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        NSUInteger segmentCount = [titles count];
        float segmentWidth = (frame.size.width - segmentCount + 1) / segmentCount;//中间加线
        self.backgroundColor = [UIColor whiteColor];
        //中间线
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = RGBVCOLOR(0xdcdcdc);
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        for ( int i= 0 ; i<segmentCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button. frame = CGRectMake ((segmentWidth + 1) * i, 0, segmentWidth, frame.size.height);
            button.tag = baseTag + i;
            button.backgroundColor = [UIColor whiteColor];

            // 文字 字号
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            // 背景图   //selectTrigon
            if (i>0) {
                [button setImage:[UIImage imageNamed:@"normalTrigon"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"selectTrigon"] forState:UIControlStateSelected];
                [button addTarget:self action:@selector(segmentUploadAction:) forControlEvents : UIControlEventTouchUpInside];
                [button setTitleColor:fontColor forState:UIControlStateNormal];

            }
            else {
                [button setTitleColor:lightColor forState:UIControlStateNormal];
            }
            //字体大小
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            //字体颜色
            [button setTitleColor:lightColor forState:UIControlStateSelected];
            [self addSubview:button];
            CGFloat imageWidth = button.imageView.frame.size.width;
            CGFloat labelWidth = button.titleLabel.frame.size.width;
            button.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + 7, 0, -labelWidth);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - 7, 0, imageWidth);
        }
    }
    return self ;
}

// 内部方法
-(void)segmentAction:(UIButton *)sender
{
    if (self.selectedButton == sender) {
        self.selectedButton.selected = !sender.selected;
    } else {
        self.selectedButton.selected = NO;
        sender.selected = YES;
        self.selectedButton = sender;
    }
    if ([self.segmentDelegate respondsToSelector:@selector(segmentControl:button:)]) {
        [self.segmentDelegate segmentControl:self button:sender];

    }else if ([self.segmentDelegate respondsToSelector:@selector(segmentControl:didselected:isSelected:)]) {
        [self.segmentDelegate segmentControl:self didselected:self.selectedButton.titleLabel.text isSelected:self.selectedButton.selected];
    }
}

-(void)segmentUploadAction:(UIButton *)sender
{
    if (self.selectedButton == sender) {
        self.selectedButton.selected = !sender.selected;
    } else {
        self.selectedButton.selected = NO;
        sender.selected = YES;
        self.selectedButton = sender;
    }
    [self.segmentDelegate segmentControl:self didselected:self.selectedButton.titleLabel.text isSelected:self.selectedButton.selected];
}

// 外部调用
- (void)setTitle:(NSString *)title withIndex:(NSInteger)index{
    if (title) {
        UIButton *button = (UIButton *)[self viewWithTag:index];
        [button setTitle:title forState:UIControlStateNormal];
    }
    self.selectedButton.selected = NO;
}
- (NSString *)titleWithIndex:(NSInteger)index{
    UIButton *button = (UIButton *)[self viewWithTag:baseTag + index];
    return button.currentTitle;
}


@end
