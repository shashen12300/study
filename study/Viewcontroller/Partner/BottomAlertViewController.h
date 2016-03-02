//
//  BottomAlertViewController.h
//  study
//  从底部弹出提示框
//  Created by yang on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^TapBottomBlock)(NSInteger);


@interface BottomAlertViewController : BaseViewController

@property (nonatomic, strong) UIImageView *backImageView;     // 背景图

@property (nonatomic, copy) TapBottomBlock tapBlock;

- (void)addActionWithString:(NSString *)string;

@end
