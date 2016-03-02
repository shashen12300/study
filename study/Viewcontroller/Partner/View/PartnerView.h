//
//  PartnerView.h
//  study
//  自定义提示框
//  Created by yang on 15/9/24.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerAllModel.h"

@protocol PartnerViewDelegate <NSObject>

@optional
/**
 *  相机
 */
- (void)handleCameraSyntony;
/**
 *  相册
 */
- (void)handleAlbumSyntony;

@end

@interface PartnerView : UIView

@property (nonatomic, weak) id<PartnerViewDelegate> delegate;

- (void)changeAlbumName:(NSString *)name;   // 更换相机名称
- (void)changeCameraName:(NSString *)name;  // 更换相册名称

@end

