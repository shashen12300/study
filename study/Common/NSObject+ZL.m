
//
//  NSObject+ZL.m
//  soul_ios
//
//  Created by JZL on 15/7/29.
//  Copyright (c) 2015年 soul. All rights reserved.
//

#import "NSObject+ZL.h"


@implementation NSObject (ZL)

/// 获取内容高度
- (CGFloat)heightWithContent:(NSString *)contentStr font:(UIFont *)font constraintWidth:(CGFloat)width{
    CGSize size = [self sizeWithContent:contentStr font:font size:CGSizeMake(width, 1000)];
    return size.height;
}

// 自动调整size
- (CGSize)sizeWithContent:(NSString *)contentStr font:(UIFont *)font size:(CGSize)size{
    CGSize resultSize = [contentStr sizeWithFont:font constrainedToSize:CGSizeMake(size.width, 1000)];
    return resultSize;
}


- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image action:(SEL)sel {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    //    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark -
- (NSString *)noticeStrWithDetailStr:(NSString *)detailStr{
    NSString *noticeStr = @"";
    NSRange startRange = [detailStr rangeOfString:@"【"];
    NSRange endRange = [detailStr rangeOfString:@"】"];
    if ((startRange.location == 0) && startRange.length && endRange.length) {
        NSRange noticeRange = NSMakeRange(startRange.location, endRange.location+1);
        noticeStr = [detailStr substringWithRange:noticeRange];
    }
    return noticeStr;
}

#pragma mark - 
- (BOOL)storeData:(id)dataSource withFileName:(NSString *)fileName{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataSource];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullpath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", fileName]];
    return [data writeToFile:fullpath atomically:YES];
}
- (id)getDataWithFileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullpath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", fileName]];
    NSData *data = [NSData dataWithContentsOfFile:fullpath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
