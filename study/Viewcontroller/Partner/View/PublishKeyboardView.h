//
//  PublishKeyboardView.h
//  text
//  朋友圈发布界面键盘
//  Created by yang on 16/1/21.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublishKeyboardViewDelegate <NSObject>
/**
 *  朋友圈发布键盘
 *
 *  @param isKeyboard YES:展示键盘   NO:展示表情
 */
- (void)showKeyboard:(BOOL)isKeyboard;

@end

@interface PublishKeyboardView : UIView

@property (nonatomic, assign) BOOL isShowKeyboard;    // 是否展示键盘  YES:展示键盘   NO:展示表情

@property (nonatomic, weak) id<PublishKeyboardViewDelegate> delegate;

@end
