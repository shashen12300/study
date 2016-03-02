//
//  CInputView.h
//  study
//
//  Created by jzkj on 15/10/14.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEmojiView.h"
#import "MoreView.h"
typedef NS_ENUM(NSInteger, InputButtonType)
{
    InputButtonText     = 0,
    InputButtonRecord   = 1
};

typedef NS_ENUM(NSInteger, FaceButtonType)
{
    FaceButtonFace      = 0,
    FaceButtonText      = 1
};

typedef NS_ENUM(NSInteger, MoreButtonType)
{
    MoreButtonMore      = 0,
    MoreButtonText      = 1
};
@protocol InputViewDelegate <NSObject>

//  录音动画
- (void)showRecordAnimation;
- (void)stopRecordAnimation;
//  发送文字消息
- (void)sendMessageToChat:(NSString *)text;
//  改变位置
- (void)inputViewHeightChanged:(CGFloat)height duration:(CGFloat)duration;
/**
 *  改变toolview的高度
 */
- (void)changeToolViewHeige:(CGFloat)height;
//  发送语音
//- (void)sendRecordDict:(NSDictionary *)dict;

- (void)postSoundWithUrlString:(NSString *)localpath andRecordTime:(NSString *)duration withRecordData:(NSData *)recData;

//  更多代理
- (void)moveViewActionWithType:(MoreViewActionType)type;

@end
@class RecordingView;
@interface CInputView : UIView <UITextViewDelegate, UIGestureRecognizerDelegate, EmojiViewDelegate, MoreViewDelegate>
{
    RecordingView* _recordingView;
}

@property (strong, nonatomic) UIButton *changeButton;//
@property (strong, nonatomic) UITextView *inputText;//输入
@property (strong, nonatomic) UIButton *recordButton;//按住说话
@property (strong, nonatomic) UIButton *moreButton;//更多
@property (strong, nonatomic) UIButton *faceButton;//表情BTN
@property (weak, nonatomic) id <InputViewDelegate> delegate;

- (void)layoutViews;
// 初始化控件位置
- (void)initialPosition;
@end
