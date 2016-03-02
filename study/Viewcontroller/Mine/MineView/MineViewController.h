//
//  MineViewController.h
//  study
//
//  Created by mijibao on 15/9/2.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface MineViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *presenceFromUser;//添加好友请求信息

@end
