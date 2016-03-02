//
//  PartnerViewCell.m
//  study
//
//  Created by yang on 15/10/29.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "PartnerViewCell.h"
#import "CAttributeString.h"

@interface PartnerViewCell ()

@property (nonatomic, strong) MLEmojiLabel *commentLabel;  // 评论内容

@end

@implementation PartnerViewCell

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
        
        self.commentLabel = [[MLEmojiLabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.commentLabel];
        self.commentLabel.backgroundColor = [UIColor clearColor];
        self.commentLabel.font = [UIFont systemFontOfSize:12];
        self.commentLabel.textColor = UIColorFromRGB(0x575757);
        self.commentLabel.userInteractionEnabled = YES;
        self.commentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        self.commentLabel.customEmojiPlistName = @"expressionImage_custom.plist";
        self.commentLabel.delegate = self;
    }
    return self;
}

- (void)setCommentArray:(NSMutableArray *)commentArray {
    _commentArray = commentArray;
}

- (void)setModel:(PartnerCommentModel *)model {
    if (model.userId == [[UserInfoList loginUserId] integerValue]) {
        model.nickname = [UserInfoList loginUserNickname];
    }
    
    _model = model;
    
    if (model.commentedId == 0) {
        NSString *string = [NSString stringWithFormat:@"%@ : %@",model.nickname,model.commentDetail];

        NSRange range2 = [string rangeOfString:model.nickname];
        
        self.commentLabel.text = string;
        // 改变字体颜色
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.commentLabel.linkAttributes];
        [dic setValue:UIColorFromRGB(0xff7949) forKey:(NSString *)kCTForegroundColorAttributeName];
        self.commentLabel.linkAttributes = dic;
        [self.commentLabel addLinkToURL:[NSURL URLWithString:@"http://sasasadan.com"] withRange:range2];
        
    }else {
        NSString *str = [self sd_commentedId:model.commentedId withArray:self.commentArray];
        NSString *string = [NSString stringWithFormat:@"%@回复%@ : %@",model.nickname,str,model.commentDetail];
       
        NSRange range1 = [string rangeOfString:model.nickname];
        NSRange range2 = [[string substringFromIndex:range1.length] rangeOfString:@"回复"];
        range2.location = range1.length + range2.location;
        NSRange range3 = [[string substringFromIndex:range2.length + range1.length] rangeOfString:str];
        range3.location = range1.length + range2.length + range3.location;

        self.commentLabel.text = string;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.commentLabel.linkAttributes];
        [dic setValue:UIColorFromRGB(0xff7949) forKey:(NSString *)kCTForegroundColorAttributeName];
        self.commentLabel.linkAttributes = dic;
        [self.commentLabel addLinkToURL:[NSURL URLWithString:@"http://sasasadan.com"] withRange:range1];
        [self.commentLabel addLinkToPhoneNumber:@"12112112312" withRange:range3];
    }
}

- (void)layoutSubviews {
    CGFloat height = 0;
    if (self.model.commentedId == 0) {
        NSString *string = [NSString stringWithFormat:@"%@ : %@",self.model.nickname,self.model.commentDetail];
        height = [[self class] descHeight:string descWidth:Main_Width - widget_width(274)];
    }else {
        NSString *str = [self sd_commentedId:self.model.commentedId withArray:self.commentArray];
        NSString *string = [NSString stringWithFormat:@"%@回复%@ : %@",self.model.nickname,str,self.model.commentDetail];
        height = [[self class] descHeight:string descWidth:Main_Width - widget_width(274)];
    }
    
    self.commentLabel.frame = CGRectMake(widget_width(126), widget_width(5), Main_Width - widget_width(274), height);
}

#pragma mark - MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"点击了某个自添加链接%@",url);
    
    if ([self.delegate respondsToSelector:@selector(pushToHistoryWithFeedId:)]) {
        [self.delegate pushToHistoryWithFeedId:self.model.feedId];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"点击了某个自添加电话%@",phoneNumber);

    for (PartnerCommentModel *model in self.commentArray) {
        if (model.commentId == self.model.commentedId) {
            
            if ([self.delegate respondsToSelector:@selector(pushToHistoryWithFeedId:)]) {
                [self.delegate pushToHistoryWithFeedId:model.feedId];
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [[event touchesForView:self.commentLabel] anyObject];
    
    if ([touch.view isKindOfClass:[MLEmojiLabel class]]) {        
        if (self.model.userId == [[UserInfoList loginUserId] integerValue]) {
            if ([self.delegate respondsToSelector:@selector(tapWithPartnerCommentModel:withIndexPath:)]) {
                [self.delegate tapWithPartnerCommentModel:self.model withIndexPath:self.indexPath];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(tapIndexPath:withEvent:withLabel:)]) {
                [self.delegate tapIndexPath:self.indexPath withEvent:event withLabel:self.commentLabel];
            }
        }
        
    }else {
        return;
    }
}

#pragma mark - inner methods
// 返回查找到用户的昵称的字符串
- (NSString *)sd_commentedId:(NSInteger)Cid withArray:(NSMutableArray *)array
{
    NSString *HFnick = [[NSString alloc] init];
    for (PartnerCommentModel *model in array) {
        if (model.commentId == Cid) {
            if (model.userId == [[UserInfoList loginUserId] integerValue]) {
                model.nickname = [UserInfoList loginUserNickname];
            }
            HFnick = model.nickname;
        }
    }
    return HFnick;
}

+ (CGFloat)descHeight:(NSString *)content descWidth:(NSInteger)width {
    static MLEmojiLabel *protypeLabel = nil;
    if (!protypeLabel) {
        protypeLabel = [MLEmojiLabel new];
        protypeLabel.numberOfLines = 0;
        
        protypeLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    }
    
    [protypeLabel setText:content];
    protypeLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    protypeLabel.customEmojiPlistName = @"expressionImage_custom.plist";
    
    CGSize size = [protypeLabel preferredSizeWithMaxWidth:width];
    
    return size.height;
}


@end
