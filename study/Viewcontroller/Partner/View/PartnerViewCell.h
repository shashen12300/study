//
//  PartnerViewCell.h
//  study
//  朋友圈评论cell
//  Created by yang on 15/10/29.
//  Copyright © 2015年 jzkj. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PartnerCommentModel.h"
//#import "JHFacePlist.h"
#import "MLEmojiLabel.h"

@protocol PartnerViewCellDelegate <NSObject>
/**
 *  删除评论
 *
 *  @param model
 *  @param indexPath
 */
- (void)tapWithPartnerCommentModel:(PartnerCommentModel *)model withIndexPath:(NSIndexPath *)indexPath;
/**
 *  弹出键盘,并将点击位置移动到键盘上分
 *
 *  @param indexPath
 *  @param event
 *  @param label
 */
- (void)tapIndexPath:(NSIndexPath *)indexPath withEvent:(UIEvent *)event withLabel:(MLEmojiLabel *)label;
/**
 *  跳转到动态界面
 *
 *  @param feedId   根据feedId确定模型
 */
- (void)pushToHistoryWithFeedId:(NSInteger)feedId;

@end

@interface PartnerViewCell : UITableViewCell <MLEmojiLabelDelegate>

@property (nonatomic, weak) id<PartnerViewCellDelegate> delegate;

@property (nonatomic, strong) PartnerCommentModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSMutableArray *commentArray;


//计算内容的高度
+ (CGFloat)descHeight:(NSString *)content descWidth:(NSInteger)width;

@end
