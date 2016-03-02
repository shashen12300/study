//
//  PartnerFirstHeaderView.h
//  study
//  朋友圈第一个header
//  Created by yang on 16/1/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PartnerFirstHeaderViewDelegate <NSObject>
/**
 *  更换背景
 */
- (void)changeBackgroundView;
/**
 *  跳转到动态
 *
 *  @param userId 用户id
 */
- (void)pushToHistry;

@end

@interface PartnerFirstHeaderView : UIView

@property (nonatomic, weak) id <PartnerFirstHeaderViewDelegate> delegate;

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy)   NSString *picture;          // 背景图
@property (nonatomic, copy)   NSString *nickname;         // 昵称
@property (nonatomic, copy)   NSString *photo;            // 头像
@property (nonatomic, copy)   NSString *signature;        // 个性签名

/**
 *  赋值
 */
- (void)reloadValue;

@end
