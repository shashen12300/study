//
//  PersonHistoryTableViewCell.h
//  study
//  朋友圈动态cell
//  Created by mijibao on 15/9/17.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerAllModel.h"

@protocol PersonHistoryTableViewCellDelegate <NSObject>
/**
 *  展示图片
 *
 *  @param imageArr  要展示的图片数组
 *  @param imageView 展示的图片
 */
- (void)showImagesWithImageViews:(NSArray *)imageArr selectedView:(UIImageView *)imageView;
/**
 *  
 *
 *  @param lectureId 大课id
 */
- (void)playWithLectureId:(NSString *)lectureId;

@end

@interface PersonHistoryTableViewCell : UITableViewCell

@property (nonatomic, weak)   id <PersonHistoryTableViewCellDelegate> delegate;

@property (nonatomic, strong) PartnerAllModel *model;
@property (nonatomic, strong) UIImageView *backImageView; // 内容和图片底图

@property (nonatomic, strong) UILabel *dayLabel;          // 日
@property (nonatomic, strong) UILabel *monthLabel;        // 月
@property (nonatomic ,strong) UIImageView *lineImage;     // 虚线
@property (nonatomic, strong) NSIndexPath *indexPath;

// 计算cell高度
+ (CGFloat)cellHeight:(PartnerAllModel *)model;

@end
