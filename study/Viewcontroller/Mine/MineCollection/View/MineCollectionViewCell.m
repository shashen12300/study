//
//  MineCollectionViewCell.m
//  study
//
//  Created by mijibao on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MineCollectionViewCell.h"

@implementation MineCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSString *string = @"课程";
        CGSize size = [string sizeWithAttributes:dic];
        _subImageView = [[UIImageView alloc]initWithFrame:CGRectMake(widget_width(24), widget_width(24), 15, size.height)];
        [self.contentView addSubview:_subImageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(_subImageView) + widget_width(14), MinY(_subImageView),widget_width(330) - MaxX(_subImageView) - 10 , size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = UIColorFromRGB(0x1c1c1c);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        _videoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MinX(_subImageView), MaxY(_subImageView) + widget_width(24), widget_width(92), widget_width(92))];
        [self.contentView addSubview:_videoImageView];
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(MaxX(_videoImageView) + widget_width(14), MinY(_videoImageView) - 10, widget_width(322) - MaxX(_videoImageView), widget_width(93) + 10)];
        _textView.userInteractionEnabled = NO;
        _textView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_textView];
    }
    return self;
}

@end
