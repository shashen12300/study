//
//  UIButton+ImageTitleStyle.h
//
//  Created by tianlinchun on 15/8/1.
//  Copyright (c) 2015年 tianlinchun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleToButtonLeftPotentialWidth 7

@interface UIButton (ImageTitleStyle)

/*
 使用方法，导入.h文件即可调用增添方法
 */

// 图上 字下
- (void)setTopImageSize:(CGSize)imageSize imageTopHeight:(float)imageTop titleBottomHeight:(float)titleBottom;

// 字上 图下
- (void)setBottomImageSize:(CGSize)imageSize imageBottomHeight:(float)imageBottom titleTopHeight:(float)titleTop;

// 图左 字右
- (void)setLeftImageSize:(CGSize)imageSize imageLeftWidth:(float)imageLeft titleToImageWidth:(float)titleToImageWidth;

// 字左 图右
- (void)setRightImageSize:(CGSize)imageSize imageRightWidth:(float)imageRight titleToImageWidth:(float)titleToImageWidth;


// 设置文字
- (void)setTitle:(NSString *)title;

// 文字字体
- (void)setTitleFont:(UIFont *)font;

// 正常 高亮 选中 图片
- (void)setNMImage:(UIImage *)image HLImage:(UIImage *)hlImage SELImage:(UIImage *)selImage;

// 正常 高亮 选中背景图片
- (void)setBGNMImage:(UIImage *)nmImage HLImage:(UIImage *)hlImage SELImage:(UIImage *)selImage;

// 正常 高亮 选中 文字颜色
- (void)setTitleNMColor:(UIColor *)nmColor HLColor:(UIColor *)hlColor SELColor:(UIColor *)selColor;

@end




