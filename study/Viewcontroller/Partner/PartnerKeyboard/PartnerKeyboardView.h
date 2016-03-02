//
//  PartnerKeyboardView.h
//  study
//  朋友圈评论键盘
//  Created by yang on 15/9/30.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PartnerKeyboardViewDelegate <NSObject>

/**
 *  发送评论
 *
 *  @param text 评论的内容
 */
- (void)clickSendButton:(NSString *)text;
/**
 *  是否展示表情view  YES:展示  NO:隐藏
 *
 *  @param toShowEmojiView 
 */
- (void)showEmojiView:(BOOL)toShowEmojiView;

@end

@interface PartnerKeyboardView : UIView <UITextViewDelegate>

@property (nonatomic, weak) id<PartnerKeyboardViewDelegate> delegate;


@property (nonatomic, strong) UITextView *inputText;        // 输入区域

@property (nonatomic, strong) UILabel *placeholderLabel;    // 占位字符

@property (nonatomic, strong) UIButton *faceButton;         // 表情按钮

@end
