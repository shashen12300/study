//
//  CInputView.m
//  study
//
//  Created by jzkj on 15/10/14.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "CInputView.h"

#import "TouchDownGestureRecognizer.h"
#import "JHAudioManager.h"
#import "RecordingView.h"
#import "MBProgressHUD.h"
@interface CInputView ()
{
    
    
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    
    NSString *_textViewString;  //标记textview输入内容
    CGFloat _keyboardHeight;    //键盘高度
    CGFloat _textViewHeight;    //发送前内容高度
    CGFloat _inputHeight;    //输入面板高度
    
    BOOL isKeybordShow;
    
    CEmojiView *emojiView;
    MoreView *moreView;
}
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) RecordingView *recordingView;
@end

@implementation CInputView


#define voiceButtonH (100.0f)
#define maxTextHeight 95

#define inputHeight 44
#define buttonHeight 30

- (void)layoutViews
{
    self.backgroundColor = RGBCOLOR(240, 240, 240);
    
    //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 语音输入切换按钮切换
    // 语音输入切换按钮切换
    self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeButton setFrame:CGRectMake(10, 8, buttonHeight, buttonHeight)];
    self.changeButton.backgroundColor = [UIColor clearColor];
    [self.changeButton setBackgroundImage:[UIImage imageNamed:@"Immediate_recordBg"] forState:UIControlStateNormal];
    [self.changeButton addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.changeButton.tag = InputButtonText;
    [self addSubview:self.changeButton];
    
    
    
    // 消息文本
    CGFloat textLineX = self.changeButton.right + 10;
    CGFloat textLineW = Main_Width - 150;
    self.inputText = [[UITextView alloc] initWithFrame:CGRectMake(textLineX, 7, textLineW, buttonHeight)];
    self.inputText.scrollEnabled = YES;
    self.inputText.scrollsToTop = NO;
    self.inputText.userInteractionEnabled = YES;
    self.inputText.font = [UIFont systemFontOfSize:16.0f];
    self.inputText.returnKeyType =UIReturnKeySend;
    self.inputText.delegate = self;
    self.inputText.backgroundColor = [UIColor whiteColor];
    self.inputText.layer.cornerRadius = 5;
    self.inputText.layer.masksToBounds = YES;
    [self addSubview:self.inputText];
    // 下划线
//    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, Main_Width, 1)];
//    self.lineView.backgroundColor = RGBCOLOR(229, 229, 229);
//    [self addSubview:self.lineView];
    
    
    
    
    // 更多按钮
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setFrame:CGRectMake(Main_Width - buttonHeight - 15, 8, buttonHeight, buttonHeight)];
    self.changeButton.backgroundColor = [UIColor clearColor];
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"Immediate_addmore"] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton.tag = MoreButtonText;
    [self addSubview:self.moreButton];
    
    // 表情按钮
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceButton setFrame:CGRectMake(CGRectGetMinX(self.moreButton.frame) - buttonHeight-15, 8, buttonHeight, buttonHeight)];
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_face"] forState:UIControlStateNormal];
    self.faceButton.backgroundColor = [UIColor clearColor];
    [self.faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.faceButton.tag = FaceButtonText;
    [self addSubview:self.faceButton];
    
    // 录音按钮
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = self.inputText.frame;
    self.recordButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.recordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [self.recordButton setBackgroundImage:[UIImage imageNamed:@"Immediate_record"] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:[UIImage imageNamed:@"Immediate_send"] forState:UIControlStateHighlighted];
    [self.recordButton setOpaque:YES];
    [self.recordButton setHidden:YES];
    
    self.recordButton.userInteractionEnabled = YES;
    [self addSubview:self.recordButton];
    
    //        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    //        longPressGes.delegate = self;
    //        longPressGes.minimumPressDuration = 0;
    //        [self.recordButton addGestureRecognizer:longPressGes];
    
    _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
    __weak CInputView* weakSelf = self;
    _touchDownGestureRecognizer.touchDown = ^{
        [weakSelf p_record:nil];
    };
    
    _touchDownGestureRecognizer.moveInside = ^{
        [weakSelf p_endCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.moveOutside = ^{
        [weakSelf p_willCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.touchEnd = ^(BOOL inside){
        if (inside)
        {
            [weakSelf p_sendRecord:nil];
        }
        else
        {
            [weakSelf p_cancelRecord:nil];
        }
    };
    [self.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
    
    
    
    moreView = [[MoreView alloc] initWithFrame:CGRectMake(0, 44, Main_Width, 150)];
    moreView.hidden = YES;
    moreView.delegate = self;
    moreView.backgroundColor = RGBCOLOR(240, 240, 240);
    [self addSubview:moreView];
    
    emojiView = [[CEmojiView alloc] initWithFrame:CGRectMake(0, 44, Main_Width, 150)];
    emojiView.delegate = self;
    emojiView.hidden = YES;
    moreView.backgroundColor = RGBCOLOR(240, 240, 240);
    [self addSubview:emojiView];
    
    isKeybordShow = NO;
}
///点
- (void)p_record:(UIButton*)button {
    self.recordButton.highlighted=YES;
    [[JHAudioManager sharedInstance]recordStart:[UserInfoList loginUserId] target:self];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRecordAnimation)]) {
        [self.delegate showRecordAnimation];
    }
}
- (void)p_endCancelRecord:(UIButton*)button {
    
    
}
- (void)p_willCancelRecord:(UIButton*)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stopRecordAnimation)])
    {
        [self.delegate stopRecordAnimation];
    }
//    [SVProgressHUD showErrorWithStatus:@"手值松开,取消发送"];
    
    
}
//点
- (void)p_sendRecord:(UIButton*)button {
    NSMutableDictionary *recordDic = [[JHAudioManager sharedInstance]recordStop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(postSoundWithUrlString:andRecordTime:withRecordData:)]) {
        [self.delegate postSoundWithUrlString:recordDic[@"localPath"] andRecordTime:recordDic[@"recordTime"] withRecordData:recordDic[@"recordData"]];
        
    }
    self.recordButton.highlighted = NO;
}
- (void)p_cancelRecord:(UIButton*)button {
    [self.recordButton setHighlighted:NO];
    [[JHAudioManager sharedInstance] recordCancel];
}


- (void)initialPosition
{
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_face"] forState:UIControlStateNormal];
    self.faceButton.tag = FaceButtonText;
    
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"Immediate_addmore"] forState:UIControlStateNormal];
    self.moreButton.tag = MoreButtonText;
    
    [self.changeButton setBackgroundImage:[UIImage imageNamed:@"Immediate_recordBg"] forState:UIControlStateNormal];
    self.changeButton.tag = InputButtonText;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeButtonClick:(UIButton *)sender
{
    if (self.changeButton.tag == InputButtonText) {
        [self.changeButton setBackgroundImage:[UIImage imageNamed:@"Immediate_Changerecord"] forState:UIControlStateNormal];
        self.lineView.hidden = YES;
        self.inputText.hidden = YES;
        self.recordButton.hidden = NO;
        self.changeButton.tag = InputButtonRecord;
        if (isKeybordShow) {
            [self.inputText resignFirstResponder];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightChanged:duration:)]) {
            [self.delegate inputViewHeightChanged:0 duration:0.25f];
        }
        
    } else {
        [self.changeButton setBackgroundImage:[UIImage imageNamed:@"Immediate_recordBg"] forState:UIControlStateNormal];
        self.lineView.hidden = NO;
        self.inputText.hidden = NO;
        self.recordButton.hidden = YES;
        self.changeButton.tag = InputButtonText;
        
        [self.inputText becomeFirstResponder];
    }
    
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_face"] forState:UIControlStateNormal];
    self.faceButton.tag = FaceButtonText;
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"Immediate_addmore"] forState:UIControlStateNormal];
    self.moreButton.tag = MoreButtonText;
    
    emojiView.hidden = YES;
    moreView.hidden = YES;
}

- (void)faceButtonClick:(UIButton *)sender
{
    emojiView.frame = CGRectMake(0, self.frame.size.height - 150, Main_Width, 150);
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
    
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"Immediate_addmore"] forState:UIControlStateNormal];
    self.moreButton.tag = FaceButtonText;
    [self.changeButton setBackgroundImage:[UIImage imageNamed:@"Immediate_recordBg"] forState:UIControlStateNormal];
    self.changeButton.tag = InputButtonText;
    self.inputText.hidden = NO;
    self.recordButton.hidden = YES;
    
    emojiView.hidden = NO;
    moreView.hidden = YES;
}

- (void)moreButtonClick:(UIButton *)sender
{
    moreView.frame = CGRectMake(0, self.frame.size.height - 150, Main_Width, 150);
    if (self.moreButton.tag == MoreButtonText) {
        [self.moreButton setBackgroundImage:[UIImage imageNamed:@"Immediate_Changerecord"] forState:UIControlStateNormal];
        self.moreButton.tag = MoreButtonMore;
        
        [self.inputText resignFirstResponder];
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightChanged:duration:)]) {
            [self.delegate inputViewHeightChanged:150 duration:0.25f];
        }
    } else {
        [self.moreButton setBackgroundImage:[UIImage imageNamed:@"Immediate_addmore"] forState:UIControlStateNormal];
        self.moreButton.tag = MoreButtonText;
        
        [self.inputText becomeFirstResponder];
    }
    
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_face"] forState:UIControlStateNormal];
    self.faceButton.tag = FaceButtonText;
    [self.changeButton setBackgroundImage:[UIImage imageNamed:@"Immediate_recordBg"] forState:UIControlStateNormal];
    self.changeButton.tag = InputButtonText;
    self.inputText.hidden = NO;
    self.recordButton.hidden = YES;
    
    emojiView.hidden = YES;
    moreView.hidden = NO;
}

- (void)longPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //长按
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        
//        
//        [[JHAudioManager sharedInstance]recordStart:[UserInfoList loginUserId] target:self];
//        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(showRecordAnimation)]) {
//            [self.delegate showRecordAnimation];
//        }
//        self.recordButton.selected = YES;
//        //        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        //        [[RecordManager sharedInstance] recordStart:@"10107" withSandboxPathWithString:[documentPaths objectAtIndex:0]];
//    }
//    //  滑动
//    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        
//        [[JHAudioManager sharedInstance]recordCancel];
//    }
//    //点击
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        //    NSMutableDictionary *recordDic = [[JHAudioManager sharedInstance] recordStop];
//        //        NSLog(@"recordDic === %@",recordDic);
//        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(sendRecordDict:)]) {
//            //            [self.delegate sendRecordDict:recordDic];
//        }
//        self.recordButton.selected = NO;
//    }
}

#pragma mark - 系统键盘通知事件
- (void)keyBoardHiden:(NSNotification*)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightChanged:duration:)]) {
        [self.delegate inputViewHeightChanged:0 duration:0.25f];
    }
}

- (void)keyBoardShow:(NSNotification*)notification
{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightChanged:duration:)]) {
        [self.delegate inputViewHeightChanged:CGRectGetHeight(rect) duration:0.25f];
    }
    
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"Immediate_face"] forState:UIControlStateNormal];
    self.faceButton.tag = FaceButtonText;
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"Immediate_addmore"] forState:UIControlStateNormal];
    self.moreButton.tag = FaceButtonText;
    
    isKeybordShow = YES;
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

#pragma mark - MoreViewDelegate
- (void)receiveMoreViewAction:(MoreViewActionType)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moveViewActionWithType:)]) {
        [self.delegate moveViewActionWithType:type];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // 改变高度   上移
    emojiView.hidden = YES;
    moreView.hidden = YES;
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

//内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text length]>2) {
        textView.selectedRange = NSMakeRange(range.location+text.length, 0);
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        
        if ([self isEmpty:textView.text]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageToChat:)]) {
                [self.delegate sendMessageToChat:self.inputText.text];
                textView.text = @"";
            }
        }
        return NO;
    }
    
    char c=[text UTF8String][0];
    if (c=='\000') {
        return YES;
    }
    
    if([[self.inputText text] length]>4000) {
        return NO;
    }
    
    if([[self.inputText text] length]==4000) {
        if(![text isEqualToString:@"\b"])
            return NO;
    }
    return YES;
}

//焦点发生改变
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

//内容发生改变编辑
- (void)textViewDidChange:(UITextView *)textView{
    //判断尺寸
    if (textView.contentSize.height > textView.frame.size.height && textView.frame.size.height < 100) {
        if ([self.delegate respondsToSelector:@selector(changeToolViewHeige:)]) {
            CGFloat heiget = textView.contentSize.height>100? 100 : textView.contentSize.height;
            [self.delegate changeToolViewHeige:(heiget - textView.frame.size.height)];
        }
    }
    if (textView.contentSize.height < textView.frame.size.height && textView.frame.size.height > 30) {
        if ([self.delegate respondsToSelector:@selector(changeToolViewHeige:)]) {
            [self.delegate changeToolViewHeige:(textView.contentSize.height - textView.frame.size.height)];
        }
    }
    NSRange textrange = NSMakeRange(textView.selectedRange.location, 1);
    [textView scrollRangeToVisible:textrange];
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return YES;
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
