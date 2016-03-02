//
//  CellHeadView.h
//  study
//
//  Created by mijibao on 16/2/16.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LectureRootGroupModel;
@class CommentTabelViewCell;
@protocol cellHeadViewDelegate <NSObject>

- (void)clickHeadView;

@end

@interface CellHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) LectureRootGroupModel *friendGroup;

@property (nonatomic, weak) id<cellHeadViewDelegate> delegate;
@property (nonatomic, strong) CommentTabelViewCell *headTableCell;

+ (instancetype)headViewWithTableView:(UITableView *)tableView;

@end
