//
//  PartnerHeaderView.h
//  study
//  朋友圈动态展示view
//  Created by yang on 15/10/27.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerAllModel.h"

@protocol PartnerHeaderViewDelegate <NSObject>
/**
 *  跳转到个人动态
 *
 *  @param section 第几个cell
 */
- (void)pushPersonalHistorySyntonyWithSection:(NSInteger)section;
/**
 *  点赞 取消点赞
 *
 *  @param section 第几个cell
 */
- (void)handlePraiseSyntonyWithSection:(NSInteger)section;
/**
 *  评论
 *
 *  @param section 第几个cell
 *  @param event   事件信息
 *  @param but
 */
- (void)handleCommentSyntonyWithSection:(NSInteger)section withEvent:(UIEvent*)event withBut:(UIButton *)but;
/**
 *  删除动态
 *
 *  @param section 第几个cell
 */
- (void)showDelImageSyntonyWithSection:(NSInteger)section;
/**
 *  展开内容
 *
 *  @param section 第几个cell
 */
- (void)handleShowAllContentSyntonyWithSection:(NSInteger)section;
/**
 *  展示图片
 *
 *  @param imageArr  要展示的图片数组
 *  @param imageView 展示的图片
 */
- (void)showImagesWithImageViews:(NSArray *)imageArr selectedView:(UIImageView *)imageView;
/**
 *
 *
 *  @param lectureId 大课id
 */
- (void)playWithLectureId:(NSString *)lectureId;

@end

@interface PartnerHeaderView : UIView

@property (nonatomic, assign) NSInteger section;             // 第几个cell

@property (nonatomic, strong) UIImageView *pictureBackImage; // 图片
@property (nonatomic, strong) UIButton *delLabelBut;         // 删除
@property (nonatomic, strong) UIButton *praiseBut;           // 赞
@property (nonatomic, strong) UILabel *allContentLabel;      // 展开按钮

@property (nonatomic, assign) BOOL isAllContent;             // 全部内容

@property (nonatomic, strong) PartnerAllModel *model;
@property (nonatomic, weak) id<PartnerHeaderViewDelegate> delegate;

/**
 *  view高度
 *
 *  @param model 
 *  @param isAll 内容是否展开  YES:展开  NO:未展开
 *
 *  @return view高度
 */
+ (CGFloat)viewHeight:(PartnerAllModel *)model withShowAllContent:(BOOL)isAll;

@end
