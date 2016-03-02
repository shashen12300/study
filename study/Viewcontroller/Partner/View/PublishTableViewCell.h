//
//  PublishTableViewCell.h
//  study
//  朋友圈发布界面cell
//  Created by yang on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *showImage;   // 图片
@property (nonatomic, strong) UILabel *showLabel;       // label
@property (nonatomic, strong) UIView *showImageView;    // 提醒人头像的展示view
@property (nonatomic, strong) NSArray *alertArray;      // 提醒数据数组
@property (nonatomic, assign) NSInteger cellHeight;     // cell高度

// 重置控件frame
- (void)reloadFrame;

@end
