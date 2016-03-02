//
//  AlertFriendViewController.h
//  study
//  朋友圈发布提醒界面
//  Created by yang on 16/1/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BaseViewController.h"

@protocol AlertFriendViewControllerDelegate <NSObject>

- (void)alertFriendWithDataArray:(NSArray *)dataArray logArray:(NSArray *)logArray;

@end

@interface AlertFriendViewController : BaseViewController

@property (nonatomic, weak)   id<AlertFriendViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *infoArray;

@end
