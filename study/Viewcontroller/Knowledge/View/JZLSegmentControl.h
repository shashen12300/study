//
//  JZLSegmentControl.h
//  study
//  分段控制器
//  Created by jiaozl on 15/8/28.
//  Copyright (c) 2015年 jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define baseTag   10
@class JZLSegmentControl;
@protocol JZLSegmentControlDelegate <NSObject>

- (void)segmentControl:(JZLSegmentControl *)segmentControl didselected:(NSString *)title isSelected:(BOOL)selected; //弃用

- (void)segmentControl:(JZLSegmentControl *)segmentControl button:(UIButton *)button;//替代

@end

@interface JZLSegmentControl: UIView

@property (nonatomic, weak) UIButton *selectedButton;   //选择
@property (nonatomic, assign) id <JZLSegmentControlDelegate> segmentDelegate;  //代理

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (id)initWithUploadFrame:(CGRect)frame titles:(NSArray *)titles;
- (void)setTitle:(NSString *)title withIndex:(NSInteger)index;
- (NSString *)titleWithIndex:(NSInteger)index;

@end
