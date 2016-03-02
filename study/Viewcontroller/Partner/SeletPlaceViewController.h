//
//  SeletPlaceViewController.h
//  study
//  朋友圈发布选择地点界面
//  Created by mijibao on 15/8/29.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "BaseViewController.h"


@protocol  SeletPlaceViewControllerDelegate <NSObject>
/**
 *  返回选择地点信息
 *
 *  @param place 选择地点信息
 */
- (void)selectPlace:(NSDictionary *)place;

@end

@interface SeletPlaceViewController : BaseViewController


@property (nonatomic, weak) id<SeletPlaceViewControllerDelegate> delegate;

@end
