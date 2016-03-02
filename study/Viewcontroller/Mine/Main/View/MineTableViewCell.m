//
//  MineTableViewCell.m
//  study
//
//  Created by mijibao on 15/10/16.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

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
        _cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 40)];
        [self.contentView addSubview:_cellImageView];
        //消息提示红点
        _alertView = [[UIImageView alloc]initWithFrame:CGRectMake(widget_width(70) + widget_height(68) - widget_width(18), widget_height(32)/2 -widget_width(23) + widget_width(32), widget_height(23), widget_height(23))];
        [self.contentView addSubview:_alertView];
        //行标签
        _cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 200, 40)];
        _cellLabel.font = [UIFont systemFontOfSize:13];
        _cellLabel.textColor = UIColorFromRGB(0x656565);
        _cellLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_cellLabel];
        //横线
        _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 39, Main_Width, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [self.contentView addSubview:_lineView];
    }
    return self;
}


@end
