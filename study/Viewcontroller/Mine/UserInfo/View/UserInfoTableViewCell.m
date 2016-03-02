//
//  UserInfoTableViewCell.m
//  study
//
//  Created by mijibao on 15/9/20.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

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
        //左侧标签
        _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
        _signLabel.textColor = UIColorFromRGB(0x656565);
        _signLabel.textAlignment = NSTextAlignmentLeft;
        _signLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_signLabel];
        //信息栏
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(_signLabel) + 10, 0, Main_Width - MaxX(_signLabel) - 10 - 35, 40)];
        _infoLabel.textAlignment = NSTextAlignmentRight;
        _infoLabel.textColor = UIColorFromRGB(0xa9a9a9);
        _infoLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_infoLabel];
        //头像
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(MaxX(_infoLabel) - 30, 5, 30, 30)];
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 15;
        [self.contentView addSubview:_headView];
        //分割线
        _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(MinX(_signLabel), 38.5, Main_Width - 2 * MinX(_signLabel) , 1.5)];
        _lineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

@end
