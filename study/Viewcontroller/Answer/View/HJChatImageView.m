//
//  HJChatImageView.m
//  study
//
//  Created by jzkj on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "HJChatImageView.h"


@interface HJChatImageView (){
    CAShapeLayer *_maskLayer;
    HJChatImageStyle _viewStyle;
}

@end

@implementation HJChatImageView
- (instancetype)initWithImageStyle:(HJChatImageStyle)style Frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _viewStyle = style;
        [self setup];
    }
    return self;
}


- (void)setup{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
    }
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor clearColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.7, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    UIImage *chatImage = nil;
    if (_viewStyle == HJChatImageStyleLeft) {
        UIImage *leftimage=[UIImage imageNamed:@"chat_from_bg_normal"];
        chatImage = [leftimage stretchableImageWithLeftCapWidth:10 topCapHeight:30];
    }else{
        UIImage *rightimage=[UIImage imageNamed:@"chat_to_bg_normal"];
        chatImage = [rightimage stretchableImageWithLeftCapWidth:10 topCapHeight:30];
    }
    _maskLayer.contents = (id)chatImage.CGImage;
    if (! _contentLayer) {
        _contentLayer = [CALayer layer];
        [self.layer addSublayer:_contentLayer];
    }
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _contentLayer.contents = (id)image.CGImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
