//
//  PersonHistoryTableViewCell.m
//  study
//
//  Created by mijibao on 15/9/17.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//
#import "PersonHistoryTableViewCell.h"
#import "CAttributeString.h"
#import "JZCommon.h"
#import "UIImageView+MJWebCache.h"
#import "XHImageViewer.h"

#define contentWidth (Main_Width - widget_width(200))

@interface PersonHistoryTableViewCell ()

@property (nonatomic, strong) UILabel *contentLabel;  // 内容
@property (nonatomic, strong) UILabel *picCountLabel; // 图片计数
@property (nonatomic, strong) UILabel *titleLabel;    // 大课名字
@property (nonatomic, strong) UILabel *lectureIntro;  // 大课简介
@property (nonatomic, strong) UIImageView *lectureImage;  // 科目图片
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation PersonHistoryTableViewCell

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
    self.lineImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.lineImage];
    
    self.dayLabel = [[self class] labelWithTextColor:UIColorFromRGB(0xffffff) backGroundColor:UIColorFromRGB(0xff7949) font:14 cornerRadius:widget_width(21)];
    [self.contentView addSubview:self.dayLabel];

    self.monthLabel = [[self class] labelWithTextColor:UIColorFromRGB(0xff7949) backGroundColor:UIColorFromRGB(0xffffff) font:10 cornerRadius:widget_width(15)];
    [self.contentView addSubview:self.monthLabel];
    [self.monthLabel.layer setBorderWidth:widget_width(3)];
    [self.monthLabel.layer setBorderColor:UIColorFromRGB(0xff7949).CGColor];

    self.backImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.backImageView];
    self.backImageView.userInteractionEnabled = YES;
    
    self.lectureImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.lectureImage];
    
    self.contentLabel = [[self class] labelWithTextColor:UIColorFromRGB(0x656565) font:12];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.numberOfLines = 0;
    
    self.picCountLabel = [[self class] labelWithTextColor:UIColorFromRGB(0xa3a3a3) font:9];
    [self.contentView addSubview:self.picCountLabel];

    self.titleLabel = [[self class] labelWithTextColor:UIColorFromRGB(0x656565) font:12];
    [self.contentView addSubview:self.titleLabel];

    self.lectureIntro = [[self class] labelWithTextColor:UIColorFromRGB(0xa3a3a3) font:11];
    [self.contentView addSubview:self.lectureIntro];
}

- (void)setModel:(PartnerAllModel *)model {
    _model = model;
    
    [self resetFrame];
    
    self.contentLabel.text = model.model.content;
    
    NSRange range1 = NSMakeRange(8, 2);
    self.dayLabel.text = [model.model.addTime substringWithRange:range1];
    
    NSRange range2 = NSMakeRange(5, 2);
    NSRange range3 = NSMakeRange(6, 1);
    if ([[model.model.addTime substringWithRange:range2] integerValue] < 10) {
        self.monthLabel.text = [model.model.addTime substringWithRange:range3];
    }else {
        self.monthLabel.text = [model.model.addTime substringWithRange:range2];
    }
    
    NSArray *array = [NSMutableArray new];
    if (model.model.photourl.length != 0) {
        array = [model.model.photourl componentsSeparatedByString:@";"];
        if (array.count > 1) {
            self.picCountLabel.text = [NSString stringWithFormat:@"共%lu张",(unsigned long)array.count];
        }else {
            self.picCountLabel.text = @"";
        }
    }else {
        self.picCountLabel.text = @"";
    }
    
    if (model.model.picurl.length != 0) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@  %@",model.model.subject,model.model.grade];
        self.titleLabel.text = model.model.titleB;
    }else {
        self.titleLabel.text = @"";
    }
    
    // cell复用 每次都移除绘制的image
    if (self.lineImage) {
        self.lineImage.image = nil;
    }
    
    int cellHeight = [[self class] cellHeight:model];

    self.lineImage.frame = CGRectMake(widget_width(50), 0, 1 * [[UIScreen mainScreen] scale], cellHeight);
    UIGraphicsBeginImageContext(self.lineImage.frame.size);   //开始画线
    [self.lineImage.image drawInRect:CGRectMake(0, 0, self.lineImage.frame.size.width, self.lineImage.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {6,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor redColor].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0);    //开始画线
    CGContextAddLineToPoint(line, 0, cellHeight);
    CGContextStrokePath(line);
//    UIGraphicsEndImageContext();
    self.lineImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    for(UIView *view in [self.backImageView subviews])
    {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    NSArray *arr = [NSArray new];
    NSMutableArray *mutArray = [NSMutableArray new];
    if (model.model.photourl.length != 0) {
        arr = [model.model.photourl componentsSeparatedByString:@";"];
        if (arr.count == 1) {
            UIImageView *image = [self imageViewWithFrame:CGRectMake(0, 0, widget_width(138), widget_width(138)) urlString:arr[0]];
            [self.backImageView addSubview:image];
            image.tag = 1 + (self.indexPath.row + 1) * 1000;
            
            [mutArray addObject:image];
        }else if (arr.count == 2) {
            for (int i = 0; i < array.count; i++) {
                UIImageView *image = [self imageViewWithFrame:CGRectMake(widget_width(72)*i, 0, widget_width(66), widget_width(138)) urlString:arr[i]];
                [self.backImageView addSubview:image];
                image.tag = i + (self.indexPath.row + 1) * 1000;
                
                [mutArray addObject:image];
            }
        }else if (arr.count == 3) {
            for (int i = 0; i < 2; i++) {
                UIImageView *image = [self imageViewWithFrame:CGRectMake(0, widget_width(72)*i, widget_width(66), widget_width(66)) urlString:arr[i]];
                [self.backImageView addSubview:image];
                image.tag = i + (self.indexPath.row + 1) * 1000;
                
                [mutArray addObject:image];
            }
            
            UIImageView *image = [self imageViewWithFrame:CGRectMake(widget_width(72), 0, widget_width(66), widget_width(138)) urlString:arr[2]];
            [self.backImageView addSubview:image];
            image.tag = 3 + (self.indexPath.row + 1) * 1000;
            
            [mutArray addObject:image];
        }else {
            for (int i = 0; i < 4; i++) {
                UIImageView *image = [self imageViewWithFrame:CGRectMake(widget_width(72)*(i%2), widget_width(72)*(i/2), widget_width(66), widget_width(66)) urlString:arr[i]];
                [self.backImageView addSubview:image];
                image.tag = i + (self.indexPath.row + 1) * 1000;
                
                [mutArray addObject:image];
            }
        }
    }
    self.imageViews = [NSMutableArray arrayWithArray:mutArray];
    
    if (model.model.picurl.length != 0) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(20), widget_width(15), widget_width(90), widget_width(90))];
        [self.backImageView addSubview:image];
        image.userInteractionEnabled = YES;
        image.tag = (self.indexPath.row + 1) * 100;
        [image setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,model.model.picurl]] placeholder:[UIImage imageNamed:@"partner_image_placeholder"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play:)];
        [image addGestureRecognizer:tap];
        
        UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(30), widget_width(30), widget_width(30), widget_width(30))];
        [image addSubview:playImage];
        playImage.image = [UIImage imageNamed:@"partner_play"];
    }
}

// 根据模型改变frame
- (void)resetFrame {
    int cellHeight = [[self class] cellHeight:self.model];
    self.lineImage.frame = CGRectMake(widget_width(50), 0, widget_width(2), cellHeight);
    
    self.dayLabel.frame = CGRectMake(widget_width(30), widget_width(30), widget_width(42), widget_width(42));
    
    self.monthLabel.frame = CGRectMake(widget_width(35), cellHeight - widget_width(40), widget_width(30), widget_width(30));
    if (self.model.model.photourl.length != 0) {
        self.backImageView.frame = CGRectMake(widget_width(120), widget_width(30), widget_width(138), widget_width(138));
        
        int height = [[self class] descHeight:self.model.model.content descWidth:(contentWidth - widget_width(160))];
        height = (height > widget_width(100)) ? widget_width(100) : height;
        self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.backImageView.frame) + widget_width(20), widget_width(30), contentWidth - widget_width(160), height);
        self.picCountLabel.frame = CGRectMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.backImageView.frame) - widget_width(20), contentWidth, widget_width(18));
    }else {
        if (self.model.model.content.length != 0) {
            int height = [[self class] descHeight:self.model.model.content descWidth:contentWidth];
            self.contentLabel.frame = CGRectMake(widget_width(120), widget_width(30), contentWidth - widget_width(160), height);
            if (self.model.model.picurl.length != 0) {
                self.backImageView.frame = CGRectMake(widget_width(120), CGRectGetMaxY(self.contentLabel.frame) + widget_width(16), widget_width(550), widget_width(120));
            }else {
                self.backImageView.frame = CGRectMake(widget_width(120), CGRectGetMaxY(self.contentLabel.frame), widget_width(550), 0);
            }
        }else {
            if (self.model.model.picurl.length != 0) {
                self.backImageView.frame = CGRectMake(widget_width(120), widget_width(30), widget_width(550), widget_width(120));
            }else {
                self.backImageView.frame = CGRectMake(widget_width(120), widget_width(30), widget_width(550), 0);
            }
        }
    }

}

// 点击展示图片
- (void)didTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(showImagesWithImageViews:selectedView:)]) {
        [self.delegate showImagesWithImageViews:self.imageViews selectedView:(UIImageView *)gestureRecognizer.view];
    }
}

// 播放视频
- (void)play:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(playWithLectureId:)]) {
        [self.delegate playWithLectureId:self.model.model.lecrureId];
    }
}

//计算内容的高度
+ (CGFloat)descHeight:(NSString *)content descWidth:(NSInteger)width
{
    CGSize textSize = [CAttributeString heightOfString:content font:12 maxWidth:width offY:-10];
    
    return textSize.height + widget_width(5);
}

// 计算cell高度
+ (CGFloat)cellHeight:(PartnerAllModel *)model
{
    int cellHeight = widget_width(30);
    if (model.model.photourl.length != 0) {
        cellHeight += widget_width(138);
    }else {
        if (model.model.content.length != 0) {
            int height = [[self class] descHeight:model.model.content descWidth:contentWidth];
            cellHeight += height;
        }
        if (model.model.picurl.length != 0) {
            cellHeight += widget_width(120);
        }
    }

    return cellHeight + widget_width(10);
}


+ (UILabel *)labelWithTextColor:(UIColor *)color
                backGroundColor:(UIColor *)backColor
                           font:(NSInteger)font
                   cornerRadius:(NSInteger)cornerRadius
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.backgroundColor = backColor;
    label.font = [UIFont systemFontOfSize:font];
    [label.layer setMasksToBounds:YES];
    [label.layer setCornerRadius:cornerRadius];
    
    return label;
}

+ (UILabel *)labelWithTextColor:(UIColor *)color
                           font:(NSInteger)font
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    
    return label;
}

// 生成imageview
- (UIImageView *)imageViewWithFrame:(CGRect)frame urlString:(NSString *)string {
    UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
    image.userInteractionEnabled = YES;
    [image setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,string]] placeholder:[UIImage imageNamed:@"partner_image_placeholder"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGestureRecognizer:)];
    [image addGestureRecognizer:tap];
    
    return image;
}

@end
