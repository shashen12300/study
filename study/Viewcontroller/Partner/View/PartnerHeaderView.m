//
//  PartnerHeaderView.m
//  study
//
//  Created by yang on 15/10/27.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "PartnerHeaderView.h"
#import "UIImageView+MJWebCache.h"
#import "PartnerPraiseModel.h"
#import "JZCommon.h"
#import "CAttributeString.h"
#import "UIImageView+MJWebCache.h"

#define contentWidth Main_Width - widget_width(200)

@interface PartnerHeaderView ()

@property (nonatomic, strong) UIImageView *photoImage;       // 头像
@property (nonatomic, strong) UILabel *nicknameLabel;        // 昵称
@property (nonatomic, strong) UIImageView *locationImage;    // 地址
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *contentLabel;         // 内容
@property (nonatomic, strong) UILabel *addTimeLabel;         // 时间
@property (nonatomic, strong) UILabel *praiseCountLabel;
@property (nonatomic, strong) UIButton *commentBut;          // 评论
@property (nonatomic, strong) UIButton *delImageBut;         // 删除
@property (nonatomic, strong) UIImageView *praiseImage;      // 显示点赞的人信息
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UILabel *lectureLabel;      // 大课简介
@property (nonatomic, strong) UILabel *titleLabel;        // 大课名字
@property (nonatomic, strong) UIImageView *subjectImage;  // 大课科目

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation PartnerHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    self.photoImage.frame = CGRectMake(widget_width(24), widget_width(30), widget_width(80), widget_width(80));
    self.nicknameLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImage.frame) + widget_width(20), CGRectGetMinY(self.photoImage.frame), contentWidth, widget_width(28));
    
    if (self.model.model.content.length != 0) {
        int height = [[self class] descHeight:self.model.model.content descWidth:contentWidth];
        
        if (height > widget_width(72)) {
            if (self.isAllContent) {
                self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.nicknameLabel.frame) + widget_width(16), contentWidth, height);
                self.allContentLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.contentLabel.frame) + widget_width(10), contentWidth, widget_width(24));
            }else {
                self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.nicknameLabel.frame) + widget_width(16), contentWidth, widget_width(72));
                self.allContentLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.contentLabel.frame) + widget_width(10), contentWidth, widget_width(24));
            }
            
            self.allContentLabel.hidden = NO;
        }else {
            self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.nicknameLabel.frame) + widget_width(16), contentWidth, height);
            self.allContentLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.contentLabel.frame), contentWidth, widget_width(0));
            
            self.allContentLabel.hidden = YES;
        }
        
        self.contentLabel.hidden = NO;
    }else {
        self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.nicknameLabel.frame), contentWidth, 0);
        self.allContentLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.contentLabel.frame), contentWidth, widget_width(0));
        self.contentLabel.hidden = YES;
        self.allContentLabel.hidden = YES;
    }
    
    self.pictureBackImage.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.allContentLabel.frame), widget_width(550), 0);
    self.pictureBackImage.hidden = YES;
    if (self.model.model.photourl.length != 0) {
        NSArray *array = [self.model.model.photourl componentsSeparatedByString:@";"];
        
        int height = 0;
        if (array.count < 4) {
            height = widget_width(142);
        }else if (array.count < 7) {
            height = widget_width(304);
        }else {
            height = widget_width(466);
        }
        
        self.pictureBackImage.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.allContentLabel.frame) + widget_width(16), widget_width(466), height);
        self.pictureBackImage.hidden = NO;
    }
    
    if (self.model.model.picurl.length != 0) {
        self.pictureBackImage.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.allContentLabel.frame) + widget_width(16), widget_width(550), widget_width(120));
        
        self.subjectImage.frame = CGRectMake(widget_width(126), widget_width(17), widget_width(18), widget_width(28));
        self.titleLabel.frame = CGRectMake(widget_width(160), widget_width(18), widget_width(370), widget_width(26));
        self.lectureLabel.frame = CGRectMake(widget_width(126), CGRectGetMaxY(self.subjectImage.frame) + widget_width(10), widget_width(404), widget_width(48));
        self.pictureBackImage.hidden = NO;
    }
    
    if (self.model.model.location.length != 0) {
        self.locationImage.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.pictureBackImage.frame) + widget_width(16), widget_width(14), widget_width(18));
        self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.locationImage.frame) + widget_width(10), CGRectGetMinY(self.locationImage.frame), contentWidth - widget_width(24), widget_width(18));
        self.locationImage.hidden = NO;
        self.locationLabel.hidden = NO;
    }else {
        self.locationImage.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.pictureBackImage.frame), widget_width(14), 0);
        self.locationImage.hidden = YES;
        self.locationLabel.hidden = YES;
    }
    
    self.addTimeLabel.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.locationImage.frame) + widget_width(16), contentWidth, widget_width(18));
    
    // 扩大不太通点击范围
    self.praiseBut.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame) - widget_width(20), CGRectGetMaxY(self.addTimeLabel.frame) + widget_width(16) - widget_width(20), widget_width(34) + widget_width(40), widget_width(30) + widget_width(40));
//    self.praiseCountLabel.frame = CGRectMake(CGRectGetMaxX(self.praiseBut.frame) + widget_width(12) - widget_width(20), CGRectGetMinY(self.praiseBut.frame) + widget_width(3) + widget_width(20), widget_width(50), widget_width(24));
    self.commentBut.frame = CGRectMake(CGRectGetMaxX(self.praiseBut.frame) + widget_width(50) - widget_width(20) - widget_width(20), CGRectGetMinY(self.praiseBut.frame), widget_width(34) + widget_width(40), widget_width(30) + widget_width(40));
    
    self.delImageBut.frame = CGRectMake(Main_Width - widget_width(78) - widget_width(20), CGRectGetMinY(self.praiseBut.frame), widget_width(28) + widget_width(40), widget_width(30) + widget_width(40));
    
    if (self.model.userPraise.count != 0) {
        self.praiseImage.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.praiseBut.frame) + widget_width(18) - widget_width(20), widget_width(18), widget_width(16));
        self.praiseLabel.frame = CGRectMake(CGRectGetMaxX(self.praiseImage.frame) + widget_width(14), CGRectGetMaxY(self.praiseBut.frame) + widget_width(16) - widget_width(20), contentWidth - widget_width(30), widget_width(22));
        self.praiseImage.hidden = NO;
        self.praiseLabel.hidden = NO;
    }else {
        self.praiseImage.frame = CGRectMake(CGRectGetMinX(self.nicknameLabel.frame), CGRectGetMaxY(self.praiseBut.frame), widget_width(22), 0);
        self.praiseLabel.frame = CGRectMake(CGRectGetMaxX(self.praiseImage.frame) + widget_width(14), CGRectGetMaxY(self.praiseBut.frame), contentWidth - widget_width(30), 0);
        self.praiseImage.hidden = YES;
        self.praiseLabel.hidden = YES;
    }
}

- (void)setModel:(PartnerAllModel *)model {
    _model = model;
    
    if (model.model.userId == [[UserInfoList loginUserId] integerValue]) {
        self.delImageBut.hidden = NO;
        model.model.nickname = [UserInfoList loginUserNickname];
        model.model.phone = [[UserInfoList loginUserPhone] integerValue];
        model.model.signature = [UserInfoList loginUserSignature];
        model.model.photo = [UserInfoList loginUserPhoto];
    }else {
        self.delImageBut.hidden = YES;
    }
    
    [self.photoImage setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,model.model.photo]] placeholder:[UIImage imageNamed:@"partner_photo"]];
    
    self.nicknameLabel.text = model.model.nickname;
    self.contentLabel.text = model.model.content;
    self.locationLabel.text = model.model.location;
    self.addTimeLabel.text = [JZCommon showTime:model.model.addTime];
    
    if (model.userPraise.count != 0) {
        NSMutableArray *arr = [NSMutableArray new];
        
        for (PartnerPraiseModel *praiseModel in model.userPraise) {
            if (praiseModel.userId == [[UserInfoList loginUserId] integerValue]) {
                praiseModel.nickname = [UserInfoList loginUserNickname];
            }
            [arr addObject:praiseModel.nickname];
        }
        
        NSString *string = [arr componentsJoinedByString:@","];
        self.praiseLabel.text = string;
    }else {
        self.praiseLabel.text = @"";
    }
    
    if (model.model.picurl.length != 0) {
        if (model.model.addtimeB.length != 0) {
            self.lectureLabel.text = [NSString stringWithFormat:@"%@  %@",model.model.subject,model.model.grade];
            self.titleLabel.text = model.model.titleB;
        }
    }else {
        self.lectureLabel.text = @"";
        self.titleLabel.text = @"";
    }
    
    NSArray *array = [NSArray new];
    NSMutableArray *mutArray = [NSMutableArray new];
    
    if (model.model.photourl.length != 0) {
        array = [model.model.photourl componentsSeparatedByString:@";"];
        
        for(UIView *view in [self.pictureBackImage subviews]) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        self.pictureBackImage.userInteractionEnabled = YES;
        for (int i = 0; i < array.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(162*(i%3)), widget_width(162*(i/3)), widget_width(142), widget_width(142))];
            imageView.userInteractionEnabled = YES;
            [self.pictureBackImage addSubview:imageView];
            [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,array[i]]] placeholder:[UIImage imageNamed:@"partner_image_placeholder"]];
            UITapGestureRecognizer *imageGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didShowPicture:)];
            [imageView addGestureRecognizer:imageGR];
            
            [mutArray addObject:imageView];
        }
    }
    
    self.imageViews = [NSMutableArray arrayWithArray:mutArray];
    
    if (model.model.picurl.length != 0) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(18), widget_width(16), widget_width(88), widget_width(88))];
        [self.pictureBackImage addSubview:image];
        image.userInteractionEnabled = YES;
        [image setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,model.model.picurl]] placeholder:[UIImage imageNamed:@"partner_image_placeholder"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play:)];
        [image addGestureRecognizer:tap];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(22), widget_width(22), widget_width(40), widget_width(40))];
        [image addSubview:playImage];
        playImage.image = [UIImage imageNamed:@"partner_play"];
    }
}

#pragma mark - inner methods
- (void)setupSubviews {
    self.photoImage = [[UIImageView alloc] init];
    [self addSubview:self.photoImage];
    self.photoImage.userInteractionEnabled = YES;
    [self.photoImage.layer setMasksToBounds:YES];
    [self.photoImage.layer setCornerRadius:widget_width(40)];
    UITapGestureRecognizer *photoGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPersonalInformation)];
    [self.photoImage addGestureRecognizer:photoGR];
    
    self.nicknameLabel = [[self class] labelWithFont:28 textColor:UIColorFromRGB(0xff7949)];
    [self addSubview:self.nicknameLabel];
    
    self.contentLabel = [[self class] labelWithFont:24 textColor:UIColorFromRGB(0x575757)];
    [self addSubview:self.contentLabel];
    self.contentLabel.numberOfLines = 0;
    
    self.allContentLabel = [[self class] labelWithFont:24 textColor:UIColorFromRGB(0x575757)];
    [self addSubview:self.allContentLabel];
    self.allContentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowAllContentAction)];
    [self.allContentLabel addGestureRecognizer:tapAll];
    
    self.pictureBackImage = [[UIImageView alloc] init];
    self.pictureBackImage.userInteractionEnabled = YES;
    [self addSubview:self.pictureBackImage];
    
    self.lectureLabel = [[self class] labelWithFont:22 textColor:UIColorFromRGB(0x737373)];
    [self.pictureBackImage addSubview:self.lectureLabel];
    self.lectureLabel.numberOfLines = 0;
    
    self.titleLabel = [[self class] labelWithFont:24 textColor:UIColorFromRGB(0x575757)];
    [self.pictureBackImage addSubview:self.titleLabel];
    
    self.subjectImage = [[UIImageView alloc] init];
    [self.pictureBackImage addSubview:self.subjectImage];
    
    self.locationImage = [[UIImageView alloc] init];
    [self addSubview:self.locationImage];
    self.locationImage.image = [UIImage imageNamed:@"partner_location"];
    
    self.locationLabel = [[self class] labelWithFont:18 textColor:UIColorFromRGB(0xa3a3a3)];
    [self addSubview:self.locationLabel];
    
    self.addTimeLabel = [[self class] labelWithFont:18 textColor:UIColorFromRGB(0xa3a3a3)];
    [self addSubview:self.addTimeLabel];
    
    self.praiseBut = [[self class] buttonWithImageName:@"partner_praiseBut" target:self selector:@selector(handlePraiseAction:)];
    [self addSubview:self.praiseBut];
    
    self.praiseCountLabel = [[self class] labelWithFont:28 textColor:UIColorFromRGB(0xa3a3a3)];
    [self addSubview:self.praiseCountLabel];
    
    self.commentBut = [[self class] buttonWithImageName:@"partner_commentBut" target:self selector:@selector(handleCommentAction:withEvent:)];
    [self addSubview:self.commentBut];
    
    self.delImageBut = [[self class] buttonWithImageName:@"partner_delImage" target:self selector:@selector(showDelImage:)];
    [self addSubview:self.delImageBut];
    
    self.praiseImage = [UIImageView new];
    [self addSubview:self.praiseImage];
    self.praiseImage.image = [UIImage imageNamed:@"partner_praise"];
    
    self.praiseLabel = [[self class] labelWithFont:22 textColor:UIColorFromRGB(0xff7949)];
    [self addSubview:self.praiseLabel];
}

- (void)didShowPicture:(UITapGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(showImagesWithImageViews:selectedView:)]) {
        [self.delegate showImagesWithImageViews:self.imageViews selectedView:(UIImageView *)gestureRecognizer.view];
    }
}

- (void)play:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(playWithLectureId:)]) {
        [self.delegate playWithLectureId:self.model.model.lecrureId];
    }
}

- (void)pushPersonalInformation {
    if ([self.delegate respondsToSelector:@selector(pushPersonalHistorySyntonyWithSection:)]) {
        [self.delegate pushPersonalHistorySyntonyWithSection:self.section];
    }
}

- (void)handlePraiseAction:(UIButton *)but {
    but.userInteractionEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(handlePraiseSyntonyWithSection:)]) {
        [self.delegate handlePraiseSyntonyWithSection:self.section];
    }
}

- (void)handleCommentAction:(UIButton *)but withEvent:(UIEvent*)event {
    if ([self.delegate respondsToSelector:@selector(handleCommentSyntonyWithSection:withEvent:withBut:)]) {
        [self.delegate handleCommentSyntonyWithSection:self.section withEvent:event withBut:but];
    }
}

- (void)showDelImage:(UIButton *)but {
    if ([self.delegate respondsToSelector:@selector(showDelImageSyntonyWithSection:)]) {
        [self.delegate showDelImageSyntonyWithSection:self.section];
    }
}

- (void)handleShowAllContentAction {
    if ([self.delegate respondsToSelector:@selector(handleShowAllContentSyntonyWithSection:)]) {
        [self.delegate handleShowAllContentSyntonyWithSection:self.section];
    }
}

// 计算内容的高度
+ (CGFloat)descHeight:(NSString *)content descWidth:(NSInteger)width {
    CGSize textSize = [CAttributeString heightOfString:content font:12 maxWidth:width offY:-8];
    
    return textSize.height + widget_width(5);
}
// 计算view高度
+ (CGFloat)viewHeight:(PartnerAllModel *)model withShowAllContent:(BOOL)isAll {
    int height = widget_width(30);
    height += widget_width(28);
    
    height += widget_width(16);
    if (model.model.content.length != 0) {
        int contentHeight = [self descHeight:model.model.content descWidth:contentWidth];
        
        if (contentHeight > widget_width(72)) {
            if (isAll) {
                height += contentHeight;
                height += widget_width(10);
                height += widget_width(24);
            }else {
                height += widget_width(72);
                height += widget_width(10);
                height += widget_width(24);
            }
        }else {
            height += contentHeight;
        }
        
    }else {
        height -= widget_width(16);
    }
    
    height += widget_width(16);
    if (model.model.photourl.length != 0) {
        NSArray *array = [model.model.photourl componentsSeparatedByString:@";"];
        
        if (array.count < 4) {
            height += widget_width(142);
        }else if (array.count < 7) {
            height += widget_width(304);
        }else {
            height += widget_width(466);
        }
    }else {
        height -= widget_width(16);
    }
    
    height += widget_width(16);
    if (model.model.picurl.length != 0) {
        height += widget_width(120);
    }else {
        height -= widget_width(16);
    }
    
    height += widget_width(16);
    if (model.model.location.length != 0) {
        height += widget_width(18);
    }else {
        height -= widget_width(16);
    }
    
    height += widget_width(16);
    height += widget_width(18);
    
    height += widget_width(16);
    height += widget_width(30);
    
    height += widget_width(16);
    if (model.userPraise.count != 0) {
        height += widget_width(22);
    }else {
        height -= widget_width(16);
    }
    
    return height;
}

+ (UIButton *)buttonWithImageName:(NSString *)image target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setContentMode:UIViewContentModeCenter];
    
    return button;
}

+ (UILabel *)labelWithFont:(NSInteger)font textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font/2];
    
    return label;
}

@end
