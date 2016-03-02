//
//  PHDetailTableViewCell.m
//  study
//
//  Created by yang on 15/9/23.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PHDetailTableViewCell.h"
#import "CAttributeString.h"
#import "UIImageView+MJWebCache.h"
#import "JZCommon.h"


@interface PHDetailTableViewCell ()

@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *addTimeLabel;
@property (nonatomic, strong) UIImageView *nickImage;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PHDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

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

- (void)setupSubviews {
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.commentLabel];
    self.commentLabel.font = [UIFont systemFontOfSize:10];
    self.commentLabel.textColor = UIColorFromRGB(0x333333);
    
    self.commentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.commentLabel addGestureRecognizer:tap];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.font = [UIFont systemFontOfSize:10];
    self.nickNameLabel.textColor = UIColorFromRGB(0x0180c2);
    [self.contentView addSubview:self.nickNameLabel];
    
    self.addTimeLabel = [[UILabel alloc] init];
    self.addTimeLabel.font = [UIFont systemFontOfSize:10];
    self.addTimeLabel.tintColor = UIColorFromRGB(0x828282);
    [self.contentView addSubview:self.addTimeLabel];
    self.addTimeLabel.textAlignment = NSTextAlignmentRight;
    
    self.nickImage = [[UIImageView alloc] init];
    [self.nickImage.layer setMasksToBounds:YES];
    [self.nickImage.layer setCornerRadius:widget_width(35)];
    [self.contentView addSubview:self.nickImage];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = UIColorFromRGB(0xbbbbbb);
    [self.contentView addSubview:self.lineView];
}

- (void)setCommentArray:(NSMutableArray *)commentArray {
    _commentArray = commentArray;
}

- (void)setModel:(PartnerCommentModel *)model {
    if (model.userId == [userID integerValue]) {
        model.nickname = [UserInfoList loginUserNickname];
    }
    
    _model = model;
    
    self.nickNameLabel.text = model.nickname;
    
    if (model.commentedId != 0) {
        NSString *str = [self sd_commentedId:model.commentedId withArray:self.commentArray];
        NSString *string = [NSString stringWithFormat:@"回复%@ : %@",str,model.commentDetail];
        NSMutableAttributedString *s = [CAttributeString emotionStrWithString:string offY:-8];
        NSRange range1 = [string rangeOfString:@"回复"];
        NSRange range2 = [[string substringFromIndex:range1.length] rangeOfString:str];
        range2.location = range1.length + range2.location;
        [s addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0180c2) range:range2];
        self.commentLabel.attributedText = s;
    }else {
        self.commentLabel.text = model.commentDetail;
    }
    
    self.addTimeLabel.text = [JZCommon showTime:model.addTime];
    
    [self.nickImage setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,model.photo]] placeholder:[UIImage imageNamed:@"partner_headImagePlaceholder"]];
}

- (void)layoutSubviews {
    self.nickImage.frame = CGRectMake(widget_width(156), widget_width(10), widget_width(70), widget_width(70));
    
    self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.nickImage.frame) + widget_width(15), CGRectGetMinY(self.nickImage.frame) + widget_width(12), widget_width(280), widget_width(22));
    
    self.addTimeLabel.frame = CGRectMake(Main_Width - widget_width(224), CGRectGetMinY(self.nickNameLabel.frame), widget_width(200), widget_width(22));
    
    CGFloat height = 0;
    if (self.model.commentedId == 0) {
        height = [[self class] descHeight:self.model.commentDetail descWidth:widget_width(480)];
    }else {
        NSString *str = [self sd_commentedId:self.model.commentedId withArray:self.commentArray];
        NSString *string = [NSString stringWithFormat:@"回复%@ : %@",str,self.model.commentDetail];
        height = [[self class] descHeight:string descWidth:widget_width(480)];
    }
    
    self.commentLabel.frame = CGRectMake(CGRectGetMinX(self.nickNameLabel.frame), CGRectGetMaxY(self.nickNameLabel.frame) + widget_width(5), widget_width(480), height);
    
    self.lineView.frame = CGRectMake(CGRectGetMinX(self.nickImage.frame), CGRectGetMaxY(self.commentLabel.frame) + widget_width(20), widget_width(565), 0.25 * [[UIScreen mainScreen] scale]);
    if (height < widget_width(26)) {
        self.lineView.frame = CGRectMake(CGRectGetMinX(self.nickImage.frame), widget_width(98), widget_width(565), 0.25 * [[UIScreen mainScreen] scale]);
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    if (self.model.userId == [userID integerValue]) {
        if ([self.delegate respondsToSelector:@selector(longPressWithPartnerCommentModel:withIndexPath:)]) {
            [self.delegate longPressWithPartnerCommentModel:self.model withIndexPath:self.indexPath];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(tapIndexPath:withGes:)]) {
            [self.delegate tapIndexPath:self.indexPath withGes:gesture];
        }
    }
}

#pragma mark - 返回查找到用户的昵称的字符串
- (NSString *)sd_commentedId:(NSInteger)Cid withArray:(NSMutableArray *)array
{
    NSString *HFnick = [[NSString alloc] init];
    for (PartnerCommentModel *model in array) {
        if (model.commentId == Cid) {
            if (model.userId == [userID integerValue]) {
                model.nickname = [UserInfoList loginUserNickname];
            }
            HFnick = model.nickname;
        }
    }
    return HFnick;
}

#pragma mark - 计算高度
//计算内容的高度
+ (CGFloat)descHeight:(NSString *)content descWidth:(NSInteger)width
{
    CGSize textSize = [CAttributeString heightOfString:content font:10 maxWidth:width offY:-8];
    
    return textSize.height;
}



@end
