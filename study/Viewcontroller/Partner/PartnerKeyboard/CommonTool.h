//
//  CommonTool.h
//  Keyboard
//
//  Created by yang on 15/10/20.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

+ (CGSize)sizeOfText:(NSString *)str withFont:(UIFont *)font consstrainSize:(CGSize)size;
+ (UIViewController *)viewControllerOfView:(UIView *)view;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGSize)screenSize;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message byViewController:(UIViewController *)viewController;
+ (BOOL)isBlankString:(NSString *)str;

@end
