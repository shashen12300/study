//
//  XHImageViewer.h
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHImageViewer;
@protocol XHImageViewerDelegate <NSObject>

@optional
/**
 *  图片消失
 *
 *  @param imageViewer
 *  @param selectedView
 */
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView*)selectedView;
/**
 *  保存图片到相册
 *
 *  @param imageViewer
 *  @param image        要保存的图片
 */
- (void)imageViewer:(XHImageViewer *)imageViewer withWillSaveImage:(UIImage *)image;

@end

@interface XHImageViewer : UIView

@property (nonatomic, weak) id<XHImageViewerDelegate> delegate;
@property (nonatomic, assign) CGFloat backgroundScale;

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView;
- (id)initWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView;
@end
