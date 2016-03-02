//
//  DetailTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

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
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        NSString *string = @"收支明细";
        CGSize size1 = [string sizeWithAttributes:dic];
        CGSize size2 = [string sizeWithAttributes:dic2];
        _actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 9, Main_Width * 0.5, size1.height)];
        _actionLabel.textColor = UIColorFromRGB(0x656565);
        _actionLabel.textAlignment = NSTextAlignmentLeft;
        _actionLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_actionLabel];
        
        _retainLabel = [[UILabel alloc] initWithFrame:CGRectMake(MinX(_actionLabel), MaxY(_actionLabel) + 5 , Main_Width * 0.5, size2.height)];
        _retainLabel.textColor = UIColorFromRGB(0x656565);
        _retainLabel.textAlignment = NSTextAlignmentLeft;
        _retainLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_retainLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_Width * 0.5, MinY(_actionLabel) , Main_Width * 0.5 - 12, size1.height)];
        _timeLabel.textColor = UIColorFromRGB(0xa3a3a3);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:9];
        [self.contentView addSubview:_timeLabel];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_Width * 0.5, MinY(_retainLabel) , Main_Width * 0.5 - 12, size2.height)];
        _countLabel.textColor = UIColorFromRGB(0x656565);
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_countLabel];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 49, Main_Width - 24, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [self.contentView addSubview:_lineView];
    }
    return self;
}


@end
