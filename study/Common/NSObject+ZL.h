//
//  NSObject+ZL.h
//  soul_ios
//
//  Created by JZL on 15/7/29.
//  Copyright (c) 2015年 soul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZL)

/// 获取文本高度  需要传入内容， 字体，宽度
- (CGFloat)heightWithContent:(NSString *)contentStr font:(UIFont *)font constraintWidth:(CGFloat)width;
/// 获取文本size 需要传入内容， 字体， size，宽度
- (CGSize)sizeWithContent:(NSString *)contentStr font:(UIFont *)font size:(CGSize)size;

/// 
- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image action:(SEL)sel;

/// 截取标签文本
- (NSString *)noticeStrWithDetailStr:(NSString *)detailStr;


/// 持久存储历史数据
- (BOOL)storeData:(id)dataSource withFileName:(NSString *)fileName;
/// 取出数据
- (id)getDataWithFileName:(NSString *)fileName;




@end
