//
//  PublishTableViewCell.m
//  study
//  
//  Created by yang on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PublishTableViewCell.h"
#import "PartnerFriendIndoModel.h"
#import "UIImageView+MJWebCache.h"

#define contentWidth (Main_Width - widget_width(140))

@interface PublishTableViewCell ()

@property (nonatomic, strong) UIImageView *jumpImage;  // 图片

@end

@implementation PublishTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
        [self setupSubviews];
    }
    return self;
}

- (void)setAlertArray:(NSArray *)alertArray {
    _alertArray = alertArray;
    
    if (alertArray.count < 6) {
        self.showImageView.frame = CGRectMake(Main_Width - widget_width(150) - widget_width(40) - widget_width(45)*(alertArray.count - 1), widget_width(20), widget_width(40) + widget_width(40) * (alertArray.count - 1), widget_width(40));
    }else {
        self.showImageView.frame = CGRectMake(Main_Width - widget_width(150) - widget_width(220), widget_width(20), widget_width(220), widget_width(85));
    }
    
    for (UIView *view in self.showImageView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < alertArray.count; i++) {
        PartnerFriendIndoModel *model = alertArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(45*(i%5)), widget_width(45*(i/5)), widget_width(40), widget_width(40))];
        [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,model.photo]] placeholder:[UIImage imageNamed:@"partner_image_placeholder"]];
        [self.showImageView addSubview:imageView];
    }
}

#pragma mark - inner methods
- (void)setupSubviews {
    self.showImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.showImage];
    
    self.showLabel = [[UILabel alloc] init];
    self.showLabel.textColor = UIColorFromRGB(0x656565);
    self.showLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.showLabel];
    
    self.showImageView = [[UIView alloc] init];
    [self.contentView addSubview:self.showImageView];
    
    self.jumpImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.jumpImage];
    self.jumpImage.image = [UIImage imageNamed:@"partner_publish_ jump"];
}

- (void)reloadFrame {
    self.showImage.frame = CGRectMake(widget_width(30), self.cellHeight/2 - widget_width(13), widget_width(20), widget_width(26));
    self.showLabel.frame = CGRectMake(CGRectGetMaxX(self.showImage.frame) + widget_width(20), CGRectGetMinY(self.showImage.frame), contentWidth, widget_width(26));
    self.jumpImage.frame = CGRectMake(Main_Width - widget_width(50), self.cellHeight/2 - widget_width(10), widget_width(12), widget_width(20));
}

@end
