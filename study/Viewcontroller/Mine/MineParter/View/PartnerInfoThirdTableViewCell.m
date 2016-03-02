//
//  PartnerInfoThirdTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PartnerInfoThirdTableViewCell.h"

@implementation PartnerInfoThirdTableViewCell

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
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_height(80))];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label];
    }
    return self;
}

@end
