//
//  DetailTableViewCell.h
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *actionLabel;
@property (nonatomic, strong) UILabel *retainLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *lineView;

@end
