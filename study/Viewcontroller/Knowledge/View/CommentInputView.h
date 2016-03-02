//
//  CommentInputView.h
//  study
//
//  Created by mijibao on 16/2/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FaceButtonType)
{
    FaceButtonFace      = 0,
    FaceButtonText      = 1
};

@protocol CommentInputViewDelegate <NSObject>

//  发送文字消息
- (void)sendMessageToChat:(NSString *)text;
//  改变高度
- (void)inputViewHeightChanged:(CGFloat)height duration:(CGFloat)duration;

@end

@interface CommentInputView : UIView

@property (strong, nonatomic) UITextView *inputText;//输入
@property (strong, nonatomic) UIButton *faceButton;//表情BTN
@property (nonatomic, strong) UIButton *sendButton; //发送

@property (weak, nonatomic) id <CommentInputViewDelegate> delegate;
- (void)layoutViews;
@end
