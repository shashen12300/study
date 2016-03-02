//
//  CommonTool.m
//  Keyboard
//
//  Created by yang on 15/10/20.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool

+ (CGSize)sizeOfText:(NSString *)str withFont:(UIFont *)font consstrainSize:(CGSize)size
{
    CGSize returnSize = CGSizeZero;
    if ([[UIDevice currentDevice].systemVersion floatValue]-7.0 > 0) {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        returnSize = [str boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    }else {
        returnSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    return returnSize;
}

+ (UIViewController *)viewControllerOfView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next=[next superview]) {
        UIResponder *responder = [next nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

+ (CGFloat)screenWidth
{
    return [[self class] screenSize].width;
}

+ (CGFloat)screenHeight
{
    return [[self class] screenSize].height;
}

+ (CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月d日";
    return [dateFormatter stringFromDate:date];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message byViewController:(UIViewController *)viewController
{
    if ([[UIDevice currentDevice].systemVersion floatValue] - 8.0 > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:action];
        [viewController presentViewController:alert animated:YES completion:^{
            
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [viewController.view addSubview:alertView];
    }
}

+ (BOOL)isBlankString:(NSString *)str
{
    NSMutableString *tmpStr = [NSMutableString stringWithString:str];
    [tmpStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tmpStr.length)];
    if (!tmpStr.length) {
        return YES;
    } else {
        return NO;
    }
}

@end
