//
//  PartnerInfoCollectionViewCell.m
//  study
//
//  Created by mijibao on 16/2/18.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PartnerInfoCollectionViewCell.h"

@implementation PartnerInfoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widget_width(108), widget_height(82))];
        [self.contentView addSubview:_imageView];
    }
    return self;
}


@end
