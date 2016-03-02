//
//  PartnerFirstHeaderView.m
//  study
//
//  Created by yang on 16/1/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PartnerFirstHeaderView.h"
#import "UIImageView+MJWebCache.h"

@interface PartnerFirstHeaderView ()

@property (nonatomic, strong) UIImageView *headerBackImageView; // 背景
@property (nonatomic, strong) UIImageView *circleImage;         // 头像
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *sigLabel;

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;  // 毛玻璃效果

@end

@implementation PartnerFirstHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    self.headerBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.headerBackImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.headerBackImageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.headerBackImageView.clipsToBounds  = YES;
    self.headerBackImageView.userInteractionEnabled = YES;
    [self addSubview:self.headerBackImageView];
    
    UIBlurEffect *blerEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blerEffect];
    self.visualEffectView.frame = self.headerBackImageView.frame;
    [self addSubview:self.visualEffectView];
    self.visualEffectView.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTopImageView:)];
    [self.visualEffectView addGestureRecognizer:tap];
    
    self.circleImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2 - widget_width(84), widget_width(136), widget_width(168), widget_width(168))];
    self.circleImage.userInteractionEnabled = YES;
    [self.circleImage.layer setMasksToBounds:YES];
    [self.circleImage.layer setCornerRadius:widget_width(84)];
    [self.circleImage.layer setBorderWidth:widget_width(3)];
    [self.circleImage.layer setBorderColor:UIColorFromRGB(0xff7949).CGColor];
    [self addSubview:self.circleImage];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToHistry:)];
    [self.circleImage addGestureRecognizer:tap2];
    
    self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.circleImage.frame) + widget_width(26), Main_Width, widget_width(32))];
    self.nicknameLabel.font = [UIFont systemFontOfSize:16];
    self.nicknameLabel.textColor = [UIColor whiteColor];
    self.nicknameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nicknameLabel];
    self.nicknameLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    self.nicknameLabel.shadowOffset = CGSizeMake(1.0,1.0);
    
    self.sigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nicknameLabel.frame) + widget_width(18), Main_Width, widget_width(24))];
    self.sigLabel.font = [UIFont systemFontOfSize:12];
    self.sigLabel.textColor = [UIColor whiteColor];
    self.sigLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.sigLabel];
}

- (void)didClickTopImageView:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(changeBackgroundView)]) {
        [self.delegate changeBackgroundView];
    }
}

- (void)pushToHistry:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(pushToHistry)]) {
        [self.delegate pushToHistry];
    }
}

- (void)reloadValue {
    NSString *str = self.picture;
    if (str.length != 0) {
        CGSize imageSize = CGSizeMake(50, 50);
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[UIColor grayColor] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.headerBackImageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,str]] placeholder:pressedColorImg];
    }else {
        self.headerBackImageView.image = [UIImage imageNamed:@"partner_ default"];
    }
    
    [self.circleImage setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,self.photo]] placeholder:[UIImage imageNamed:@"partner_photo"]];

    self.nicknameLabel.text = self.nickname;
    self.sigLabel.text = self.signature;
}

@end
