//
//  PopMenuView.h
//  study
//
//  Created by mijibao on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopMenuView;
@protocol PopMenuViewDelegate <NSObject>

- (void)popMenuView:(PopMenuView *)popMenuView didSelected:(NSString *)title popTitle:(NSString *)popTitle;//弃用

- (void)popMenuView:(PopMenuView *)popMenuView didSelected:(NSString *)title popButton:(UIButton *)button;//替代

@end

@interface PopMenuView : UIView

@property (nonatomic, assign) id<PopMenuViewDelegate> delegate; //代理
@property (nonatomic) BOOL isAnswer;//及时答界面
- (void)popMenuViewWithTitle:(NSString *)title popList:(NSArray *)poplist;//弃用
- (void)popMenuViewWithButton:(UIButton *)button popList:(NSArray *)poplist;//替代


@end
