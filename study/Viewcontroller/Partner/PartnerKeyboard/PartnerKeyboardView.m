//
//  PartnerKeyboardView.m
//  study
//
//  Created by yang on 15/9/30.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PartnerKeyboardView.h"


@implementation PartnerKeyboardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    self.inputText.frame = CGRectMake(widget_width(20), widget_width(15), widget_width(640), widget_width(70));
    self.faceButton.frame = CGRectMake(Main_Width - widget_width(75), widget_width(25), widget_width(50), widget_width(50));
    self.placeholderLabel.frame = CGRectMake(widget_width(30), widget_width(30), widget_width(600), widget_width(40));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TYPE_INTO_TEXTVIEW" object:nil];
}

#pragma mark - inner methods
- (void)setupSubviews {
    // 表情
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceButton setImage:[UIImage imageNamed:@"partner_face_image"] forState:UIControlStateNormal];
    [self.faceButton addTarget:self action:@selector(handleFaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.faceButton.layer setMasksToBounds:YES];
    [self.faceButton.layer setCornerRadius:widget_width(25)];
    [self addSubview:self.faceButton];
    
    // 输入区域
    self.inputText = [[UITextView alloc] init];
    self.inputText.textColor = UIColorFromRGB(0x666666);
    self.inputText.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.inputText];
    self.inputText.delegate = self;
    [self.inputText.layer setMasksToBounds:YES];
    [self.inputText.layer setCornerRadius:widget_width(10)];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.textColor = [UIColor grayColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"TYPE_INTO_TEXTVIEW" object:nil];
}

// 添加表情
- (void)handleNotification:(NSNotification *)aNotification
{
    NSString *faceName = [[aNotification userInfo] objectForKey:@"faceName"];
    
    _inputText.text = [NSString stringWithFormat:@"%@%@",_inputText.text,faceName];
    
    if (_inputText.text.length == 0)
    {
        self.placeholderLabel.hidden = NO;
    }else
    {
        self.placeholderLabel.hidden = YES;
    }
    // textview光标位置
    NSRange range = NSMakeRange([self.inputText.text length]-1,1);
    [self.inputText scrollRangeToVisible:range];
}


- (void)handleFaceButton:(UIButton *)sender {
    [_inputText resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(showEmojiView:)]) {
        [self.delegate showEmojiView:YES];
    }
}

- (void)handleSendButton:(UIButton *)sender {
    if (self.inputText.text.length == 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(clickSendButton:)]) {
        [self.delegate clickSendButton:_inputText.text];
    }
    
    if ([self.delegate respondsToSelector:@selector(showEmojiView:)]) {
        [self.delegate showEmojiView:NO];
    }
    [_inputText resignFirstResponder];
}


#pragma mark - UITextView代理
// 焦点发生改变
- (void)textViewDidChangeSelection:(UITextView *)textView {
    // NSLog(@"%f",textView.contentSize.height);
}

// 结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

// 开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self isEmpty:self.inputText.text])
    {
        if ([self.delegate respondsToSelector:@selector(showEmojiView:)]) {
            [self.delegate showEmojiView:NO];
        }
    }
    
}

// 内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {     // 检测到“完成”
        if ([self isEmpty:self.inputText.text]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickSendButton:)]) {
                [self.delegate clickSendButton:self.inputText.text];   // 发送文字
            }
            [self.inputText endEditing:YES];
            textView.text = @"";
        }
        
        [self.inputText resignFirstResponder];

        return NO;
    }
    char c=[text UTF8String][0];
    if (c=='\000') {
        return YES;
    }
    if([[self.inputText text] length]>4000){
        
        [self.inputText resignFirstResponder];

        return NO;
    }
    if([[self.inputText text] length]==4000) {
        if(![text isEqualToString:@"\b"]) {
            [self.inputText resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

// 内容发生改变编辑
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else {
        self.placeholderLabel.hidden = YES;
    }
}

// 为空判断
- (BOOL)isEmpty:(NSString *)str {
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strUrl.length > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
