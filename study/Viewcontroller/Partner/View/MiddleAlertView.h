//
//  MiddleAlertView.h
//  study
//
//  Created by yang on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MiddleAlertViewDelegate <NSObject>

//- (void)

@end

@interface MiddleAlertView : UIView

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;

@end
