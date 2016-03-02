//
//  HJAlertView.m
//  study
//
//  Created by jzkj on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//
#define KButtonHeight 40
#define KTextFont 14
#import "HJAlertView.h"
#import "AppDelegate.h"

@interface HJAlertView (){
//    UIView *backView;//背景视图
}
@property (nonatomic ,copy) SelectIndex selectIndex;
@end


@implementation HJAlertView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
*  底部alert
*
*  @param titles      title数组
*  @param selectIndex 回调block 从0开始
*/
- (void)showBottomAlertViewWithTitles:(NSArray *)titles ClickBtn:(SelectIndex)selectIndex{
    self.selectIndex = selectIndex;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    UIView *alertview = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height - (titles.count + 1) * 47, Main_Width, (titles.count + 1) * 47)];
    alertview.backgroundColor = RGBCOLOR(202, 202, 202);
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 46 * idx, Main_Width, 45);
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x3b3b3b) forState:UIControlStateNormal];
        btn.tag = 140 + idx;
        [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertview addSubview:btn];
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,(titles.count + 1) * 47 -45 , Main_Width, 45);
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x3b3b3b) forState:UIControlStateNormal];
    btn.tag = 139;
    [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [alertview addSubview:btn];
    [self addSubview:alertview];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:self];
}
- (void)alertBtnClick:(UIButton *)btn{
    if (!self.selectIndex) {
        [self removeFromSuperview];
        return;
    }
    switch (btn.tag){
        case 140:
            _selectIndex(0);
            break;
        case 141:
            _selectIndex(1);
            break;
        case 142:
            _selectIndex(2);
            break;
        case 143:
            _selectIndex(3);
            break;
        case 144:
            _selectIndex(4);
            break;
        default:
            break;
            
    }
    [self removeFromSuperview];
}

- (void)showAlertViewWithContent:(NSString *)content cancelBtnTitle:(NSString *)cancel otherBtnTitle:(NSString *)other isAutoHidden:(BOOL)hidden selectBlock:(SelectIndex)selectIndex{
    self.frame = [UIScreen mainScreen].bounds;
    if (!cancel && !other) {
         UITapGestureRecognizer * tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAlertView)];
        [self addGestureRecognizer:tapBack];
    }
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.8;
    [self addSubview:backView];
    self.selectIndex = selectIndex;
    CGFloat viewHeight = 0;
    CGSize titleSize = [JZCommon sizeOfText:content withFont:[UIFont systemFontOfSize:KTextFont] consstrainSize:(CGSize){Main_Width - 190 , 1000}];
    viewHeight = titleSize.height + 30;
    if (cancel || other) {
        viewHeight += KButtonHeight;
    }
    UIView *alertview = [[UIView alloc] initWithFrame:CGRectMake(90,( Main_Height - viewHeight) / 2 , Main_Width - 180, viewHeight)];
    
    alertview.backgroundColor = RGBCOLOR(229, 230, 231);
    alertview.layer.cornerRadius = 5;
    alertview.clipsToBounds = YES;
    UILabel *messagelab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, Main_Width - 190, titleSize.height + 30)];
    messagelab.backgroundColor = [UIColor whiteColor];
    messagelab.text = content;
    messagelab.numberOfLines = 0;
    messagelab.textAlignment = NSTextAlignmentCenter;
    messagelab.font = [UIFont systemFontOfSize:KTextFont];
    messagelab.textColor = UIColorFromRGB(0x626262);
    UIView *backTextview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width - 180 , titleSize.height + 30)];
    backTextview.backgroundColor = [UIColor whiteColor];
    [alertview addSubview:backTextview];
    [alertview addSubview:messagelab];
    if (cancel && other) {
        UIButton *cancelbtn = [self createBtnWithTiltle:cancel tag:140 frame:CGRectMake(0, titleSize.height + 31, (Main_Width - 180)/2 -1, KButtonHeight)];
        [alertview addSubview:cancelbtn];
        UIButton *otherbtn = [self createBtnWithTiltle:other tag:141 frame:CGRectMake((Main_Width - 180)/2 , titleSize.height + 31 , (Main_Width - 180)/2, KButtonHeight)];
        [alertview addSubview:otherbtn];
    }else {
        if (cancel) {
            UIButton *cancelbtn = [self createBtnWithTiltle:cancel tag:140 frame:CGRectMake(0, titleSize.height + 31 , (Main_Width - 180), KButtonHeight)];
            [alertview addSubview:cancelbtn];
        }
        if (other) {
            UIButton *otherBtn = [self createBtnWithTiltle:other tag:140 frame:CGRectMake(0, titleSize.height + 31 , (Main_Width - 180), KButtonHeight)];
            [alertview addSubview:otherBtn];
        }
    }
    [self addSubview:alertview];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:self];
    if (hidden) {
        [self performSelector:@selector(hiddenAlertView) withObject:nil afterDelay:1.0];
    }
}
//创建btn
- (UIButton *)createBtnWithTiltle:(NSString *)title tag:(NSInteger)tag frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x3b3b3b) forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)hiddenAlertView{
    [self removeFromSuperview];
}

- (AppDelegate *)appDeleGate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
