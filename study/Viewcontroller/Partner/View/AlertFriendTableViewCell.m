//
//  AlertFriendTableViewCell.m
//  study
//  朋友圈发布提醒cell
//  Created by yang on 16/1/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AlertFriendTableViewCell.h"
#import "UIImageView+MJWebCache.h"

@interface AlertFriendTableViewCell ()

@property (nonatomic, strong) UIImageView *selectImage;   // 未选中
@property (nonatomic, strong) UIImageView *photoImage;    // 头像
@property (nonatomic, strong) UILabel     *nicknameLabel; // 昵称

@end

@implementation AlertFriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    
    return self;
}

- (void)setModel:(PartnerFriendIndoModel *)model {
    _model = model;
    
    self.nicknameLabel.text = model.nickname;
    [self.photoImage setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,model.photo]] placeholder:[UIImage imageNamed:@"partner_image_placeholder"]];
}

- (void)setupSubviews {
    self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(20), widget_width(36), widget_width(42), widget_width(42))];
    [self.contentView addSubview:self.selectImage];
    self.selectImage.image = [UIImage imageNamed:@"partner_publish_alert_select"];
    
    self.selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(20), widget_width(36), widget_width(42), widget_width(42))];
    [self.contentView addSubview:self.selectedImage];
    self.selectedImage.image = [UIImage imageNamed:@"partner_publish_alert_selected"];
    
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectImage.frame) + widget_width(28), widget_width(22), widget_width(70), widget_width(70))];
    [self.contentView addSubview:self.photoImage];
    [self.photoImage.layer setMasksToBounds:YES];
    [self.photoImage.layer setCornerRadius:widget_width(35)];
    
    self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoImage.frame) + widget_width(28), widget_width(42), Main_Width - CGRectGetMaxX(self.photoImage.frame), widget_width(30))];
    [self.contentView addSubview:self.nicknameLabel];
}

@end
