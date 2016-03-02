//
//  MineDocumentTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/29.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MineDocumentTableViewCell.h"

@implementation MineDocumentTableViewCell

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
        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 16, 18, 18)];
        _editBtn.layer.cornerRadius = 9;
        _editBtn.layer.masksToBounds = YES;
//        _editBtn.selected = NO;
        //图片
        _typeImageView = [[UIImageView alloc] init];
        _typeImageView.backgroundColor = [UIColor grayColor];
        //标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x373737);
        //大小
        _byteLabel = [[UILabel alloc] init];
        _byteLabel.textAlignment = NSTextAlignmentLeft;
        _byteLabel.font = [UIFont systemFontOfSize:9];
        _byteLabel.textColor = UIColorFromRGB(0x919191);
        //时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.textColor = UIColorFromRGB(0x919191);
        //横线
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
        [self.contentView addSubview:_editBtn];
        [self.contentView addSubview:_typeImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_lineView];
        [self.contentView addSubview:_byteLabel];
        [self.contentView addSubview:_timeLabel];
        [self setClassViewFrame];
        }
    return self;
}

- (void)changeFrameWithEdit:(BOOL)edit
{
    if (edit) {
        _editBtn.userInteractionEnabled = YES;
        _editBtn.hidden = NO;
        self.weight = 40;
    }else{
        _editBtn.userInteractionEnabled = NO;
        _editBtn.hidden = YES;
        self.weight = 18;
    }
    [self setClassViewFrame];
}

- (void)setClassViewFrame
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
    NSString *string = @"收支明细";
    CGSize size1 = [string sizeWithAttributes:dic];
    CGSize size2 = [string sizeWithAttributes:dic2];
    _typeImageView.frame = CGRectMake(self.weight, 7, 36, 36);
    _titleLabel.frame = CGRectMake(MaxX(_typeImageView) + 14, MinY(_typeImageView), Main_Width - MaxX(_typeImageView) - 14 - 30 , size1.height);
    _byteLabel.frame = CGRectMake(MinX(_titleLabel), MaxY(_titleLabel) + 2, Main_Width - MaxX(_typeImageView) - 14 - 30, size2.height);
    _timeLabel.frame = CGRectMake(MinX(_byteLabel), MaxY(_byteLabel) + 2, Main_Width - MaxX(_typeImageView) - 14 - 30, size2.height);
    _lineView.frame = CGRectMake(MinX(_typeImageView), 49, Main_Width - MinX(_typeImageView), 1);
}

- (void)setEditButtonSelected:(BOOL)selectedStatus{
    _editBtn.selected = NO;
}

- (void)addLineView
{
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    _lineView.frame = CGRectMake(MinX(_typeImageView), 49, Main_Width - MinX(_typeImageView), 1);
    [self.contentView addSubview:_lineView];
}
@end
