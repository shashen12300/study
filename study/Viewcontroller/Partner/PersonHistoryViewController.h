//
//  PersonHistoryViewController.h
//  study
//  朋友圈动态界面
//  Created by mijibao on 15/9/17.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonHistoryViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;  // 数据数组
@property (nonatomic, strong) UITableView *tableView;     // tableView

@property (nonatomic, assign) NSInteger userId;           // 用户id
@property (nonatomic, copy)   NSString *picture;          // 背景图
@property (nonatomic, copy)   NSString *nickname;         // 昵称
@property (nonatomic, copy)   NSString *photo;            // 头像
@property (nonatomic, copy)   NSString *signature;        // 个性签名

/**
 *  初始化方法
 *
 *  @param isMyself YES : 自己     NO : 其他人
 *
 *  @return
 */
- (instancetype)initWithPerson:(BOOL)isMyself;

@end
