//
//  HJChatImageView.h
//  study
//
//  Created by jzkj on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,HJChatImageStyle){
    HJChatImageStyleLeft,
    HJChatImageStyleRight
};

@interface HJChatImageView : UIView
@property (nonatomic , strong) UIImage* image;//图片
@property (nonatomic , strong) CALayer* contentLayer;//底图需要设置frame
/**
 *  初始化配置
 *
 *  @param style 展示风格
 *  @param frame frame
 *
 *  @return 视图
 */
- (instancetype)initWithImageStyle:(HJChatImageStyle)style Frame:(CGRect)frame;
/**
 *  设置图片视图
 */
- (void)setup;
@end
