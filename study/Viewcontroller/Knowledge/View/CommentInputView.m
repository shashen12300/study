//
//  CommentInputView.m
//  study
//
//  Created by mijibao on 16/2/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CommentInputView.h"
#import "CEmojiView.h"
@interface CommentInputView()<UITextViewDelegate,EmojiViewDelegate>

@property (nonatomic, strong) CEmojiView *emojiView;

@end

@implementation CommentInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutViews {
    self.backgroundColor = RGBVCOLOR(0xDCDCDC);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 表情按钮
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceButton setFrame:CGRectMake( 10, 5, 30, 30)];
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_face"] forState:UIControlStateNormal];
    self.faceButton.backgroundColor = [UIColor clearColor];
    [self.faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.faceButton.tag = FaceButtonText;
    [self addSubview:self.faceButton];
    // 消息文本
    CGFloat textLineX = self.faceButton.right + 10;
    CGFloat textLineW = Main_Width - 110;
    self.inputText = [[UITextView alloc] initWithFrame:CGRectMake(textLineX, 5, textLineW, 34)];
    self.inputText.scrollEnabled = YES;
    self.inputText.scrollsToTop = NO;
    self.inputText.userInteractionEnabled = YES;
    self.inputText.font = [UIFont systemFontOfSize:16.0f];
    self.inputText.delegate = self;
    self.inputText.backgroundColor = [UIColor whiteColor];
    self.inputText.layer.cornerRadius = 5;
    self.inputText.layer.masksToBounds = YES;
    [self addSubview:self.inputText];
    //发送
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(Main_Width - 65, 5, 60, 34);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sendButton setTitleColor:RGBVCOLOR(0xFF7949) forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];
    //表情视图
    _emojiView = [[CEmojiView alloc] initWithFrame:CGRectMake(0, 44, Main_Width, 150)];
    _emojiView.delegate = self;
    _emojiView.hidden = YES;
    [self addSubview:_emojiView];
}

- (void)sendCommentBtnClick {
    if ([self isEmpty:_inputText.text]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageToChat:)]) {
            [self.delegate sendMessageToChat:self.inputText.text];
            _inputText.text = @"";
            [self.delegate inputViewHeightChanged:0 duration:0.25];
        }
        [_inputText resignFirstResponder];
    }
}

- (void)faceButtonClick:(UIButton *)sender
{
    if (self.faceButton.tag == FaceButtonText) {
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_Changerecord"] forState:UIControlStateNormal];
        self.faceButton.tag = FaceButtonFace;
        
        [self.inputText resignFirstResponder];
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightChanged:duration:)]) {
            [self.delegate inputViewHeightChanged:150 duration:0.25];
        }
    } else {
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_face"] forState:UIControlStateNormal];
        self.faceButton.tag = FaceButtonText;
        
        [self.inputText becomeFirstResponder];
    }
    _emojiView.hidden = NO;
}


- (void)keyBoardShow:(NSNotification*)notification
{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightChanged:duration:)]) {
        [self.delegate inputViewHeightChanged:CGRectGetHeight(rect) duration:0.25f];
    }
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_face"] forState:UIControlStateNormal];
    self.faceButton.tag = FaceButtonText;

}

#pragma mark - EmojiViewDelegate
- (void)appendEmojiString:(NSString *)string
{
    NSString *str = self.inputText.text;
    self.inputText.text = [NSString stringWithFormat:@"%@%@",str, string];
}

- (void)deleteEmojiString
{
    NSString *text = self.inputText.text;
    if([text length] <= 0)
        return;
    int n = -1;
    if([text characterAtIndex:[text length]-1] == ']') {
        for(int i = (int)(text.length-1); i >= 0; i --) {
            if( [text characterAtIndex:i] == '[' ) {
                n = i;
                break;
            }
        }
    }
    if(n >= 0) {
        self.inputText.text = [text substringWithRange:NSMakeRange(0,n)];
    } else {
        self.inputText.text = [text substringToIndex:[text length] - 1];
    }
}

//为空判断
- (BOOL)isEmpty:(NSString *)str
{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strUrl.length > 0) {
        return YES;
    } else {
        return NO;
    }
}


@end
