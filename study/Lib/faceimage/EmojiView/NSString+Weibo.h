//
//  NSString+Weibo.h
//  CoreTextDemo
//
//  Created by cxjwin on 13-10-31.
//  Copyright (c) 2013年 cxjwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

extern NSString *const kCustomGlyphAttributeType;
extern NSString *const kCustomGlyphAttributeRange;
extern NSString *const kCustomGlyphAttributeImageViewName;
extern NSString *const kCustomGlyphAttributeInfo;

typedef struct CustomGlyphMetrics {
    CGFloat ascent;
    CGFloat descent;
    CGFloat width;
}CustomGlyphMetrics, *CustomGlyphMetricsRef;

typedef NS_ENUM(NSInteger, CustomGlyphAttributeType) {
    CustomGlyphAttributeURL = 0,
    CustomGlyphAttributeImage,
    CustomGlyphAttributeInfoImage,// 预留，给带相应信息的图片（如点击图片获取相关属性)
};

@interface NSString (Weibo)

- (NSMutableAttributedString *)transformTextColor:(UIColor *)textColor;

@end
