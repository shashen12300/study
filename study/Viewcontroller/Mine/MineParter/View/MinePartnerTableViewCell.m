//
//  MinePartnerTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MinePartnerTableViewCell.h"

@implementation MinePartnerTableViewCell

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
        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 30, 30)];
        _cellImageView.layer.masksToBounds = YES;
        _cellImageView.layer.cornerRadius = 15;
        [self.contentView addSubview:_cellImageView];
        //行标签
        _cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(_cellImageView) + 14, 0, Main_Width - MaxX(_cellImageView) - 14, 55)];
        _cellLabel.font = [UIFont systemFontOfSize:15];
        _cellLabel.textColor = UIColorFromRGB(0x3d3d3d);
        _cellLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_cellLabel];
        //横线
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 54, Main_Width, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [self.contentView addSubview:_lineView];
    }
    return self;
}


@end
