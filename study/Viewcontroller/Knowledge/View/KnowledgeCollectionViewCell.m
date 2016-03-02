//
//  KnowledgeCollectionViewCell.m
//  study
//
//  Created by mijibao on 16/1/20.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "KnowledgeCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface KnowledgeCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *subjectImageView; //科目类型
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;   //视频缩略图
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;           //题目
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;         //内容
@property (weak, nonatomic) IBOutlet UIImageView *costImageView;    //收费

@end

@implementation KnowledgeCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KView" owner:self options:nil]objectAtIndex:0];
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}

//model赋值
-(void)configLectrueTableViewCell:(LectureModel *)model
{
    NSURL *picUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/studyManager%@",SERVER_ADDRESS,model.picurl]];
    [_videoImageView setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _titleLabel.text = model.title;
    
    //_contentLabel.text = [NSString stringWithFormat:@"%@ %@",model.grade,model.subject];//@"高一  数学";
    _contentLabel.text = [NSString stringWithFormat:@"%@",model.content];//@"高一  数学";
    _subjectImageView.image = [UIImage imageNamed:model.subject];
    if ([model.clickcount integerValue]>0) {
        _costImageView.image = [UIImage imageNamed:@"shoufei"];
        _costImageView.hidden = NO;
    }
    else {
        _costImageView.hidden = YES;
    }
}

@end
