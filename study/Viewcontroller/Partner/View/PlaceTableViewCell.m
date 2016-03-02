//
//  PlaceTableViewCell.m
//  study
//
//  Created by mijibao on 15/8/29.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PlaceTableViewCell.h"

@interface PlaceTableViewCell ()

@property (nonatomic, strong) UILabel *cancleLabel;     
@property (nonatomic, strong) UIImageView *cancleImage;

@end

@implementation PlaceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.cancleLabel = [[UILabel alloc] initWithFrame:CGRectMake(widget_width(30), widget_width(20), widget_width(300), widget_width(40))];
        self.cancleLabel.text = @"不显示位置";
        self.cancleLabel.textColor = UIColorFromRGB(0xff7949);
        self.cancleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.cancleLabel];
        
        self.cancleImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Width - widget_width(80), widget_width(30), widget_width(30), widget_width(20))];
        self.cancleImage.image = [UIImage imageNamed:@"partner_publish_place"];
        [self.contentView addSubview:self.cancleImage];
    }
    return self;
}

@end
