//
//  MiddleAlertViewController.h
//  study
//  居中提示框
//  Created by yang on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^TapBlock)();

@interface MiddleAlertViewController : BaseViewController

@property (nonatomic, copy) TapBlock tapBlock;
@property (nonatomic, strong) UIImageView *backImageView;     // 背景图

- (void)reloadTitle:(NSString *)title leftMessage:(NSString *)leftMessage rightMessage:(NSString *)rightMessage;

@end
