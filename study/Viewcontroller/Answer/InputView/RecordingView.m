//
//  RecordingView.m
//  study
//
//  Created by jzkj on 15/10/16.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "RecordingView.h"
#import "JHAudioManager.h"
#define DDVIEW_RECORDING_WIDTH                          196
#define DDVIEW_RECORDING_HEIGHT                         196

#define DDVOLUMN_VIEW_TAG                               10
@interface RecordingView(PrivateAPI)

- (void)setupCancelSendView;
- (void)setupShowVolumnState;
- (void)setupShowRecordingTooShort;

- (void)showCancelSendState;
- (void)showVolumnState;
- (void)showRecordingTooShort;

@property (nonatomic ,strong)JHAudioManager *audio;
- (float)heightForVolumn:(float)vomlun;
@end

@implementation RecordingView

- (instancetype)initWithState:(DDRecordingState)state
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, DDVIEW_RECORDING_WIDTH, DDVIEW_RECORDING_HEIGHT);
        [self.layer setCornerRadius:10];
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        UIView* backroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DDVIEW_RECORDING_WIDTH, DDVIEW_RECORDING_HEIGHT)];
        [backroundView setBackgroundColor:[UIColor blackColor]];
        [backroundView setAlpha:0.7];
        backroundView.tag = 100;
        [self addSubview:backroundView];
        _recordingState = DDShowVolumnState;
        [self setupShowVolumnState];
        
        
                
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setRecordingState:(DDRecordingState)recordingState
{
    switch (recordingState)
    {
        case DDShowCancelSendState:
            [self showCancelSendState];
            break;
        case DDShowVolumnState:
            [self showVolumnState];
            break;
        case DDShowRecordTimeTooShort:
            [self showRecordingTooShort];
            break;
    }
}

- (void)setVolume:(float)volume
{
    if (_recordingState != DDShowVolumnState)
    {
        return;
    }
    
    UIImageView* volumnImageView = [self subviewWithTag:DDVOLUMN_VIEW_TAG];
    float height = [self heightForVolumn:volume];
    CGRect frame = volumnImageView.frame;
    frame.size.height = height;
    frame.origin.y = height - frame.size.height;
    volumnImageView.frame = frame;
}
- (id)subviewWithTag:(NSInteger)tag{
    
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    return nil;
}

#pragma mark privateAPI
- (void)setupCancelSendView
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(UIView*)obj tag] != 100)
        {
            [(UIView*)obj removeFromSuperview];
        }
    }];
    UIImage* image = [UIImage imageNamed:@"Immediate_cancel_send_record"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(74, 53, 45, 59)];
    [self addSubview:imageView];
    
    UIView* backgrounView = [[UIView alloc] initWithFrame:CGRectMake(28, 152, 140, 23)];
    //    [backgrounView setBackgroundColor:RGB(176, 34, 33)];
    backgrounView.backgroundColor=[UIColor colorWithRed:176/255.0 green:34/255.0 blue:33/255.0 alpha:1.0];
    [backgrounView setAlpha:0.8];
    [backgrounView.layer setCornerRadius:2];
    [backgrounView setClipsToBounds:YES];
    [self addSubview:backgrounView];
    
    UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(28, 152, 140, 23)];
    [prompt setBackgroundColor:[UIColor clearColor]];
    [prompt setTextColor:[UIColor whiteColor]];
    [prompt setText:@"松开手指，取消发送"];
    [prompt setFont:[UIFont systemFontOfSize:15]];
    [prompt setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:prompt];
}

- (void)setupShowVolumnState
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(UIView*)obj tag] != 100)
        {
            [(UIView*)obj removeFromSuperview];
        }
    }];
//    UIImage* image = [UIImage imageNamed:@"dd_recording"];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
//    [imageView setFrame:CGRectMake(60, 42, 53, 83)];
//    [self addSubview:imageView];
    
    UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 152, DDVIEW_RECORDING_WIDTH, 23)];
    [prompt setBackgroundColor:[UIColor clearColor]];
    [prompt setTextColor:[UIColor whiteColor]];
    [prompt.layer setCornerRadius:2];
    [prompt setTextAlignment:NSTextAlignmentCenter];
    [prompt setFont:[UIFont systemFontOfSize:15]];
    [prompt setText:@"手指上滑,取消发送"];
    
    [self addSubview:prompt];
    

    UIImage* volumnImage = [UIImage imageNamed:@"Immediate_volumn_0"];
    UIImageView *volumnImageView = [[UIImageView alloc] initWithImage:volumnImage];
    [volumnImageView setFrame:CGRectMake(60, 83, 20, 43)];
    [volumnImageView setContentMode:UIViewContentModeBottom];
    [volumnImageView setClipsToBounds:YES];
    [volumnImageView setTag:DDVOLUMN_VIEW_TAG];
    [self addSubview:volumnImageView];
    
}

- (void)setupShowRecordingTooShort
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(UIView*)obj tag] != 100)
        {
            [(UIView*)obj removeFromSuperview];
        }
    }];
    UIImage* image = [UIImage imageNamed:@"Immediate_record_too_short"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(85, 42, 22, 83)];
    [self addSubview:imageView];
    
    UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 152, DDVIEW_RECORDING_WIDTH, 23)];
    [prompt setBackgroundColor:[UIColor clearColor]];
    [prompt setTextColor:[UIColor whiteColor]];
    [prompt.layer setCornerRadius:2];
    [prompt setTextAlignment:NSTextAlignmentCenter];
    [prompt setFont:[UIFont systemFontOfSize:15]];
    [prompt setText:@"说话时间太短"];
    
    [self addSubview:prompt];
}

- (void)showCancelSendState
{
    if (self.recordingState != DDShowCancelSendState)
    {
        [self setupCancelSendView];
    }
    _recordingState = DDShowCancelSendState;
}

- (void)showVolumnState
{
    if (self.recordingState != DDShowVolumnState)
    {
       [self setupShowVolumnState];
//        [self star];
    }
    _recordingState = DDShowVolumnState;
//    [self.volumnImageView stopAnimating];
    
    

}

- (void)showRecordingTooShort
{
    if (self.recordingState != DDShowRecordTimeTooShort)
    {
        [self setupShowRecordingTooShort];
    }
    _recordingState = DDShowRecordTimeTooShort;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.recordingState == DDShowRecordTimeTooShort)
        {
            [self setHidden:YES];
            
            NSLog(@"666666666666666666");
        }
    });
}
//- (void)star {
//    
//    
//    
//    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"Immediate_volumn_0"],
//                       [UIImage imageNamed:@"Immediate_volumn_1"],
//                       [UIImage imageNamed:@"Immediate_volumn_2"],
//                       [UIImage imageNamed:@"Immediate_volumn_3"],nil];
//    self.volumnImageView.animationImages = images;
//    self.volumnImageView.animationDuration = 1.5;
//    self.volumnImageView.animationRepeatCount = 0;
//    self.volumnImageView.hidden = NO;
//    [self.volumnImageView startAnimating];
//
//}
- (float)heightForVolumn:(float)vomlun
{
    //0-1.6 volumn
    float height = 43.0 / 1.6 * vomlun;
    return height;
}
@end
