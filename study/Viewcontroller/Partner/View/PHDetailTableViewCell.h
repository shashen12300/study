//
//  PHDetailTableViewCell.h
//  study
//
//  Created by yang on 15/9/23.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerCommentModel.h"

@protocol PHDetailTableViewCellDelegate <NSObject>

- (void)tapIndexPath:(NSIndexPath *)indexPath withGes:(UITapGestureRecognizer *)gesture;
- (void)longPressWithPartnerCommentModel:(PartnerCommentModel *)model withIndexPath:(NSIndexPath *)indexPath;

@end

@interface PHDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id<PHDetailTableViewCellDelegate> delegate;

@property (nonatomic, strong) PartnerCommentModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSMutableArray *commentArray;


//计算内容的高度
+ (CGFloat)descHeight:(NSString *)content descWidth:(NSInteger)width;

@end
