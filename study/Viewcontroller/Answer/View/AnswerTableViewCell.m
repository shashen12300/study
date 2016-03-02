//
//  AnswerTableViewCell.m
//  study
//
//  Created by jzkj on 16/2/14.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AnswerTableViewCell.h"

@implementation AnswerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10, 10, Main_Width - 20, 80)];
        backview.layer.cornerRadius = 5;
        backview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backview];
        _iconimage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 10, 15)];
        _iconimage.image = [UIImage imageNamed:@"answer_icon"];
        [backview addSubview:_iconimage];
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, Main_Width - 50, 15 )];
        _contentLabel.textColor = UIColorFromRGB(0x1c1c1c);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.text = @"wakaka wenticeshi";
        _contentLabel.numberOfLines = 2;
        [backview addSubview:_contentLabel];
    }
    return self;
}



@end
