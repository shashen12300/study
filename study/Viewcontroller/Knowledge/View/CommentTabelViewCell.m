//
//  CommentTabelViewCell.m
//  study
//
//  Created by mijibao on 16/1/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CommentTabelViewCell.h"
#import "UIViewExt.h"
#import "LectureLeafModel.h"
#import "SecondCommentButton.h"

@interface CommentTabelViewCell()

@property (nonatomic, strong) UIImageView *headImageView; //评论照片
@property (nonatomic, strong) UILabel *nameLabel;  //评论名字
@property (nonatomic, strong) UILabel *timeLabel;  //评论时间
@property (nonatomic, strong) UILabel *contentLabel;  //评论内容
@property (nonatomic, strong) UIImageView *bubbleImageView; //评论气泡
@property (nonatomic, strong) UITableView *secondTabeView;  //二级评论
@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, strong) SecondCommentModel *commentModel;  //cell数据
@property (nonatomic, assign) CGFloat secondCellHeight;

@end

@implementation CommentTabelViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:  reuseIdentifier];
    if (self) {
//        self = [[[NSBundle mainBundle] loadNibNamed:@"KView" owner:self options:nil]objectAtIndex:2];
        [self creatCellUI];
    }
    return self;
}

- (void)creatCellUI {
    //头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    [self.contentView addSubview:_headImageView];
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_headImageView)+10, 5, 50, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = RGBVCOLOR(0x3F3834);
    [self.contentView addSubview:_nameLabel];
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_nameLabel)+5, 7, 90, 18)];
    _timeLabel.font = [UIFont systemFontOfSize:9];
    _timeLabel.textColor = RGBVCOLOR(0xA6A6A6);
    [self.contentView addSubview:_timeLabel];
    //内容
    NSLog(@"一级cell宽度 ： %f",WIDTH(self.contentView));
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_headImageView)+10, MaxY(_nameLabel)+5, Main_Width-MaxX(_headImageView)-30, 30)];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = RGBVCOLOR(0x808080);
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    //气泡
    _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MinX(_contentLabel), MaxY(_contentLabel), WIDTH(_contentLabel), 30)];
    UIImage *qipaoImage = [UIImage imageNamed:@"qipao"];
    qipaoImage = [qipaoImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    _bubbleImageView.userInteractionEnabled = YES;
    _bubbleImageView.hidden = YES;
    [_bubbleImageView setImage:qipaoImage];
    [self.contentView addSubview:_bubbleImageView];
//    _secondTabeView = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, WIDTH(_bubbleImageView)-10, 20) style:UITableViewStylePlain];
//    _secondTabeView.backgroundColor = [UIColor redColor];
//    _secondTabeView.scrollEnabled = NO;
//    _secondTabeView.delegate =self;
//    _secondTabeView.dataSource = self;
//    [_bubbleImageView addSubview:_secondTabeView];
}

//设置cell内容和高度
- (void)setMessage:(CommentModel *)message {
    for (UIView *btn in _bubbleImageView.subviews) {
            [btn removeFromSuperview];
    }
    _message = message;
    _headImageView.image = [UIImage imageNamed:message.image];
    _nameLabel.text = message.name;
    _timeLabel.text = message.time;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSLog(@"宽度 : %f",WIDTH(_contentLabel));
   CGSize contentSize = [_message.content boundingRectWithSize:CGSizeMake(WIDTH(_contentLabel), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    _contentLabel.height = contentSize.height + 10;
    _bubbleImageView.top = MaxY(_contentLabel);
    _contentLabel.text = message.content;
    _sourceArray = message.commentArray;
    if (message.commentArray.count>0) {
        _bubbleImageView.hidden = NO;
        CGFloat commentHeight = 0;
        for (int i = 0; i < _sourceArray.count; ++i) {
            LectureLeafModel *leaf = [LectureLeafModel insLeafWithDict:_sourceArray[i]];
            SecondCommentButton *commentBtn = [[SecondCommentButton alloc] initWithFrame:CGRectMake(5, 5 + commentHeight, WIDTH(_bubbleImageView) - 5 * 2, 20)];
            commentBtn.frame = CGRectMake(5, 5 + commentHeight, WIDTH(_bubbleImageView) - 5 * 2, 20);
            commentBtn.tag = i;
            [commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bubbleImageView addSubview:commentBtn];
            _commentModel = [[SecondCommentModel alloc] init];
            _commentModel.image = @"touxiang";
            _commentModel.name = leaf.name;
            _commentModel.content = leaf.intro;
            _commentModel.time = leaf.icon;
            commentBtn.message = _commentModel;
            commentHeight = MaxY(commentBtn);
            if (i == 2&&!_message.isOpened) {
                UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                moreBtn.frame = CGRectMake(5, 5 + commentHeight, WIDTH(_bubbleImageView) - 5 * 2, 20);
                [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [moreBtn setTitle:@"查看全部回复" forState:UIControlStateNormal];
                [moreBtn setTitleColor:lightColor forState:UIControlStateNormal];
                [_bubbleImageView addSubview:moreBtn];
                commentHeight = MaxY(moreBtn);

                break;
            }
        }
        _bubbleImageView.height = commentHeight + 2;
        _cellHeight = MaxY(_bubbleImageView) + 10;

    }else {
        _bubbleImageView.hidden = YES;
        _cellHeight = MaxY(_contentLabel);
    }
}

- (void)moreBtnClick:(UIButton *)sender {
    _message.opened = YES;
    if ([self.delegate respondsToSelector:@selector(displayAllComment:)]) {
        [self.delegate displayAllComment:_message.indexPath];
    }
    
}

- (void)commentBtnClick:(UIButton *)sender {
    NSLog(@"点击tag : %ld",(long)sender.tag);
}

@end
