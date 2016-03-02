//
//  PublishHeaderView.m
//  text
//
//  Created by yang on 16/1/21.
//  Copyright © 2016年 jzkj. All rights reserved.
//

#import "PublishHeaderView.h"

@interface PublishHeaderView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation PublishHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self setupSubviews];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TYPE_INTO_TEXTVIEW" object:nil];
}

#pragma mark - inner methods
- (void)setupSubviews {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(widget_width(32), widget_width(20), CGRectGetWidth(self.frame) - widget_width(32)*2, widget_width(120))];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:12];
    self.textView.textColor = UIColorFromRGB(0x656565);
    [self addSubview:self.textView];
    self.textView.showsVerticalScrollIndicator = NO;
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(widget_width(40), widget_width(30), CGRectGetWidth(self.frame) - widget_width(40)*2, widget_width(30))];
    self.placeholderLabel.text = @"我想说...";
    self.placeholderLabel.textColor = UIColorFromRGB(0xc3c3c3);
    self.placeholderLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.placeholderLabel];
    
    self.pictureView = [[UIView alloc] initWithFrame:CGRectMake(widget_width(32), CGRectGetMaxY(self.textView.frame) + widget_width(20), widget_width(540), CGRectGetHeight(self.frame) - widget_width(190))];
    [self addSubview:self.pictureView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"TYPE_INTO_TEXTVIEW" object:nil];
}

- (void)handleNotification:(NSNotification *)aNotification
{
    NSString *faceName = [[aNotification userInfo] objectForKey:@"faceName"];
    
    self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,faceName];
    
    if (self.textView.text.length == 0)
    {
        self.placeholderLabel.hidden = NO;
    }else
    {
        self.placeholderLabel.hidden = YES;
    }
    // textview光标位置
    NSRange range = NSMakeRange([self.textView.text length] - 1, 1);
    [self.textView scrollRangeToVisible:range];
}

#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(text.length == 0 && range.location == 0) {
        self.placeholderLabel.hidden = NO;
    }else {
        self.placeholderLabel.hidden = YES;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else {
        self.placeholderLabel.hidden = YES;
    }
}

@end
