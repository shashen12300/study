//
//  PublishKeyboardView.m
//  text
//
//  Created by yang on 16/1/21.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import "PublishKeyboardView.h"

@interface PublishKeyboardView ()

@end

@implementation PublishKeyboardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(widget_width(40), CGRectGetHeight(self.frame)/4, CGRectGetHeight(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"partner_face_image"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"partner_praise"] forState:UIControlStateSelected];
        [self addSubview:button];
    }
    
    return self;
}



- (void)handleButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(showKeyboard:)]) {
        [self.delegate showKeyboard:self.isShowKeyboard];
    }
}

@end
