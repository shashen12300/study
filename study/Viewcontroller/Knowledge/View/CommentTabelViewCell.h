//
//  CommentTabelViewCell.h
//  study
//
//  Created by mijibao on 16/1/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@protocol CommentTableViewCellDelegate <NSObject>

- (void)displayAllComment:(NSIndexPath *)indexPath;

@end

@interface CommentTabelViewCell : UITableViewCell

@property (nonatomic, strong) CommentModel *message; //消息
@property (nonatomic, assign) CGFloat cellHeight;   //cell高度
@property (nonatomic, weak)id<CommentTableViewCellDelegate>delegate;

@end
