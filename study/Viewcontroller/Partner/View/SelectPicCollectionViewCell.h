//
//  SelectPicCollectionViewCell.h
//  study
//  选择图片cell
//  Created by mijibao on 15/9/8.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPicCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView    *photoImageView;    // 相册图片
@property (nonatomic,strong) UIImageView    *borderImageView;   // 未选中
@property (nonatomic,strong) UIImageView    *selectImageView;   // 选择

@end
