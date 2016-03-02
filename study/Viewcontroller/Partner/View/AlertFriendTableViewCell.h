//
//  AlertFriendTableViewCell.h
//  study
//  朋友圈发布提醒cell
//  Created by yang on 16/1/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerFriendIndoModel.h"

@interface AlertFriendTableViewCell : UITableViewCell

@property (nonatomic, strong) PartnerFriendIndoModel *model;
@property (nonatomic, strong) UIImageView *selectedImage;      // 选中

@end
