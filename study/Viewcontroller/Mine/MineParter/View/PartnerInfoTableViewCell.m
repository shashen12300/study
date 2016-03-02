//
//  PartnerInfoTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PartnerInfoTableViewCell.h"

@implementation PartnerInfoTableViewCell

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
        //行标签
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSString *string = @"所获荣誉：";
        CGSize size = [string sizeWithAttributes:dic];
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(13 , 0, size.width, 60)];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = [UIFont systemFontOfSize:13];
        _leftLabel.textColor = UIColorFromRGB(0x656565);
        [self.contentView addSubview:_leftLabel];
        //图片
        for (int i = 0; i < 4; i ++) {
            UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(MaxX(_leftLabel) + 5 + i * widget_width(130), (60 - widget_width(80)) * 0.5, widget_width(100), widget_width(80))];
            cellImage.tag =1000 + 1;
            [self.contentView addSubview:cellImage];
        }
        _cellImageViewOne = (UIImageView *)[self viewWithTag:1000];
        _cellImageViewTwo = (UIImageView *)[self viewWithTag:1001];
        _cellImageViewTrd = (UIImageView *)[self viewWithTag:1002];
        _cellImageViewFor = (UIImageView *)[self viewWithTag:1003];
    }
    return self;
}


@end
