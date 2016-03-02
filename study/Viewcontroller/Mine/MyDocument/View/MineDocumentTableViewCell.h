//
//  MineDocumentTableViewCell.h
//  study
//
//  Created by mijibao on 16/1/29.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MineDocumentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *byteLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, assign) CGFloat weight;

/**
 *  根据编辑状态，改变表格视图
 *
 *  @param edit  当前是否处于编辑状态（NO-否，YES-是）
 *
 */
- (void)changeFrameWithEdit:(BOOL)edit;

/**
 *  设置文档选择按钮状态
 *
 *  @param  selectedStatus 当前文档是否处于选中状体（NO-否，YES-是）
 *
 */
- (void)setEditButtonSelected:(BOOL)selectedStatus;

- (void)addLineView;

@end



