//
//  PartnerPublishViewController.h
//  study
//  朋友圈发布界面
//  Created by yang on 15/11/11.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "BaseViewController.h"


@protocol PartnerPublishViewControllerDelegate <NSObject>

- (void)writeDynamic;

@end

@interface PartnerPublishViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *imageArray;           // 图片数组

@property (nonatomic, weak) id <PartnerPublishViewControllerDelegate> delegate;


@end
