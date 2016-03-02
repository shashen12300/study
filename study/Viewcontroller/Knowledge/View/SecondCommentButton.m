//
//  SecondCommentButton.m
//  study
//
//  Created by mijibao on 16/2/18.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "SecondCommentButton.h"

@interface SecondCommentButton()

@property (nonatomic, strong) UIImageView *headImageView; //评论照片
@property (nonatomic, strong) UILabel *nameLabel;  //评论名字
@property (nonatomic, strong) UILabel *timeLabel;  //评论时间
@property (nonatomic, strong) UILabel *contentLabel;  //评论内容

@end

@implementation SecondCommentButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //头像
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        [self addSubview:_headImageView];
        //名字
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_headImageView)+10, 5, 50, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = RGBVCOLOR(0x3F3834);
        [self addSubview:_nameLabel];
        //时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_nameLabel)+5, 7, 90, 18)];
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.textColor = RGBVCOLOR(0xA6A6A6);
        [self addSubview:_timeLabel];
        //内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_headImageView)+10, MaxY(_nameLabel), CGRectGetWidth(frame) - MaxX(_headImageView) - 10, 30)];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = RGBVCOLOR(0x808080);
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
    }
    return  self;
}

//设置cell内容和高度
- (void)setMessage:(SecondCommentModel *)message {
    _message = message;
    _headImageView.image = [UIImage imageNamed:message.image];
    _nameLabel.text = message.name;
    _timeLabel.text = message.time;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSLog(@"宽度 : %f",WIDTH(_contentLabel));
    CGSize contentSize = [message.content boundingRectWithSize:CGSizeMake(WIDTH(_contentLabel), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    _contentLabel.height = contentSize.height + 10;
    _cellHeight = MaxY(_contentLabel) + 5;
    self.height = _cellHeight;
    _contentLabel.text = message.content;
}


@end
