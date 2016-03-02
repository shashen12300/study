//
//  BaseViewController.h
//  vms
//
//  Created by jzkj on 15/11/18.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Reachability.h>

@interface BaseViewController : UIViewController

//设置导航条的状态（显示或隐藏）
- (void)setNavigationState:(BOOL)isHidden;

//导航条的颜色
- (void)setNavigationBarColor:(UIColor *)color;
//图片
- (void)setNavigationBarBgImg:(NSString *)imgName;
//标题
- (void)setNavigationTitle:(NSString *)string;
- (void)setNavigationBarTitle:(NSString *)string withColor:(UIColor *)color;
- (void)setNavigationBarTitle:(NSString *)string withColor:(UIColor *)color WithFontSize:(CGFloat)size;
- (void)setNavigationBarTitle:(NSString *)string withColor:(UIColor *)color WithFontName:(NSString *)fontName WithFontSize:(CGFloat)size;

//返回按钮
- (void)setBackBarButtonItemTitle:(NSString *)string;
//按钮
- (UIButton *)createBtnWithFrame:(CGRect)frame withTitle:(NSString *)title;
- (UIButton *)createBtnWithFrame:(CGRect)frame withTitle:(NSString *)title withImageName:(NSString *)image;

- (void)layoutFrontViewWithOffset:(CGFloat)xoffset;
- (void)autoLayFrontViewController:(BOOL)animated withCurrentXoffset:(CGFloat)xoffset rightOrLeft:(BOOL)rightOrLeft;
//
/**
 *  创建导航栏按钮
 *
 *  @param name      title
 *  @param imageName 图片
 *  @param target    目标
 *  @param selector  方法
 *
 *  @return 按钮
 */
- (UIBarButtonItem *)addItemWithTitle:(NSString *)name imageName:(NSString *)imageName target:(id)target action:(SEL)selector;

//网络
- (NetworkStatus)checkCurrentNetWork;

@end
