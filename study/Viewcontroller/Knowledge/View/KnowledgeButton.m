//
//  KnowledgeButton.m
//  study
//
//  Created by mijibao on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "KnowledgeButton.h"

@implementation KnowledgeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatInit];
    }
    return self;
}

- (void)creatInit {
    self.layer.borderColor = basicColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self setTitleColor:fontColor forState:UIControlStateNormal];
    [self setTitleColor:lightColor forState:UIControlStateSelected];
}

//赋值
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = lightColor.CGColor;
    }else {
        self.layer.borderColor = basicColor.CGColor;
    }
}

@end
