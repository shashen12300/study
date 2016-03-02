//
//  AttentionMsgCollectionViewCell.h
//  study
//
//  Created by mijibao on 16/2/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionMsgCollectionViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UIView *lineview;

@end
