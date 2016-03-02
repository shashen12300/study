//
//  MyBankTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MyBankTableViewCell.h"

@implementation MyBankTableViewCell

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
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSString *string = @"收支明细";
        CGSize size1 = [string sizeWithAttributes:dic];
        CGSize size2 = [string sizeWithAttributes:dic2];
        _signImage = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(20), widget_height(25), widget_height(64),widget_height(64))];
        [self.contentView addSubview:_signImage];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_signImage) + widget_width(34), MinX(_signImage), Main_Width - widget_width(72) - MaxX(_signImage) - widget_width(54), size1.height)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MinX(_nameLabel), MaxY(_nameLabel) + widget_height(10), Main_Width - MaxX(_signImage) - widget_width(54) - widget_width(72), size2.height)];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_typeLabel];
        _cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(_signImage) + widget_height(10), Main_Width - widget_width(26) - widget_width(72), size2.height)];
        _cardLabel.textAlignment = NSTextAlignmentRight;
        _cardLabel.textColor = [UIColor whiteColor];
        _cardLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_cardLabel];
     
    }
    return self;
}

@end
