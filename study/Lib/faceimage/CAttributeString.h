//
//  CAttributeString.h
//  CoreTextDemo
//
//  Created by mijibao on 15/9/7.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CAttributeString : NSObject

/**
 *  将带有表情符的文字转换为图文混排的文字
 *
 *  @param text      带表情符的文字
 *  @param offY      图片的y偏移值
 *
 *  @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text offY:(CGFloat)offY;

/**
 *  将个别文字转换为特殊的图片
 *
 *  @param string    原始文字段落
 *  @param text      特殊的文字
 *  @param imageName 要替换的图片
 *
 *  @return  NSMutableAttributedString
 */
+ (NSMutableAttributedString *)exchangeString:(NSString *)string withText:(NSString *)text imageName:(NSString *)imageName;

/**
 *  计算文本高度
 *
 *  @param string    原始文字段落
 *  @param font      字体大小
 *  @param maxWidth  最大宽度
 *  @param offY      图片的y偏移值
 *
 *  @return  CGSize
 */
+ (CGSize)heightOfString:(NSString *)string font:(CGFloat)font maxWidth:(CGFloat)maxWidth offY:(CGFloat)offY;

@end
