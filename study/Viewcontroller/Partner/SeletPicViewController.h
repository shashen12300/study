//
//  SeletPicViewController.h
//  study
//  朋友圈选择图片界面
//  Created by mijibao on 15/8/29.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "BaseViewController.h"


@protocol SeletPicViewControllerDelegate <NSObject>

/**
 *  返回选择的图片数组
 *
 *  @param imageArr 选择的图片数组
 */
- (void)selectPicWithImages:(NSArray *)imageArr;

@end

@interface SeletPicViewController : BaseViewController

@property (nonatomic, assign) NSInteger maxSelext;             // 可选最大图片数
@property (nonatomic, strong) NSMutableArray *selectImages;    // 选择图片数组
@property (nonatomic, weak) id <SeletPicViewControllerDelegate> delegate;


@end
