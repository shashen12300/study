//
//  ChatToolView.h
//  soul_ios
//
//  Created by hanjp on 15/6/29.
//  Copyright (c) 2015年 soul. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    MessageInputViewStyleDefault, // ios7 样式
    MessageInputViewStyleQuasiphysical
} MessageInputViewStyle;

@protocol ChatToolViewDelegate <NSObject>

@optional

/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(UITextView *)messageInputTextView;

/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(UITextView *)messageInputTextView;

/**
 *  输入框输入时候
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidChange:(UITextView *)messageInputTextView;



/**
 *  点击语音按钮Action
 */
- (void)didChangeSendVoiceAction:(BOOL)changed;

/**
 *  发送文本消息，包括系统的表情
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)didSendTextAction:(UITextView *)messageInputTextView;
//发送提示消息
- (void)didSendEmptyTextAction:(UITextView*)messageInputTextView;

/**
 *  点击+号按钮Action
 */
- (void)didSelectedMultipleMediaAction:(BOOL)changed;

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction;

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction;

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction;

/**
 *  发送第三方表情
 */
- (void)didSendFaceAction:(BOOL)sendFace;

/**
 *  改变toolview的高度
 */
- (void)changeToolViewHeige:(CGFloat)heige;

/**
 *  点击删除的代理方法
 */
- (void)deleteBtnClick;

@end

@interface ChatToolView : UIView<UITextViewDelegate>{
    BOOL state;
}
@property (nonatomic,strong)UILabel *placehodelLabel;//占位符
@property (nonatomic,strong)UITextView *chatContent;//内容
@property (nonatomic,strong)UIButton *faceIconBtn;//表情
@property (nonatomic,strong)UIButton *shareChatBtn;//分享
@property (nonatomic,strong)UIButton *voiceIcon;//未知
@property (nonatomic,weak) id<ChatToolViewDelegate> delegate;
/**
 *  语音录制按钮
 */
@property (nonatomic, strong) UIButton *holdDownButton;

#pragma mark methods
/**
 *  动态改变高度
 *
 *  @param changeInHeight 目标变化的高度
 */
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;
@end






















