//
//  PopMenuView.m
//  study
//
//  Created by mijibao on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PopMenuView.h"
#import "KnowledgeButton.h"
#import <Masonry.h>

@interface PopMenuView()

@property (nonatomic, strong) KnowledgeButton *lastSelectBtn;      //上次选中按钮
@property (nonatomic, assign) NSInteger selectGradeTag;   //选中年级tag
@property (nonatomic, assign) NSInteger selectSubjectTag; //选中学科tag
@property (nonatomic, assign) NSInteger selectSortTag;    //选中排序tag
@property (nonatomic, assign) NSInteger selectScreenTag;  //选中筛选tag
@property (nonatomic, copy) NSString *selectTitle; //选中的标题类型
@property (nonatomic, strong) UIButton *selectbutton; //选中的标题button

@end

@implementation PopMenuView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)creatInit {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)popMenuViewWithButton:(UIButton *)button popList:(NSArray *)poplist {
    _selectbutton = button;
    CGFloat maxY = 0.0;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除所有子视图
    if (button.tag == 10 ||button.tag == 11) {
        CGFloat space = 22,width = 50,height = 21,midSpace;
        midSpace = (CGRectGetWidth(self.frame)-width*4-2*space)/3;
        for (int index=0; index<poplist.count; ++index) {
            KnowledgeButton *btn = [[KnowledgeButton alloc] initWithFrame:CGRectMake(space+(width+midSpace)*(index%4), space+(height+space)*(index/4), width, height)];
            btn.tag = 10 + index;
            [btn setTitle:poplist[index] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            maxY = CGRectGetMaxY(btn.frame);
        }
        CGRect frame = self.frame;
        frame.size.height = maxY + space;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
    }else {
        NSArray *titles = [[NSArray alloc] init];
        if (button.tag == 12) {
            titles = @[@"人气最高",@"转发最多",@"发布时间由近到远",@"发布时间由远到近"];
            if (self.isAnswer) {
                titles = @[@"发布时间由近到远",@"发布时间由远到近"];
                if (!_selectSortTag) {
                    _selectSortTag = 10;
                }
            }
        } else {
            titles = @[@"收费课程",@"免费课程",@"我的老师发布的课程"];
            if (self.isAnswer) {
                titles = @[@"全部",@"我的学生提问",@"他人提问",@"已回答的问题"];
                if (!_selectScreenTag) {
                    _selectScreenTag = 10;
                }
            }
            
        }
        for (int index = 0; index < titles.count; ++index) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, (42+1)*index, WIDTH(self), 42);
            //标题 字体大小  对齐
            [btn setTitle:titles[index] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            //背景图
            [btn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
            
            //字体颜色
            [btn setTitleColor:fontColor forState:UIControlStateNormal];
            [btn setTitleColor:lightColor forState:UIControlStateSelected];
            btn.tag = 10 + index;
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            //移动字体和图片位置
            CGFloat imageX = WIDTH(btn)-MaxX(btn.imageView);
            CGFloat labelX = btn.titleLabel.frame.origin.x;
            btn.imageEdgeInsets  = UIEdgeInsetsMake(0, 0, 0,-imageX*2+50);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -labelX*2+50, 0, 0);
            maxY = CGRectGetMaxY(btn.frame);
        }
        CGRect frame = self.frame;
        frame.size.height = maxY;
        self.frame = frame;
        self.backgroundColor = RGBVCOLOR(0xdcdcdc);
    }
    //保留上次选中的按钮
    KnowledgeButton *selectBtn;
    if (button.tag == 10) {
        selectBtn = [self viewWithTag:_selectGradeTag];
    }else if (button.tag == 11) {
        selectBtn = [self viewWithTag:_selectSubjectTag];
    }else if (button.tag == 12) {
        selectBtn = [self viewWithTag:_selectSortTag];
    }else if (button.tag == 13) {
        selectBtn = [self viewWithTag:_selectScreenTag];
    }else {
        NSLog(@"异常处理");
    }
    if ([selectBtn isKindOfClass:[KnowledgeButton class]]) {
        selectBtn.selected = YES;
        _lastSelectBtn = selectBtn;
    }else if ([selectBtn isKindOfClass:[UIButton class]]) {
        selectBtn.selected = YES;
        _lastSelectBtn = selectBtn;
    }
}


//创建选择器的弹出视图
- (void)popMenuViewWithTitle:(NSString *)title popList:(NSArray *)poplist {
    _selectTitle = title;
    CGFloat maxY = 0.0;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除所有子视图
    if ([_selectTitle isEqualToString:@"年级"]||[_selectTitle isEqualToString:@"学科"]) {
        CGFloat space = 22,width = 50,height = 21,midSpace;
        midSpace = (CGRectGetWidth(self.frame)-width*4-2*space)/3;
        for (int index=0; index<poplist.count; ++index) {
            KnowledgeButton *btn = [[KnowledgeButton alloc] initWithFrame:CGRectMake(space+(width+midSpace)*(index%4), space+(height+space)*(index/4), width, height)];
            btn.tag = 10 + index;
            [btn setTitle:poplist[index] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            maxY = CGRectGetMaxY(btn.frame);
        }
        CGRect frame = self.frame;
        frame.size.height = maxY + space;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
    }else {
        NSArray *titles = [[NSArray alloc] init];
        if ([title isEqualToString:@"智能排序"]) {
            titles = @[@"人气最高",@"转发最多",@"发布时间由近到远",@"发布时间由远到近"];
            if (self.isAnswer) {
                titles = @[@"发布时间由近到远",@"发布时间由远到近"];
                if (!_selectSortTag) {
                    _selectSortTag = 10;
                }
            }
        } else {
            titles = @[@"收费课程",@"免费课程",@"我的老师发布的课程"];
            if (self.isAnswer) {
                titles = @[@"全部",@"我的学生提问",@"他人提问",@"已回答的问题"];
                if (!_selectScreenTag) {
                    _selectScreenTag = 10;
                }
            }

        }
        for (int index = 0; index < titles.count; ++index) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, (42+1)*index, WIDTH(self), 42);
            //标题 字体大小  对齐
            [btn setTitle:titles[index] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            //背景图
            [btn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];

            //字体颜色
            [btn setTitleColor:fontColor forState:UIControlStateNormal];
            [btn setTitleColor:lightColor forState:UIControlStateSelected];
            btn.tag = 10 + index;
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            //移动字体和图片位置
            CGFloat imageX = WIDTH(btn)-MaxX(btn.imageView);
            CGFloat labelX = btn.titleLabel.frame.origin.x;
            btn.imageEdgeInsets  = UIEdgeInsetsMake(0, 0, 0,-imageX*2+50);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -labelX*2+50, 0, 0);
            maxY = CGRectGetMaxY(btn.frame);
        }
        CGRect frame = self.frame;
        frame.size.height = maxY;
        self.frame = frame;
        self.backgroundColor = RGBVCOLOR(0xdcdcdc);
    }
    //保留上次选中的按钮
    KnowledgeButton *selectBtn;
    if ([_selectTitle isEqualToString:@"年级"]) {
        selectBtn = [self viewWithTag:_selectGradeTag];
    }else if ([_selectTitle isEqualToString:@"学科"]) {
        selectBtn = [self viewWithTag:_selectSubjectTag];
    }else if ([_selectTitle isEqualToString:@"智能排序"]) {
        selectBtn = [self viewWithTag:_selectSortTag];
    }else if ([_selectTitle isEqualToString:@"筛选"]) {
        selectBtn = [self viewWithTag:_selectScreenTag];
    }else {
        NSLog(@"异常处理");
    }
    if ([selectBtn isKindOfClass:[KnowledgeButton class]]) {
        selectBtn.selected = YES;
        _lastSelectBtn = selectBtn;
    }else if ([selectBtn isKindOfClass:[UIButton class]]) {
        selectBtn.selected = YES;
        _lastSelectBtn = selectBtn;
    }
}

//点击按钮
- (void)btnClick:(KnowledgeButton *)sender {
    if (sender.tag == _lastSelectBtn.tag) {
        sender.selected = NO;
        _lastSelectBtn = nil;
    }else {
    _lastSelectBtn.selected = NO;
    sender.selected = YES;
    _lastSelectBtn = sender;
    }
    if (_selectbutton.tag == 10) {
        _selectGradeTag = _lastSelectBtn.tag;
    }else if (_selectbutton.tag == 11) {
        _selectSubjectTag = _lastSelectBtn.tag;
    }else if (_selectbutton.tag == 12) {
        _selectSortTag = _lastSelectBtn.tag;
    }else if (_selectbutton.tag == 13) {
        _selectScreenTag = _lastSelectBtn.tag;
    }else {
        NSLog(@"异常处理");
    }
    
    if ([self.delegate respondsToSelector:@selector(popMenuView:didSelected:popButton:)]) {
        [self.delegate popMenuView:self didSelected:_lastSelectBtn.titleLabel.text popButton:_selectbutton];
    }
    
    if ([self.delegate respondsToSelector:@selector(popMenuView:didSelected:popTitle:)]) {
        [self.delegate popMenuView:self didSelected:_lastSelectBtn.titleLabel.text popTitle:_selectTitle];
    }
}

@end
