//
//  PersonHistoryDetailViewController.h
//  study
//  朋友圈详情界面
//  Created by yang on 15/9/23.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "BaseViewController.h"
#import "PartnerAllModel.h"

@protocol PartnerHistoryDelegate <NSObject>
/**
 *  删除动态回调
 *
 *  @param indexPath 在动态界面的位置
 */
- (void)deleteModelWithIndexPath:(NSInteger)indexPath;

@end


@interface PersonHistoryDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;                    // 全部数据(跳到动态时需要)
@property (nonatomic, strong) PartnerAllModel *model;                // 该详情model

@property (nonatomic, weak)   id<PartnerHistoryDelegate> delegate;
@property (nonatomic, assign) NSInteger index;                        // 该动态在动态界面的位置

@end
