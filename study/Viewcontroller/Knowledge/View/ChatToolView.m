//
//  ChatToolView.m
//  soul_ios
//
//  Created by hanjp on 15/6/29.
//  Copyright (c) 2015年 soul. All rights reserved.
//

#import "ChatToolView.h"

@implementation ChatToolView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, Main_Screen_Width , 0);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutViews];
        self.backgroundColor = RGBCOLOR(250, 251, 251);
        state = YES;
    }
    return self;
}

- (void)layoutViews{
    //表情
    self.faceIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _faceIconBtn.frame = CGRectMake(8, 5, 35, 35);
    [_faceIconBtn setBackgroundImage:[UIImage imageNamed:@"inputChange"] forState:UIControlStateNormal];
    _faceIconBtn.tag = 1;
    [self.faceIconBtn addTarget:self
                         action:@selector(messageStyleButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_faceIconBtn];
    
    //分享
    self.shareChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareChatBtn.frame = CGRectMake(52, 5, 34, 34);
    [_shareChatBtn setBackgroundImage:[UIImage imageNamed:@"shareadd"] forState:UIControlStateNormal];
    _shareChatBtn.tag = 2;
    [self.shareChatBtn addTarget:self
                          action:@selector(messageStyleButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareChatBtn];
    
    self.placehodelLabel = [[UILabel alloc] initWithFrame:CGRectMake(52 , 4.5 ,Main_Screen_Width - 140 ,36)];
    self.placehodelLabel.font = [UIFont systemFontOfSize:17];
    self.placehodelLabel.textColor = UIColorFromRGB(0x9f9f9f);
    [self addSubview:_placehodelLabel];
    
    self.chatContent = [[UITextView alloc] initWithFrame:CGRectMake(93 , 4.5 ,Main_Screen_Width - 140 ,36)];
    _chatContent.returnKeyType = UIReturnKeySend;
    _chatContent.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _chatContent.layer.borderWidth = 0.65f;
    _chatContent.layer.cornerRadius = 6.0f;
    _chatContent.delegate = self;//设置代理
    _chatContent.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _chatContent.font = [UIFont systemFontOfSize:17];
    _chatContent.tintColor = [UIColor blackColor];
    _chatContent.backgroundColor = [UIColor clearColor];
    [self addSubview:_chatContent];
    
    //可能是语音切换按钮
    self.voiceIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceIcon.frame = CGRectMake(Main_Screen_Width-40 , 5, 35, 35);
    [_voiceIcon setBackgroundImage:[UIImage imageNamed:@"voiceinput"] forState:UIControlStateNormal];
    _voiceIcon.tag = 0;
    _voiceIcon.selected = YES;//第一次点击显示语音
    [self.voiceIcon addTarget:self
                               action:@selector(messageStyleButtonClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voiceIcon];
    
    // 如果是可以发送语言的，那就需要一个按钮录音的按钮，事件可以在外部添加
    self.holdDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _holdDownButton.frame = CGRectMake(96 , 4.5 ,Main_Screen_Width - 140 ,36);
    _holdDownButton.layer.cornerRadius = 5;
    _holdDownButton.backgroundColor = UIColorFromRGB(0x66ccc1);
    [self.holdDownButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.holdDownButton setTitle:@"松开结束" forState:UIControlStateHighlighted];
    [self.holdDownButton addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.holdDownButton addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//    [self.holdDownButton addTarget:self action:@selector(btnTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
//    [self.holdDownButton addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchCancel];
    _holdDownButton.hidden = YES;
    [self addSubview:self.holdDownButton];
    //测试 添加手势
    UIPanGestureRecognizer *panges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureQuxiao:)];
    [self.holdDownButton addGestureRecognizer:panges];
}

- (void)panGestureQuxiao:(UIPanGestureRecognizer *)panges{
    [self.holdDownButton setTitle:@"松开结束" forState:UIControlStateNormal];
    //获取位置
    CGPoint position=[panges locationInView:_holdDownButton];
    if (panges.state == UIGestureRecognizerStateEnded) {
        if (position.x < 0 || position.y <0 || position.x > (Main_Screen_Width - 140) || position.y > 36) {
            [self holdDownButtonTouchUpOutside];
        }else{
            [self holdDownButtonTouchUpInside];
        }
        [self.holdDownButton setTitle:@"按住说话" forState:UIControlStateNormal];
    }
}
#pragma mark - Action

- (void)messageStyleButtonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            self.faceIconBtn.selected = NO;
            self.shareChatBtn.selected = NO;
            sender.selected = !sender.selected;
            
            if (sender.selected){
                NSLog(@"声音被点击的");
                [self.chatContent becomeFirstResponder];
                
            }else{
                NSLog(@"声音被点击结束");
                [self.chatContent resignFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.hidden = sender.selected;
                self.chatContent.hidden = !sender.selected;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didChangeSendVoiceAction:)]) {
                [self.delegate didChangeSendVoiceAction:sender.selected];
            }
        }
            break;
        case 1:
        {
            self.shareChatBtn.selected = NO;
            self.voiceIcon.selected = YES;
            sender.selected = !sender.selected;
            if (sender.selected) {
                NSLog(@"表情被点击");
                [self.chatContent resignFirstResponder];

            }else{
                NSLog(@"表情没被点击");
                [self.chatContent becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.hidden = YES;
                self.chatContent.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didSendFaceAction:)]) {
                [self.delegate didSendFaceAction:sender.selected];
            }
        }
            break;
        case 2:
        {
            self.voiceIcon.selected = YES;
            self.faceIconBtn.selected = NO;
            
            sender.selected = !sender.selected;
            if (sender.selected) {
                NSLog(@"分享被点击");
                [self.chatContent resignFirstResponder];
            }else{
                NSLog(@"分享没被点击");
                [self.chatContent becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.hidden = YES;
                self.chatContent.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didSelectedMultipleMediaAction:)]) {
                [self.delegate didSelectedMultipleMediaAction:sender.selected];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -语音功能
- (void)holdDownButtonTouchDown {
    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)]) {
        [self.delegate didStartRecordingVoiceAction];
    }
}

- (void)holdDownButtonTouchUpOutside {
    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
        [self.delegate didCancelRecordingVoiceAction];
    }
}

- (void)holdDownButtonTouchUpInside {
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction)]) {
        [self.delegate didFinishRecoingVoiceAction];
    }
}


#pragma mark - textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //判断尺寸
//    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
////    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
//    if (comcatstr.length >= 5)
//    {
//        //加入动态计算高度
//        CGSize size = [self getStringRectInTextView:comcatstr InTextView:textView];
//        if (size.height > textView.frame.size.height && textView.frame.size.height < 100) {
//            CGFloat heiget = size.height>100? 100 : size.height;
//            if ([self.delegate respondsToSelector:@selector(changeToolViewHeige:)]) {
//                [self.delegate changeToolViewHeige:(heiget - textView.frame.size.height)];
//            }
//        }
//        if (size.height < textView.frame.size.height && textView.frame.size.height > 30) {
//            if ([self.delegate respondsToSelector:@selector(changeToolViewHeige:)]) {
//                [self.delegate changeToolViewHeige:(size.height - textView.frame.size.height)];
//            }
//        }
////        return YES;
//    }
    //deleteBtnClick
    if (text.length == 0) {
        if ([self.delegate respondsToSelector:@selector(deleteBtnClick)]) {
            [self.delegate deleteBtnClick];
            return YES;
        }
    }
    if (textView.text.length ==0 && state) {
        if ([self.delegate respondsToSelector:@selector(didSendEmptyTextAction:)]) {
            [self.delegate didSendEmptyTextAction:self.chatContent];
            state = NO;
        }
    }
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
            [self.delegate didSendTextAction:self.chatContent];
            state = YES;
            return NO;
        }
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:textView];
    }
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
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:textView];
    }
}
- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;
{
    //实际textView显示时我们设定的
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);//ceilf(calculatedSize.height)
    return adjustedSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
