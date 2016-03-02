//
//  cellHeadView.m
//  study
//
//  Created by mijibao on 16/2/16.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CellHeadView.h"
#import "CellHeadViewCell.h"
#import "LectureRootGroupModel.h"
#import "CommentTabelViewCell.h"
@interface CellHeadView()

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *numLabel;


@end

@implementation CellHeadView

+ (instancetype)headViewWithTableView:(UITableView *)tableView {
    static NSString *headIdentifier = @"header";
    CellHeadView *cellHeadView = (CellHeadView *)[tableView dequeueReusableCellWithIdentifier:headIdentifier];
    if (cellHeadView == nil) {
        cellHeadView = [[self alloc]initWithReuseIdentifier:headIdentifier];
    }
    return cellHeadView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        CommentTabelViewCell *heaView = [[[NSBundle mainBundle]loadNibNamed:@"KView" owner:self options:nil]objectAtIndex:2];
        heaView.backgroundColor = [UIColor greenColor];
//        heaView.frame = self.bounds;
        [self addSubview:heaView];
        
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bgButton.frame = self.bounds;
        bgButton.backgroundColor = [UIColor clearColor];
        [bgButton addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        _bgButton = bgButton;
        
        _headTableCell = heaView;
        
        //        UILabel *numLabel = [[UILabel alloc] init];
        //        numLabel.textAlignment = NSTextAlignmentRight;
        //        [self addSubview:numLabel];
        //        _numLabel = numLabel;
        
    }
    return self;
}

- (void)headBtnClick
{
    _friendGroup.opened = !_friendGroup.isOpened;
    if ([_delegate respondsToSelector:@selector(clickHeadView)]) {
        [_delegate clickHeadView];
    }
}

- (void)setFriendGroup:(LectureRootGroupModel *)friendGroup
{
    _friendGroup = friendGroup;
    _headTableCell.message.name = @"哇哈哈";
//    _headTableCell.data.text = friendGroup.chSource;
//    _headTableCell.time.text = friendGroup.chRisen;
//    _headTableCell.source.text = friendGroup.chSource;
//    _headTableCell.station.text = friendGroup.chStation;
//    _headTableCell.descrip.text = friendGroup.chDescription;
//    _headTableCell.image.image = [UIImage imageNamed:@"root"];

}

- (void)didMoveToSuperview
{
    _bgButton.imageView.transform = _friendGroup.isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgButton.frame = self.bounds;
    //  _numLabel.frame = CGRectMake(self.frame.size.width - 70, 0, 60, self.frame.size.height);
}

@end
