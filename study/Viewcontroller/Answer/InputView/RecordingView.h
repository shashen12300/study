//
//  RecordingView.h
//  study
//
//  Created by jzkj on 15/10/16.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDRecordingState)
{
    DDShowVolumnState,
    DDShowCancelSendState,
    DDShowRecordTimeTooShort
};
@protocol RecordViewDelegate <NSObject>

@end
@interface RecordingView : UIView
@property (nonatomic,assign)DDRecordingState recordingState;
- (instancetype)initWithState:(DDRecordingState)state;
- (void)setVolume:(float)volume;
@property (assign, nonatomic) id <RecordViewDelegate> delegate;


@end
