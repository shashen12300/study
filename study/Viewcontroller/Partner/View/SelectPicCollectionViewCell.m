//
//  SelectPicCollectionViewCell.m
//  study
//
//  Created by mijibao on 15/9/8.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "SelectPicCollectionViewCell.h"

@implementation SelectPicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat cellWidth = self.contentView.frame.size.width;
        CGFloat cellHeight = self.contentView.frame.size.height;
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth,cellHeight)];
        [self.contentView addSubview:self.photoImageView];
        
        self.borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth-widget_width(7+28), widget_height(7), widget_width(28), widget_width(28))];
        self.borderImageView.image = [UIImage imageNamed:@"partner_publish_picture_select"];
        [self.contentView addSubview:self.borderImageView];
        
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth-widget_width(7+28), widget_height(7), widget_width(28), widget_width(28))];
        self.selectImageView.image = [UIImage imageNamed:@"partner_publish_picture_selected"];
        self.selectImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.selectImageView];
    }
    return self;
}

@end
