//
//  ReviewImageView.h
//  study
//
//  Created by jzkj on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMsgDTO.h"
@interface ReviewImageView : UIView
@property (nonatomic , copy) void(^recordVideo)(NSDictionary *);//录音按钮回调
- (instancetype)initWithFrame:(CGRect)frame message:(ChatMsgDTO *)msg;
@end
