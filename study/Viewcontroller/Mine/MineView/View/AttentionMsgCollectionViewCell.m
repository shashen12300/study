//
//  AttentionMsgCollectionViewCell.m
//  study
//
//  Created by mijibao on 16/2/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AttentionMsgCollectionViewCell.h"

@implementation AttentionMsgCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图片
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 17.5;
        _headView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_headView];
        //昵称
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_headView) + 16, 10, 100, 15)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = UIColorFromRGB(0xff6949);
        _nickNameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nickNameLabel];
        //时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MinX(_nickNameLabel), MaxY(_nickNameLabel) + 8, 150, 10)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.textColor = UIColorFromRGB(0x999999);
        [self.contentView addSubview:_timeLabel];
        //关注按钮
        _attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Width - 60, 15, 50, 25)];
        [_attentionBtn setImage:[UIImage imageNamed:@"Mine_AttentionBtn"] forState:UIControlStateNormal];
        [self.contentView addSubview:_attentionBtn];
        //横线
        _lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 54, Main_Width, 1)];
        _lineview.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [self.contentView addSubview:_lineview];
    }
    return self;
}


@end
