//
//  PartnerInfoOneTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PartnerInfoOneTableViewCell.h"
#import "PartnerInfoCollectionViewCell.h"
#import "ImageRequestCore.h"

static NSString * _sectionIdentifier = @"sectionIdentifier";

@implementation PartnerInfoOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //行标签
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSString *string1 = @"所获荣誉：";
        CGSize size1 = [string1 sizeWithAttributes:dic];
        //左侧标签
        _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(13 , 0, size1.width, widget_height(70))];
        _signLabel.textAlignment = NSTextAlignmentLeft;
        _signLabel.font = [UIFont systemFontOfSize:13];
        _signLabel.textColor = UIColorFromRGB(0x656565);
        [self.contentView addSubview:_signLabel];
        //右侧内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_signLabel), 3, Main_Width -  widget_width(280), widget_height(70))];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = UIColorFromRGB(0x8e8e8e);
        [self.contentView addSubview:_contentLabel];
        //我的荣誉内容
        _contentText = [[UITextView alloc] initWithFrame:CGRectMake(MaxX(_signLabel), 3, Main_Width -  widget_width(280), widget_height(70))];
        _contentText.textAlignment = NSTextAlignmentLeft;
        _contentText.font = [UIFont systemFontOfSize:13];
        _contentText.textColor = UIColorFromRGB(0x8e8e8e);
        _contentText.showsVerticalScrollIndicator = NO;
        _contentText.showsHorizontalScrollIndicator = NO;
        _contentText.scrollEnabled = YES;
        _contentText.userInteractionEnabled = YES;
        [self.contentView addSubview:_contentText];
        
        //个人发布和教学视频
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setItemSize:CGSizeMake(widget_width(108), widget_height(82))];//设置cell的尺寸
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, widget_width(30));//设置其边界
        
        //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(MaxX(_signLabel), (widget_height(124) - widget_height(82)) * 0.5, widget_width(108) * 4 + widget_width(30) * 3 , widget_height(82)) collectionViewLayout:flowLayout];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.scrollEnabled = NO;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.showsVerticalScrollIndicator = NO;
        _collection.userInteractionEnabled = NO;
        _collection.backgroundColor = [UIColor whiteColor];
        [_collection registerClass:[PartnerInfoCollectionViewCell class] forCellWithReuseIdentifier:_sectionIdentifier];
        [self.contentView addSubview:_collection];
    }
    return self;
}

- (void)drawLabelFrame:(NSString *)string cellHeight:(CGFloat)cellHeight contentHeight:(CGFloat)honorsHeight
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize size = [string sizeWithAttributes:dic];
    _signLabel.frame = CGRectMake(13 , 0, size.width, cellHeight);
    _contentLabel.frame = CGRectMake(MaxX(_signLabel), 0, Main_Width -  widget_width(280), cellHeight);
    _contentText.frame = CGRectMake(MaxX(_signLabel), 0, Main_Width -  widget_width(280), honorsHeight);
}

- (void)drawSignLabelFrame
{
    _signLabel.frame = CGRectMake(0 , 0, Main_Width, 40);
    _signLabel.backgroundColor = UIColorFromRGB(0xff6949);
    _signLabel.textColor = [UIColor whiteColor];
    _signLabel.font = [UIFont systemFontOfSize:16];
    _signLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_signLabel];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PartnerInfoCollectionViewCell *cell = (PartnerInfoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_sectionIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [ImageRequestCore requestImageWithPath:_colletionArray[indexPath.row] withImageView:cell.imageView placeholderImage:nil];
    return cell;
}

- (void)reloadDataofCollectionView:(NSArray *)array
{
    _colletionArray = [[NSArray alloc] initWithArray:array];
    [_collection reloadData];
}
@end
