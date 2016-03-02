//
//  MoreView.h
//  study
//
//  Created by jzkj on 15/10/14.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoreViewActionType)
{
    MoreViewActionPhoto = 0,
    MoreViewActionCamera = 1
};

@protocol  MoreViewDelegate <NSObject>

- (void)receiveMoreViewAction:(MoreViewActionType)type;

@end

@interface MoreView : UIView

@property (assign, nonatomic) id <MoreViewDelegate> delegate;

@end
