//
//  UserInfoViewController.h
//  study
//
//  Created by mijibao on 15/9/20.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadFileCore.h"
#import "UserInfoCore.h"


@interface UserInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate, UploadDelegate, UserInfoCoreDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIImage *headImage;


@end
