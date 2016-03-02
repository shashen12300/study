//
//  PartnerView.m
//  study
//
//  Created by yang on 15/9/24.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PartnerView.h"
#import "UIImageView+MJWebCache.h"
#import "PartnerPraiseModel.h"
#import "JZCommon.h"
#import "CAttributeString.h"

#define contentWidth Main_Width - widget_width(162) - widget_width(112)

@interface PartnerView ()

@property (nonatomic, strong) UILabel *cameraLabel;  // 相机
@property (nonatomic, strong) UILabel *albumLabel;   // 相册

@property (nonatomic, strong) UIView *lineView;

@end

@implementation PartnerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:widget_width(10)];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, widget_width(56), widget_width(400), widget_width(2))];
    self.lineView.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [self addSubview:self.lineView]; 
    self.lineView.alpha = 1;
    
    self.cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, widget_width(58), widget_width(400), widget_width(56))];
    self.cameraLabel.textAlignment = NSTextAlignmentCenter;
    self.cameraLabel.textColor = UIColorFromRGB(0x333333);
    self.cameraLabel.text = @"拍照";
    self.cameraLabel.font = [UIFont systemFontOfSize:12];
    self.cameraLabel.userInteractionEnabled = YES;
    self.cameraLabel.alpha = 1;
    [self addSubview:self.cameraLabel];
    UITapGestureRecognizer *camTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCameraAction:)];
    [self.cameraLabel addGestureRecognizer:camTap];
    
    self.albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widget_width(400), widget_width(56))];
    self.albumLabel.textAlignment = NSTextAlignmentCenter;
    self.albumLabel.textColor = UIColorFromRGB(0x333333);
    self.albumLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.albumLabel];
    self.albumLabel.text = @"手机相册中选择";
    self.albumLabel.userInteractionEnabled = YES;
    self.albumLabel.alpha = 1;
    UITapGestureRecognizer *albTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAlbumAction:)];
    [self.albumLabel addGestureRecognizer:albTap];
}

- (void)handleCameraAction:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(handleCameraSyntony)]) {
        [self.delegate handleCameraSyntony];
    }
}

- (void)handleAlbumAction:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(handleAlbumSyntony)]) {
        [self.delegate handleAlbumSyntony];
    }
}

- (void)changeAlbumName:(NSString *)name {
    self.albumLabel.text = name;
}

- (void)changeCameraName:(NSString *)name {
    self.cameraLabel.text = name;
}

@end
